"""
PySide6 GUI vir die Skeduleerder.
Toon basiese status en data visualisering.
"""
from PySide6.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QPushButton,
    QTableWidget, QTableWidgetItem, QDateEdit, QTextEdit, QSizePolicy
)
from PySide6.QtCore import Qt, QDate, QTimer
from PySide6.QtGui import QFont
import random
from scheduler import SchedulerEngine

class MatrixConsole(QTextEdit):
    def __init__(self):
        super().__init__()
        self.setReadOnly(True)
        self.setFont(QFont("Consolas", 12))
        self.setStyleSheet("""
            background-color: black;
            color: #00FF00;
            border: none;
        """)
        self.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.glitch_timer = QTimer(self)
        self.glitch_timer.timeout.connect(self.do_glitch)
        self.glitch_timer.setSingleShot(True)
        self.schedule_next_glitch()

    def log(self, msg):
        self.append(msg)

    def schedule_next_glitch(self):
        interval = random.randint(3000, 10000)
        self.glitch_timer.start(interval)

    def do_glitch(self):
        orig_text = self.toPlainText()
        if orig_text:
            self.setStyleSheet("""
                background-color: black;
                color: #00FF00;
                border: none;
                text-shadow: 0 0 8px #00FF00;
            """)
            glitch_text = ''.join(
                random.choice([c, chr(random.randint(33, 126))]) if random.random() < 0.08 else c
                for c in orig_text
            )
            self.setPlainText(glitch_text)
            QTimer.singleShot(100, lambda: self.setPlainText(orig_text))
        self.setStyleSheet("""
            background-color: black;
            color: #00FF00;
            border: none;
        """)
        self.schedule_next_glitch()

class ScheduleWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Skeduleerder")
        main = QWidget()
        main_layout = QHBoxLayout()
        # Left panel
        left_panel = QVBoxLayout()
        date_label = QLabel("Skeduleer vanaf:")
        self.date_picker = QDateEdit(QDate.currentDate().addDays(1))
        self.date_picker.setCalendarPopup(True)
        self.schedule_btn = QPushButton("Skeduleer")
        left_panel.addWidget(date_label)
        left_panel.addWidget(self.date_picker)
        left_panel.addWidget(self.schedule_btn)
        left_panel.addSpacing(10)
        left_panel.addWidget(QLabel("Scheduleerbare Take:"))

        # Table for stage 1 tasks
        self.task_table = QTableWidget()
        self.task_table.setColumnCount(6)
        self.task_table.setHorizontalHeaderLabels([
            "Taaknr", "Jobnr", "Beskrywing", "Setup", "Qty", "Duur"
        ])
        self.task_table.setShowGrid(True)
        self.task_table.setStyleSheet("QTableWidget { gridline-color: #888; }")
        self.task_table.horizontalHeader().setStretchLastSection(True)
        self.task_table.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        left_panel.addWidget(self.task_table)

        # Table for stage 2 scheduled tasks
        left_panel.addSpacing(10)
        left_panel.addWidget(QLabel("Stage 2 Geskeduleerde Take:"))
        self.stage2_table = QTableWidget()
        self.stage2_table.setColumnCount(9)
        self.stage2_table.setHorizontalHeaderLabels([
            "Taaknr", "Jobnr", "Beskrywing", "Setup", "Qty", "Duur",
            "Skedule (minute)", "Begin tyd", "Eind tyd"
        ])
        self.stage2_table.setShowGrid(True)
        self.stage2_table.setStyleSheet("QTableWidget { gridline-color: #888; }")
        self.stage2_table.horizontalHeader().setStretchLastSection(True)
        self.stage2_table.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        left_panel.addWidget(self.stage2_table)

        left_panel.addStretch()

        # Right panel
        self.console = MatrixConsole()
        self.console.setMinimumWidth(400)
        self.console.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        main_layout.addLayout(left_panel, 3)
        main_layout.addWidget(self.console, 3)
        main.setLayout(main_layout)
        self.setCentralWidget(main)

        # Load and show Stage 1 tasks only
        self.engine = SchedulerEngine()
        self.console.log("Laai Stage 1 take (besig + vereiste voorgangers)...")
        stage1_tasks = self.engine.get_stage1_tasks()
        self.task_table.setRowCount(len(stage1_tasks))
        for row_idx, t in enumerate(stage1_tasks):
            self.task_table.setItem(row_idx, 0, QTableWidgetItem(str(t[1])))  # Taaknr
            self.task_table.setItem(row_idx, 1, QTableWidgetItem(str(t[2])))  # Jobnr
            self.task_table.setItem(row_idx, 2, QTableWidgetItem(str(t[3])))  # Beskrywing
            self.task_table.setItem(row_idx, 3, QTableWidgetItem(f"{t[4]:.2f}"))  # Setup
            self.task_table.setItem(row_idx, 4, QTableWidgetItem(str(t[10])))  # Qty
            self.task_table.setItem(row_idx, 5, QTableWidgetItem(f"{t[11]:.2f}"))  # Duur
            self.console.log(
                f"Stage 1: {t[1]} ({t[2]}): setup={t[4]}, qty={t[10]}, tyd/eenheid={t[5]} => duur={t[11]:.2f}"
            )
        self.console.log(f"{len(stage1_tasks)} Stage 1 take gelaai.")
        self.console.log("Stage 1 skedulering gereed.")

        # Only run scheduling when button is pressed
        def run_scheduling():
            self.console.log("Begin OR-tools skedulering (Stage 1 + Stage 2)...")
            # Stage 1
            stage1_tasks = self.engine.get_stage1_tasks()
            self.console.log(f"Stap 1: {len(stage1_tasks)} take in Stage 1 (besig + voorgangers).")

            # Load all tasks from jobs not completed or blocked
            all_tasks = self.engine.load_data()
            self.console.log(f"Stap 2: {len(all_tasks)} totale take in aktiewe jobs.")

            # Count completed tasks
            completed_tasks = [t for t in all_tasks if t[8]]  # t[8] = completed
            self.console.log(f"Stap 3: {len(completed_tasks)} take reeds voltooi en uitgesluit.")

            # Tasks already scheduled in stage 1
            stage1_task_numbers = {t[1] for t in stage1_tasks}
            already_scheduled = [t for t in all_tasks if t[1] in stage1_task_numbers]
            self.console.log(f"Stap 4: {len(already_scheduled)} take reeds in skedule (Stage 1) en uitgesluit.")

            # Tasks to be scheduled in stage 2
            stage2_candidates = [t for t in all_tasks if not t[8] and t[1] not in stage1_task_numbers]
            self.console.log(f"Stap 5: {len(stage2_candidates)} take oor vir Stage 2 skedulering.")

            # Run full schedule (stage 1 + stage 2)
            full_schedule, stage2_schedule = self.engine.run_full_schedule(start_date=self.date_picker.date().toPython())
            self.console.log(f"Totaal geskeduleer: {len(full_schedule)} take.")
            self.console.log(f"Stage 2: {len(stage2_schedule)} take geskeduleer.")

            # Show all scheduled tasks in main table (sorted by start time)
            self.task_table.setColumnCount(9)
            self.task_table.setHorizontalHeaderLabels([
                "Taaknr", "Jobnr", "Beskrywing", "Setup", "Qty", "Duur",
                "Skedule (minute)", "Begin tyd", "Eind tyd"
            ])
            self.task_table.setRowCount(len(full_schedule))
            for row_idx, s in enumerate(full_schedule):
                self.task_table.setItem(row_idx, 0, QTableWidgetItem(str(s["task_number"])))
                self.task_table.setItem(row_idx, 1, QTableWidgetItem(str(s["job_number"])))
                self.task_table.setItem(row_idx, 2, QTableWidgetItem(str(s["description"])))
                self.task_table.setItem(row_idx, 3, QTableWidgetItem(""))  # Setup (optional)
                self.task_table.setItem(row_idx, 4, QTableWidgetItem(""))  # Qty (optional)
                self.task_table.setItem(row_idx, 5, QTableWidgetItem(""))  # Duur (optional)
                sched_str = f"{s['start_minute']} - {s['end_minute']} ({s['resources']})"
                self.task_table.setItem(row_idx, 6, QTableWidgetItem(sched_str))
                self.task_table.setItem(row_idx, 7, QTableWidgetItem(str(s["start_datetime"])))
                self.task_table.setItem(row_idx, 8, QTableWidgetItem(str(s["end_datetime"])))
                self.console.log(
                    f"Taak {s['task_number']}: {sched_str} | {s['start_datetime']} - {s['end_datetime']}"
                )

            # Show only stage 2 scheduled tasks in second table
            self.stage2_table.setRowCount(len(stage2_schedule))
            for row_idx, s in enumerate(stage2_schedule):
                self.stage2_table.setItem(row_idx, 0, QTableWidgetItem(str(s["task_number"])))
                self.stage2_table.setItem(row_idx, 1, QTableWidgetItem(str(s["job_number"])))
                self.stage2_table.setItem(row_idx, 2, QTableWidgetItem(str(s["description"])))
                self.stage2_table.setItem(row_idx, 3, QTableWidgetItem(""))  # Setup (optional)
                self.stage2_table.setItem(row_idx, 4, QTableWidgetItem(""))  # Qty (optional)
                self.stage2_table.setItem(row_idx, 5, QTableWidgetItem(""))  # Duur (optional)
                sched_str = f"{s['start_minute']} - {s['end_minute']} ({s['resources']})"
                self.stage2_table.setItem(row_idx, 6, QTableWidgetItem(sched_str))
                self.stage2_table.setItem(row_idx, 7, QTableWidgetItem(str(s["start_datetime"])))
                self.stage2_table.setItem(row_idx, 8, QTableWidgetItem(str(s["end_datetime"])))

            self.console.log("Skedulering voltooi.")

        self.schedule_btn.clicked.connect(run_scheduling)