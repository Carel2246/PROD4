"""
Hoofinskrywing vir die Skeduleerder GUI-toepassing.
"""
import sys
from PySide6.QtWidgets import QApplication
from gui import ScheduleWindow

if __name__ == "__main__":
    # Skep die Qt-toepassing
    app = QApplication(sys.argv)
    # Skep en wys die hoofvenster
    window = ScheduleWindow()
    window.show()
    # Voer die hoof Qt-lus uit
    sys.exit(app.exec())
