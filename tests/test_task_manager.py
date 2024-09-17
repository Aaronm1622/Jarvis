import unittest
from src.tasks.task_manager import TaskManager

class TestTaskManager(unittest.TestCase):
    def setUp(self):
        self.task_manager = TaskManager()
        self.task_manager.tasks = []  # Reset tasks for testing
    
    def test_add_task(self):
        response = self.task_manager.add_task("Test Task")
        self.assertEqual(response, "Task added successfully.")
        self.assertEqual(len(self.task_manager.tasks), 1)
        self.assertEqual(self.task_manager.tasks[0]['task'], "Test Task")
        self.assertFalse(self.task_manager.tasks[0]['completed'])
    
    def test_complete_task(self):
        self.task_manager.add_task("Test Task")
        response = self.task_manager.complete_task(1)
        self.assertEqual(response, "Task marked as completed.")
        self.assertTrue(self.task_manager.tasks[0]['completed'])
    
    def test_list_tasks_empty(self):
        response = self.task_manager.list_tasks()
        self.assertEqual(response, "You have no tasks.")
    
    def test_list_tasks(self):
        self.task_manager.add_task("Task 1")
        self.task_manager.add_task("Task 2")
        response = self.task_manager.list_tasks()
        expected = "Here are your tasks:\n1. Task 1 ❌\n2. Task 2 ❌\n"
        self.assertEqual(response, expected)

if __name__ == '__main__':
    unittest.main()
