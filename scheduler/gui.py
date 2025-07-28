from PySide6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QLabel, QLineEdit, QPushButton,
    QTableWidget, QTableWidgetItem, QDateEdit, QHBoxLayout
)
from PySide6.QtCore import Qt, QDate

class SchedulerGUI(QWidget):
    def __init__(self, schedule_callback):
        super().__init__()
        self.setWindowTitle("Job Shop Skeduleerder")
        layout = QVBoxLayout()

        # Startdatum
        hbox = QHBoxLayout()
        hbox.addWidget(QLabel("Begindatum:"))
        self.date_edit = QDateEdit(QDate.currentDate())
        self.date_edit.setCalendarPopup(True)
        hbox.addWidget(self.date_edit)
        layout.addLayout(hbox)

        # x1 en x2
        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("x1 (Rand-dae laat):"))
        self.x1_input = QLineEdit("1.0")
        hbox2.addWidget(self.x1_input)
        hbox2.addWidget(QLabel("x2 (Vloei tyd oorskot):"))
        self.x2_input = QLineEdit("1.0")
        hbox2.addWidget(self.x2_input)
        layout.addLayout(hbox2)

        # Skeduleer knoppie
        self.schedule_btn = QPushButton("Skeduleer")
        layout.addWidget(self.schedule_btn)

        # Tabel vir resultate
        self.table = QTableWidget()
        self.table.setColumnCount(6)
        self.table.setHorizontalHeaderLabels([
            "Taak ID", "Job", "Taak", "Begin tyd", "Eind tyd", "Hulpbronne"
        ])
        layout.addWidget(self.table)

        self.setLayout(layout)
        self.schedule_btn.clicked.connect(self.run_schedule)
        self.schedule_callback = schedule_callback

    def run_schedule(self):
        start_date = self.date_edit.date().toPython()
        x1 = float(self.x1_input.text())
        x2 = float(self.x2_input.text())
        results = self.schedule_callback(start_date, x1, x2)
        self.show_results(results)

    def show_results(self, results):
        self.table.setRowCount(len(results))
        for row, task in enumerate(results):
            self.table.setItem(row, 0, QTableWidgetItem(str(task["id"])))
            self.table.setItem(row, 1, QTableWidgetItem(str(task["job_number"])))
            self.table.setItem(row, 2, QTableWidgetItem(str(task["task_number"])))
            self.table.setItem(row, 3, QTableWidgetItem(str(task["start_time"])))
            self.table.setItem(row, 4, QTableWidgetItem(str(task["end_time"])))
            self.table.setItem(row, 5, QTableWidgetItem(str(task["resources"])))
        self.table.sortItems(3, Qt.AscendingOrder)