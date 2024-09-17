import schedule
import time
import threading
from tasks.task_manager import TaskManager
from voice.text_to_speech import speak

class Scheduler:
    def __init__(self):
        self.task_manager = TaskManager()
        schedule.every().day.at("09:00").do(self.reminder)
        self.run_scheduler()
    
    def reminder(self):
        pending_tasks = [task["task"] for task in self.task_manager.tasks if not task["completed"]]
        if pending_tasks:
            reminder = "You have the following pending tasks:\n" + "\n".join(pending_tasks)
            speak(reminder)
    
    def run_scheduler(self):
        scheduler_thread = threading.Thread(target=self.run_continuously)
        scheduler_thread.daemon = True
        scheduler_thread.start()
    
    def run_continuously(self):
        while True:
            schedule.run_pending()
            time.sleep(1)
