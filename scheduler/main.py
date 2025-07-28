from ortools.sat.python import cp_model
from gui import SchedulerGUI
from scheduler import load_data, schedule
from PySide6.QtWidgets import QApplication
import sys

def schedule_callback(start_date, x1, x2):
    jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays = load_data()
    return schedule(jobs, tasks, resource_mapping, resource_group_mapping, calendar, holidays, start_date, x1, x2)

def main():
    app = QApplication(sys.argv)
    window = SchedulerGUI(schedule_callback)
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
