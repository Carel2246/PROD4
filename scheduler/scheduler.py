"""
Skeduleerder-enjin: Laai data, bou skedule, en gee resultate terug.
Gebruik OR-tools vir gevorderde skedulering.
"""
import psycopg2
from ortools.sat.python import cp_model
from datetime import datetime, timedelta
from working_minutes import load_working_hours, convert_schedule_minutes_to_datetimes

class SchedulerEngine:
    def __init__(self, db_config=None):
        self.db_config = db_config or {
            "host": "nmiserver.postgres.database.azure.com",
            "dbname": "jobshopdb",
            "user": "myadmin",
            "password": "dXCwCluFm8*PYK",
            "port": 5432
        }

    def get_stage1_tasks(self):
        # 1. Get all busy & not completed tasks
        conn = psycopg2.connect(**self.db_config)
        cur = conn.cursor()
        cur.execute("""
            SELECT t.id, t.task_number, t.job_number, t.description, t.setup_time, t.time_each, t.predecessors, t.resources, t.completed, t.busy, j.quantity
            FROM task t
            JOIN job j ON t.job_number = j.job_number
            WHERE t.completed = FALSE AND t.busy = TRUE AND j.completed = FALSE AND j.blocked = FALSE
        """)
        busy_rows = cur.fetchall()

        # 2. Build a dict of all tasks for quick lookup
        cur.execute("""
            SELECT t.id, t.task_number, t.job_number, t.description, t.setup_time, t.time_each, t.predecessors, t.resources, t.completed, t.busy, j.quantity
            FROM task t
            JOIN job j ON t.job_number = j.job_number
            WHERE j.completed = FALSE AND j.blocked = FALSE
        """)
        all_rows = cur.fetchall()
        all_tasks = {row[1]: row for row in all_rows}  # key = task_number

        # 3. Recursively add incomplete predecessors
        def add_with_predecessors(task_row, result_dict):
            task_number = task_row[1]
            if task_number in result_dict:
                return
            result_dict[task_number] = task_row
            predecessors = (task_row[6] or "").replace(" ", "")
            if predecessors:
                for pred in predecessors.split(","):
                    pred_row = all_tasks.get(pred)
                    if pred_row and not pred_row[8]:  # not completed
                        add_with_predecessors(pred_row, result_dict)

        stage1_dict = {}
        for row in busy_rows:
            add_with_predecessors(row, stage1_dict)

        # 4. Calculate duration for each
        result = []
        for t in stage1_dict.values():
            setup_time = t[4]
            time_each = t[5]
            job_quantity = t[10]
            duration = setup_time + (job_quantity * time_each)
            result.append(t + (duration,))
        cur.close()
        conn.close()
        return result

    def load_data(self):
        # Laai alle schedule-able tasks, insluitend job.quantity
        conn = psycopg2.connect(**self.db_config)
        cur = conn.cursor()
        cur.execute("""
            SELECT t.id, t.task_number, t.job_number, t.description, t.setup_time, t.time_each, t.predecessors, t.resources, t.completed, t.busy, j.quantity
            FROM task t
            JOIN job j ON t.job_number = j.job_number
            WHERE j.completed = FALSE AND j.blocked = FALSE
        """)
        rows = cur.fetchall()
        self.tasks = []
        for row in rows:
            # Bereken duur: setup_time + (job_quantity * time_each)
            setup_time = row[4]
            time_each = row[5]
            job_quantity = row[10]
            duration = setup_time + (job_quantity * time_each)
            # Voeg duur as laaste veld by
            self.tasks.append(row + (duration,))
        cur.close()
        conn.close()
        return self.tasks

    def get_resources_and_groups(self):
        conn = psycopg2.connect(**self.db_config)
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM resource")
        resources = {row[1]: row[0] for row in cur.fetchall()}  # name -> id
        cur.execute("SELECT id, name FROM resource_group")
        groups = {row[1]: row[0] for row in cur.fetchall()}  # name -> id
        cur.execute("SELECT resource_id, group_id FROM resource_group_association")
        group_assoc = {}
        for res_id, grp_id in cur.fetchall():
            group_assoc.setdefault(grp_id, []).append(res_id)
        cur.close()
        conn.close()
        return resources, groups, group_assoc

    def get_resource_availability(self):
        conn = psycopg2.connect(**self.db_config)
        cur = conn.cursor()
        cur.execute("SELECT weekday, start_time, end_time FROM calendar")
        calendar = {}
        for weekday, start, end in cur.fetchall():
            calendar[weekday] = (start, end)
        cur.close()
        conn.close()
        return calendar

    def run_schedule(self, start_date=None):
        # 1. Load tasks
        tasks = self.get_stage1_tasks()
        resources, groups, group_assoc = self.get_resources_and_groups()
        calendar = self.get_resource_availability()
        if start_date is None:
            start_date = datetime.now().date() + timedelta(days=1)

        # 2. Prepare task/resource mapping
        task_data = {}
        for t in tasks:
            task_number = t[1]
            duration = t[11]
            predecessors = [p.strip() for p in (t[6] or "").split(",") if p.strip()]
            resource_names = [r.strip() for r in (t[7] or "").split(",") if r.strip()]
            resolved_resources = []
            for rname in resource_names:
                if rname in resources:
                    resolved_resources.append(rname)
                elif rname in groups:
                    group_id = groups[rname]
                    res_ids = group_assoc.get(group_id, [])
                    for rid in res_ids:
                        for name, nid in resources.items():
                            if nid == rid:
                                resolved_resources.append(name)
                                break
                        break
            task_data[task_number] = {
                "row": t,
                "duration": duration,
                "predecessors": predecessors,
                "resources": resolved_resources
            }

        # 3. Build CP-SAT model (all in minutes)
        model = cp_model.CpModel()
        horizon = int(sum(t["duration"] for t in task_data.values()) * 2)  # generous upper bound

        intervals = {}
        starts = {}
        ends = {}
        for task_number, t in task_data.items():
            start = model.NewIntVar(0, horizon, f"start_{task_number}")
            end = model.NewIntVar(0, horizon, f"end_{task_number}")
            interval = model.NewIntervalVar(start, int(t["duration"]), end, f"interval_{task_number}")
            intervals[task_number] = interval
            starts[task_number] = start
            ends[task_number] = end

        # 4. Precedence constraints
        for task_number, t in task_data.items():
            for pred in t["predecessors"]:
                if pred in ends:
                    model.Add(starts[task_number] >= ends[pred])

        # 5. Resource constraints
        resource_to_tasks = {}
        for task_number, t in task_data.items():
            for r in t["resources"]:
                resource_to_tasks.setdefault(r, []).append(task_number)
        for r, tlist in resource_to_tasks.items():
            intervals_list = [intervals[tn] for tn in tlist]
            model.AddNoOverlap(intervals_list)

        # 6. Objective: minimize makespan
        makespan = model.NewIntVar(0, horizon, "makespan")
        model.AddMaxEquality(makespan, [ends[tn] for tn in task_data])
        model.Minimize(makespan)

        # 7. Solve
        solver = cp_model.CpSolver()
        status = solver.Solve(model)

        # 8. Build schedule results (in minutes)
        schedule = []
        if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            for task_number, t in task_data.items():
                start_min = solver.Value(starts[task_number])
                end_min = solver.Value(ends[task_number])
                schedule.append({
                    "task_number": task_number,
                    "job_number": t["row"][2],
                    "description": t["row"][3],
                    "start_minute": start_min,
                    "end_minute": end_min,
                    "resources": ", ".join(t["resources"])
                })
        # Convert minutes to datetimes
        schedule = convert_schedule_minutes_to_datetimes(schedule, start_date, calendar)
        return schedule

    def get_stage2_tasks(self, stage1_task_numbers):
        # All tasks not completed and not scheduled in stage 1
        conn = psycopg2.connect(**self.db_config)
        cur = conn.cursor()
        cur.execute("""
            SELECT t.id, t.task_number, t.job_number, t.description, t.setup_time, t.time_each, t.predecessors, t.resources, t.completed, t.busy, j.quantity
            FROM task t
            JOIN job j ON t.job_number = j.job_number
            WHERE t.completed = FALSE AND j.completed = FALSE AND j.blocked = FALSE
        """)
        all_rows = cur.fetchall()
        # Exclude tasks already scheduled in stage 1
        stage2_rows = [row for row in all_rows if row[1] not in stage1_task_numbers]
        # Recursively add incomplete predecessors (same logic as stage 1)
        all_tasks = {row[1]: row for row in all_rows}
        def add_with_predecessors(task_row, result_dict):
            task_number = task_row[1]
            if task_number in result_dict:
                return
            result_dict[task_number] = task_row
            predecessors = (task_row[6] or "").replace(" ", "")
            if predecessors:
                for pred in predecessors.split(","):
                    pred_row = all_tasks.get(pred)
                    if pred_row and not pred_row[8]:  # not completed
                        add_with_predecessors(pred_row, result_dict)
        stage2_dict = {}
        for row in stage2_rows:
            add_with_predecessors(row, stage2_dict)
        # Calculate duration for each
        result = []
        for t in stage2_dict.values():
            setup_time = t[4]
            time_each = t[5]
            job_quantity = t[10]
            duration = setup_time + (job_quantity * time_each)
            result.append(t + (duration,))
        cur.close()
        conn.close()
        return result

    def run_stage(self, tasks, start_date, calendar, objective="makespan"):
        # Prepare task/resource mapping (same as run_schedule)
        resources, groups, group_assoc = self.get_resources_and_groups()
        task_data = {}
        for t in tasks:
            task_number = t[1]
            duration = t[11]
            predecessors = [p.strip() for p in (t[6] or "").split(",") if p.strip()]
            resource_names = [r.strip() for r in (t[7] or "").split(",") if r.strip()]
            resolved_resources = []
            for rname in resource_names:
                if rname in resources:
                    resolved_resources.append(rname)
                elif rname in groups:
                    group_id = groups[rname]
                    res_ids = group_assoc.get(group_id, [])
                    for rid in res_ids:
                        for name, nid in resources.items():
                            if nid == rid:
                                resolved_resources.append(name)
                                break
                        break
            task_data[task_number] = {
                "row": t,
                "duration": duration,
                "predecessors": predecessors,
                "resources": resolved_resources
            }
        # Build CP-SAT model
        model = cp_model.CpModel()
        horizon = int(sum(t["duration"] for t in task_data.values()) * 2)
        intervals = {}
        starts = {}
        ends = {}
        for task_number, t in task_data.items():
            start = model.NewIntVar(0, horizon, f"start_{task_number}")
            end = model.NewIntVar(0, horizon, f"end_{task_number}")
            interval = model.NewIntervalVar(start, int(t["duration"]), end, f"interval_{task_number}")
            intervals[task_number] = interval
            starts[task_number] = start
            ends[task_number] = end
        # Precedence constraints
        for task_number, t in task_data.items():
            for pred in t["predecessors"]:
                if pred in ends:
                    model.Add(starts[task_number] >= ends[pred])
        # Resource constraints
        resource_to_tasks = {}
        for task_number, t in task_data.items():
            for r in t["resources"]:
                resource_to_tasks.setdefault(r, []).append(task_number)
        for r, tlist in resource_to_tasks.items():
            intervals_list = [intervals[tn] for tn in tlist]
            model.AddNoOverlap(intervals_list)
        # Objective function (easy to change)
        if objective == "makespan":
            makespan = model.NewIntVar(0, horizon, "makespan")
            model.AddMaxEquality(makespan, [ends[tn] for tn in task_data])
            model.Minimize(makespan)
        # Add other objectives here as needed
        # Solve
        solver = cp_model.CpSolver()
        status = solver.Solve(model)
        schedule = []
        if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            for task_number, t in task_data.items():
                start_min = solver.Value(starts[task_number])
                end_min = solver.Value(ends[task_number])
                schedule.append({
                    "task_number": task_number,
                    "job_number": t["row"][2],
                    "description": t["row"][3],
                    "start_minute": start_min,
                    "end_minute": end_min,
                    "resources": ", ".join(t["resources"])
                })
        schedule = convert_schedule_minutes_to_datetimes(schedule, start_date, calendar)
        return schedule

    def run_full_schedule(self, start_date=None, objective="makespan"):
        calendar = self.get_resource_availability()
        # Stage 1
        stage1_tasks = self.get_stage1_tasks()
        stage1_schedule = self.run_stage(stage1_tasks, start_date, calendar, objective)
        stage1_task_numbers = {s["task_number"] for s in stage1_schedule}
        # Stage 2
        stage2_tasks = self.get_stage2_tasks(stage1_task_numbers)
        stage2_schedule = self.run_stage(stage2_tasks, start_date, calendar, objective)
        # Combine and sort by start_datetime
        full_schedule = stage1_schedule + stage2_schedule
        full_schedule.sort(key=lambda s: s["start_datetime"])
        return full_schedule, stage2_schedule

    def get_results(self):
        # Gee die geskeduleerde resultate terug
        pass