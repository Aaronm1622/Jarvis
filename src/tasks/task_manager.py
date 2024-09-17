import json
import os
from utils.logger import logger

TASKS_FILE = os.path.join(os.path.dirname(__file__), 'tasks.json')

class TaskManager:
    def __init__(self):
        self.tasks = self.load_tasks()
    
    def load_tasks(self):
        if os.path.exists(TASKS_FILE):
            with open(TASKS_FILE, 'r') as file:
                return json.load(file)
        return []
    
    def save_tasks(self):
        with open(TASKS_FILE, 'w') as file:
            json.dump(self.tasks, file, indent=4)
    
    def add_task(self, description):
        self.tasks.append({"task": description, "completed": False})
        self.save_tasks()
        logger.info(f"Added task: {description}")
        return "Task added successfully."
    
    def list_tasks(self):
        if not self.tasks:
            return "You have no tasks."
        response = "Here are your tasks:\n"
        for idx, task in enumerate(self.tasks, 1):
            status = "✅" if task["completed"] else "❌"
            response += f"{idx}. {task['task']} {status}\n"
        return response
    
    def complete_task(self, task_number):
        if 0 < task_number <= len(self.tasks):
            self.tasks[task_number - 1]["completed"] = True
            self.save_tasks()
            logger.info(f"Completed task #{task_number}")
            return "Task marked as completed."
        else:
            return "Invalid task number."
