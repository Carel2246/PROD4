"""
Skeduleerder-enjin: Laai data, bou skedule, en gee resultate terug.
Gebruik OR-tools vir gevorderde skedulering.
"""
import psycopg2

class SchedulerEngine:
    def __init__(self, db_config=None):
        self.db_config = db_config or {
            "host": "nmiserver.postgres.database.azure.com",
            "dbname": "jobshopdb",
            "user": "myadmin",
            "password": "dXCwCluFm8*PYK",
            "port": 5432
        }
        self.tasks = []

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

    def run_schedule(self):
        # Voer die skedulering uit met OR-tools
        pass

    def get_results(self):
        # Gee die geskeduleerde resultate terug
        pass