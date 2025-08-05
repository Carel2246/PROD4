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

        # Table for tasks
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
        left_panel.addStretch()

        # Right panel
        self.console = MatrixConsole()
        self.console.setMinimumWidth(400)
        self.console.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        main_layout.addLayout(left_panel, 3)
        main_layout.addWidget(self.console, 3)
        main.setLayout(main_layout)
        self.setCentralWidget(main)

        # Load and show schedule-able tasks
        self.engine = SchedulerEngine()
        self.console.log("Laai scheduleerbare take...")
        tasks = self.engine.load_data()
        self.task_table.setRowCount(len(tasks))
        for row_idx, t in enumerate(tasks):
            self.task_table.setItem(row_idx, 0, QTableWidgetItem(str(t[1])))  # Taaknr
            self.task_table.setItem(row_idx, 1, QTableWidgetItem(str(t[2])))  # Jobnr
            self.task_table.setItem(row_idx, 2, QTableWidgetItem(str(t[3])))  # Beskrywing
            self.task_table.setItem(row_idx, 3, QTableWidgetItem(f"{t[4]:.2f}"))  # Setup
            self.task_table.setItem(row_idx, 4, QTableWidgetItem(str(t[10])))  # Qty
            self.task_table.setItem(row_idx, 5, QTableWidgetItem(f"{t[11]:.2f}"))  # Duur
            self.console.log(
                f"Taak {t[1]} ({t[2]}): setup={t[4]}, qty={t[10]}, tyd/eenheid={t[5]} => duur={t[11]:.2f}"
            )
        self.console.log(f"{len(tasks)} take gelaai.")
        self.console.log("GUI gereed.")