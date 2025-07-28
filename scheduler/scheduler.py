from db import get_connection
import time
from ortools.sat.python import cp_model
from datetime import datetime, timedelta
import logging
import pandas as pd

def load_data():
    conn = get_connection()
    cur = conn.cursor()

    # Active jobs
    cur.execute("""
        SELECT job_number, promised_date, quantity, customer, price_each
        FROM job
        WHERE completed = FALSE AND blocked = FALSE
    """)
    jobs = {}
    for row in cur.fetchall():
        jobs[row[0]] = {
            "promised_date": row[1], 
            "quantity": row[2], 
            "customer": row[3],
            "price_each": row[4] if row[4] else 0
        }

    # Active tasks
    cur.execute("""
        SELECT id, job_number, task_number, description, setup_time, time_each, predecessors, resources, completed
        FROM task
        WHERE completed = FALSE AND job_number IN %s
    """, (tuple(jobs.keys()) if jobs else ('',),))
    tasks = []
    for row in cur.fetchall():
        # Parse predecessors and resources as lists
        predecessors = []
        if row[6]:  # predecessors field
            predecessors = [p.strip() for p in row[6].split(",") if p.strip()]
        
        resources = []
        if row[7]:  # resources field
            resources = [r.strip() for r in row[7].split(",") if r.strip()]
        
        tasks.append({
            "id": row[0],
            "job_number": row[1],
            "task_number": row[2],
            "description": row[3],
            "setup_time": row[4] if row[4] else 0,
            "time_each": row[5] if row[5] else 0,
            "predecessors": predecessors,
            "resources": resources,
            "completed": row[8]
        })

    # Resources
    cur.execute("SELECT id, name, type FROM resource")
    resources = {row[1]: {"id": row[0], "type": row[2]} for row in cur.fetchall()}
    resource_mapping = {name: info["id"] for name, info in resources.items()}

    # Resource groups
    cur.execute("SELECT id, name FROM resource_group")
    resource_groups = {row[1]: row[0] for row in cur.fetchall()}

    # Resource group associations
    cur.execute("SELECT group_id, resource_id FROM resource_group_association")
    group_assoc = {}
    for group_id, res_id in cur.fetchall():
        group_assoc.setdefault(group_id, set()).add(res_id)
    
    # Create resource group mapping (group name -> list of resource IDs)
    resource_group_mapping = {}
    for group_name, group_id in resource_groups.items():
        resource_group_mapping[group_name] = list(group_assoc.get(group_id, set()))

    # Calendar
    cur.execute("SELECT weekday, start_time, end_time FROM calendar ORDER BY weekday")
    calendar = {}
    for row in cur.fetchall():
        calendar[row[0]] = {"start": row[1], "end": row[2]}

    # Holidays
    cur.execute("SELECT date, start_time, end_time, resources FROM holidays")
    holidays = {}
    for row in cur.fetchall():
        date_str = row[0].strftime('%Y-%m-%d')
        holiday_resources = []
        if row[3]:  # JSONB resources field
            holiday_resources = row[3] if isinstance(row[3], list) else []
        
        holidays[date_str] = {
            'date': date_str,
            'start_time': row[1].strftime('%H:%M') if row[1] else None,
            'end_time': row[2].strftime('%H:%M') if row[2] else None,
            'resources': holiday_resources
        }

    cur.close()
    conn.close()
    return jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays

def time_to_minutes(time_str):
    """Convert time string to minutes since midnight"""
    if not time_str:
        return 0
    try:
        if isinstance(time_str, str):
            time_obj = datetime.strptime(time_str, "%H:%M:%S").time()
        else:
            time_obj = time_str
        return time_obj.hour * 60 + time_obj.minute
    except Exception as e:
        logging.error(f"Error converting time {time_str}: {e}")
        return 0

def time_to_minutes_holiday(time_str):
    """Convert time string to minutes since midnight for holidays"""
    if not time_str:
        return 0
    try:
        time_obj = datetime.strptime(str(time_str), "%H:%M").time()
        return time_obj.hour * 60 + time_obj.minute
    except Exception as e:
        logging.error(f"Error converting holiday time {time_str}: {e}")
        return 0

def find_first_working_minute(start_date, working_hours, holidays):
    """Find the first working minute on or after start_date"""
    current_date = start_date
    max_days = 7
    day_count = 0

    while day_count < max_days:
        weekday = current_date.isoweekday()
        start_minutes, end_minutes = working_hours.get(weekday, (0, 0))

        # Check for holidays
        holiday = holidays.get(current_date.strftime('%Y-%m-%d'))
        if holiday and not holiday['resources'] and not (holiday['start_time'] and holiday['end_time']):
            current_date += timedelta(days=1)
            day_count += 1
            continue
        elif holiday and holiday['start_time'] and holiday['end_time']:
            holiday_start = time_to_minutes_holiday(holiday['start_time'])
            holiday_end = time_to_minutes_holiday(holiday['end_time'])
            if holiday_start < holiday_end and not holiday['resources']:
                start_minutes = max(start_minutes, holiday_end)
            if start_minutes >= end_minutes:
                current_date += timedelta(days=1)
                day_count += 1
                continue

        if start_minutes < end_minutes and start_minutes > 0:
            result = datetime.combine(current_date, datetime.min.time()) + timedelta(minutes=start_minutes)
            return result
        else:
            current_date += timedelta(days=1)
            day_count += 1

    logging.error(f"No working day found within {max_days} days from {start_date}")
    return datetime.combine(start_date, datetime.min.time())

def minutes_to_datetime(minutes, start_date, working_hours, holidays, resource_id=None, duration=None):
    """Convert minutes to datetime, respecting working hours and holidays"""
    base_datetime = find_first_working_minute(start_date, working_hours, holidays)
    remaining_minutes = minutes
    current_date = base_datetime.date()
    max_days = 365
    day_count = 0

    while remaining_minutes > 0 and day_count < max_days:
        weekday = current_date.isoweekday()
        start_minutes, end_minutes = working_hours.get(weekday, (0, 0))

        if start_minutes >= end_minutes or start_minutes == 0:
            current_date += timedelta(days=1)
            day_count += 1
            continue

        # Check holidays
        holiday = holidays.get(current_date.strftime('%Y-%m-%d'))
        if holiday and not holiday['resources'] and not (holiday['start_time'] and holiday['end_time']):
            current_date += timedelta(days=1)
            day_count += 1
            continue
        elif holiday and holiday['start_time'] and holiday['end_time'] and not holiday['resources']:
            holiday_start = time_to_minutes_holiday(holiday['start_time'])
            holiday_end = time_to_minutes_holiday(holiday['end_time'])
            if holiday_start < holiday_end:
                start_minutes = max(start_minutes, holiday_end)
                if start_minutes >= end_minutes:
                    current_date += timedelta(days=1)
                    day_count += 1
                    continue

        available_minutes = end_minutes - start_minutes
        if remaining_minutes <= available_minutes:
            minutes_into_day = start_minutes + remaining_minutes
            result = datetime.combine(current_date, datetime.min.time()) + timedelta(minutes=minutes_into_day)
            
            if duration is not None:
                end_minutes = minutes + duration
                end_datetime = minutes_to_datetime(end_minutes, start_date, working_hours, holidays, resource_id, duration=None)
                return result, end_datetime
            return result

        remaining_minutes -= available_minutes
        current_date += timedelta(days=1)
        day_count += 1

    logging.error(f"Failed to map {minutes} minutes within {max_days} days from {start_date}")
    if duration is not None:
        return base_datetime, base_datetime
    return base_datetime

def schedule(jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays, start_date, x1=1.0, x2=1.0):
    """Generate schedule using OR-Tools with working hours and holidays"""
    
    # Prepare working hours
    working_hours = {}
    for weekday, times in calendar.items():
        start_minutes = time_to_minutes(times["start"])
        end_minutes = time_to_minutes(times["end"])
        working_hours[weekday] = (start_minutes, end_minutes)

    # Create CP-SAT model
    model = cp_model.CpModel()

    # Create variables
    task_vars = {}
    resource_vars = {}
    job_completion = {}
    job_start = {}
    job_end = {}
    job_cycle_time = {}
    job_flow_time = {}
    job_flow_time_excess = {}
    job_lateness = {}
    job_rand_days_late = {}
    job_objective_terms = []

    # Process tasks
    for task in tasks:
        if task["completed"]:
            continue
        job = jobs[task["job_number"]]
        task_id = task["task_number"]
        setup_time = task["setup_time"]
        time_each = task["time_each"]
        quantity = job["quantity"]
        duration = int(setup_time + (quantity * time_each))
        if duration <= 0:
            continue
        start_var = model.NewIntVar(0, 1000000, f'start_{task_id}')
        end_var = model.NewIntVar(0, 1000000, f'end_{task_id}')
        task_vars[task_id] = (start_var, end_var, duration)
        model.Add(end_var == start_var + duration)
        job_id = task["job_number"]
        if job_id not in job_completion:
            job_completion[job_id] = []
        job_completion[job_id].append((start_var, end_var, duration))

        # Process resources
        resource_vars[task_id] = []
        for res in task["resources"]:
            if res in resource_mapping:
                res_id = resource_mapping[res]
                resource_vars[task_id].append((res, res_id, None))
            elif res in resource_group_mapping:
                group_resources = resource_group_mapping[res]
                if group_resources:
                    selected_resource = model.NewIntVarFromDomain(
                        cp_model.Domain.FromValues(group_resources),
                        f'selected_{task_id}_{res}'
                    )
                    resource_vars[task_id].append((res, selected_resource, group_resources))

    # For each job, calculate flow time, cycle time, lateness, rand_days_late, flow_time_excess
    for job_id, job in jobs.items():
        if job_id not in job_completion or not job_completion[job_id]:
            continue
        starts = [sv for sv, ev, dur in job_completion[job_id]]
        ends = [ev for sv, ev, dur in job_completion[job_id]]
        durations = [dur for sv, ev, dur in job_completion[job_id]]

        # First start and last end
        first_start = model.NewIntVar(0, 1000000, f'first_start_{job_id}')
        last_end = model.NewIntVar(0, 1000000, f'last_end_{job_id}')
        model.AddMinEquality(first_start, starts)
        model.AddMaxEquality(last_end, ends)
        job_start[job_id] = first_start
        job_end[job_id] = last_end

        # Cycle time
        cycle_time = sum(durations)
        job_cycle_time[job_id] = cycle_time

        # Flow time
        flow_time = model.NewIntVar(0, 1000000, f'flow_time_{job_id}')
        model.Add(flow_time == last_end - first_start)
        job_flow_time[job_id] = flow_time

        # Flow time excess
        flow_time_excess = model.NewIntVar(0, 1000000, f'flow_time_excess_{job_id}')
        model.Add(flow_time_excess >= flow_time - cycle_time)
        model.Add(flow_time_excess >= 0)
        job_flow_time_excess[job_id] = flow_time_excess

        # Lateness (in days)
        promised_minutes = int((job["promised_date"] - start_date).total_seconds() // 60)
        lateness = model.NewIntVar(0, 1000000, f'lateness_{job_id}')
        model.Add(lateness >= last_end - promised_minutes)
        model.Add(lateness >= 0)
        job_lateness[job_id] = lateness

        # Rand-days late
        job_value = int(job["price_each"] * job["quantity"])
        rand_days_late = model.NewIntVar(0, 1000000000, f'rand_days_late_{job_id}')
        model.AddMultiplicationEquality(rand_days_late, [lateness, job_value])
        job_rand_days_late[job_id] = rand_days_late

        # Weighted terms for objective
        job_objective_terms.append(model.NewIntVar(0, 1000000000, f'obj_late_{job_id}'))
        model.Add(job_objective_terms[-1] == int(x1) * rand_days_late + int(x2) * flow_time_excess)

    # Objective: minimize sum of weighted terms
    total_objective = model.NewIntVar(0, 1000000000, 'total_objective')
    model.Add(total_objective == sum(job_objective_terms))
    model.Minimize(total_objective)

    # Add predecessor constraints
    for task in tasks:
        if task["completed"]:
            continue
        
        task_id = task["task_number"]
        if task_id not in task_vars:
            continue
        
        for pred in task["predecessors"]:
            if pred in task_vars:
                model.Add(task_vars[task_id][0] >= task_vars[pred][1])

    # Add resource constraints
    resource_intervals = {}
    for task_id, resources in resource_vars.items():
        for res_name, res_var, group_resources in resources:
            if group_resources is None:  # Direct resource assignment
                res_id = res_var
                if res_id not in resource_intervals:
                    resource_intervals[res_id] = []
                interval = model.NewIntervalVar(
                    task_vars[task_id][0],
                    task_vars[task_id][2],
                    task_vars[task_id][1],
                    f'interval_{task_id}_{res_id}'
                )
                resource_intervals[res_id].append(interval)
            else:  # Resource group assignment
                for possible_res_id in group_resources:
                    if possible_res_id not in resource_intervals:
                        resource_intervals[possible_res_id] = []
                    is_selected = model.NewBoolVar(f'is_{task_id}_{res_name}_{possible_res_id}')
                    model.Add(res_var == possible_res_id).OnlyEnforceIf(is_selected)
                    model.Add(res_var != possible_res_id).OnlyEnforceIf(is_selected.Not())
                    interval = model.NewOptionalIntervalVar(
                        task_vars[task_id][0],
                        task_vars[task_id][2],
                        task_vars[task_id][1],
                        is_selected,
                        f'opt_interval_{task_id}_{possible_res_id}'
                    )
                    resource_intervals[possible_res_id].append(interval)

    # Add no-overlap constraints
    for res_id, intervals in resource_intervals.items():
        if intervals:
            model.AddNoOverlap(intervals)

    # Set objective
    model.Minimize(total_objective)
    
    # Solve
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 120.0
    t0 = time.time()
    status = solver.Solve(model)
    elapsed = time.time() - t0

    if status not in [cp_model.OPTIMAL, cp_model.FEASIBLE]:
        print("Geen geskikte skedule gevind!")
        return []

    # Process solution
    results = []
    num_jobs = len(jobs)
    num_late = 0
    
    for task_id, (start_var, end_var, duration) in task_vars.items():
        start_time = solver.Value(start_var)
        end_time = solver.Value(end_var)
        
        if start_time == 0:
            start_time = 1
            end_time = start_time + duration
        
        # Get resources
        resources = resource_vars.get(task_id, [])
        selected_res_id = None
        for res_name, res_var, group_resources in resources:
            if group_resources is None:
                selected_res_id = res_var
            else:
                selected_res_id = solver.Value(res_var)
            break
        
        # Convert to datetime
        start_datetime, end_datetime = minutes_to_datetime(
            start_time, start_date, working_hours, holidays, 
            resource_id=selected_res_id, duration=duration
        )
        
        # Get resource names
        resources_list = []
        for res_name, res_var, group_resources in resources:
            if group_resources is None:
                resources_list.append(res_name)
            else:
                res_id = solver.Value(res_var)
                # Find resource name by ID
                for name, mapping_id in resource_mapping.items():
                    if mapping_id == res_id:
                        resources_list.append(name)
                        break
        
        # Find task info
        task_info = next((t for t in tasks if t["task_number"] == task_id), None)
        if task_info:
            results.append({
                "id": task_info["id"],
                "job_number": task_info["job_number"],
                "task_number": task_id,
                "start_time": start_datetime.strftime("%Y-%m-%d %H:%M"),
                "end_time": end_datetime.strftime("%Y-%m-%d %H:%M"),
                "resources": ", ".join(resources_list)
            })

    # Check for late jobs
    for job_num, job in jobs.items():
        job_tasks = [t for t in tasks if t["job_number"] == job_num]
        if job_tasks:
            last_end_minutes = max(solver.Value(task_vars[t["task_number"]][1]) for t in job_tasks if t["task_number"] in task_vars)
            last_end_datetime, _ = minutes_to_datetime(last_end_minutes, start_date, working_hours, holidays, duration=0)
            promised_date = job["promised_date"]
            if isinstance(promised_date, str):
                promised_date = datetime.strptime(promised_date, '%Y-%m-%d %H:%M:%S')
            if last_end_datetime > promised_date:
                num_late += 1

    print(f"Aantal geskeduleerde werke: {num_jobs}")
    print(f"Aantal laat werke: {num_late}")
    print(f"Tyd geneem om te skeduleer: {elapsed:.2f} sekondes")

    return sorted(results, key=lambda t: t["start_time"])

def test_db():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT 1;")
    print("DB test result:", cur.fetchone())
    cur.close()
    conn.close()

def main():
    start = time.time()
    jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays = load_data()
    from datetime import date
    start_date = date.today()
    results = schedule(jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays, start_date)
    elapsed = time.time() - start
    print(f"Totaal tyd: {elapsed:.2f} sekondes")
    return results

if __name__ == "__main__":
    test_db()
    main()