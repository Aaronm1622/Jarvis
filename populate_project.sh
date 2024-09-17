#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the project root as the current directory
PROJECT_ROOT="."

# Function to create directories
create_dir() {
    mkdir -p "$PROJECT_ROOT/$1"
    echo "Created directory: $1"
}

# Function to create files with content
create_file() {
    local path="$PROJECT_ROOT/$1"
    local content="$2"
    echo "$content" > "$path"
    echo "Created file: $1"
}

# 1. Create essential directories
create_dir "config"
create_dir "src/api"
create_dir "src/tasks"
create_dir "src/scheduler"
create_dir "src/voice"
create_dir "src/integrations"
create_dir "src/utils"
create_dir "tests"
create_dir "scripts"
create_dir "docs"
create_dir "templates"
create_dir "logs"

# 2. Create __init__.py files
find src -type d -exec touch {}/__init__.py \;
find tests -type d -exec touch {}/__init__.py \;

# 3. Create and populate .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    cat <<EOL > .gitignore
# Python
__pycache__/
*.pyc
*.pyo
*.pyd

# Virtual environments
venv/
env/

# Environment variables
config/secrets.env

# Logs
logs/

# OS-specific
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
EOL
    echo "Created .gitignore"
else
    echo ".gitignore already exists. Skipping creation."
fi

# 4. Create README.md if it doesn't exist
if [ ! -f "README.md" ]; then
    cat <<EOL > README.md
# Jarvis Personal Assistant

A personal assistant powered by OpenAI's ChatGPT API, designed to help manage daily tasks, schedule reminders, and provide information seamlessly. Inspired by the intelligent and interactive Jarvis from the Iron Man series.

## 🛠️ **Features**

- **Task Management:** Add, list, and complete tasks.
- **Scheduling & Reminders:** Receive daily reminders of pending tasks.
- **Voice Interaction:** Speak commands and hear responses.
- **Integrations:** Connect with Google Calendar for event management.
- **Web Interface:** Interact through a user-friendly web dashboard.

## 📦 **Installation**

### **Prerequisites**

- Python 3.7 or higher
- [pip](https://pip.pypa.io/en/stable/)
- [Virtual Environment](https://docs.python.org/3/library/venv.html) (optional but recommended)

### **Steps**

1. **Set Up Virtual Environment**

    \`\`\`bash
    python3 -m venv venv
    source venv/bin/activate  # On Windows: venv\\Scripts\\activate
    \`\`\`

2. **Install Dependencies**

    \`\`\`bash
    pip install -r requirements.txt
    \`\`\`

3. **Configure Environment Variables**

    - Create a \`.env\` file in the \`config/\` directory.

    \`\`\`bash
    touch config/secrets.env
    \`\`\`

    - Add your API keys and secrets to \`secrets.env\`.

    \`\`\`env
    OPENAI_API_KEY=your_openai_api_key
    GOOGLE_SERVICE_ACCOUNT_FILE=path_to_google_credentials.json
    \`\`\`

4. **Run the Application**

    \`\`\`bash
    python src/main.py
    \`\`\`

## 🌐 **Usage**

Interact with Jarvis via the command line or the web interface.

### **Command Line**

- **Add Task:** \`add task Buy groceries\`
- **List Tasks:** \`list tasks\`
- **Complete Task:** \`complete task 1\`
- **Exit:** \`exit\`

### **Web Interface**

- Navigate to \`http://localhost:5000\` in your browser.
- Enter commands in the input field and view responses.

## 🧪 **Running Tests**

Ensure all tests pass before making changes.

\`\`\`bash
python -m unittest discover tests
\`\`\`

## 📄 **Documentation**

Detailed documentation is available in the \`docs/\` directory.

- **Architecture:** \`docs/architecture.md\`
- **Usage Guide:** \`docs/usage.md\`

## 🤝 **Contributing**

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## 📝 **License**

This project is licensed under the [MIT License](LICENSE).

## 📫 **Contact**

For any inquiries or support, please contact [your_email@example.com](mailto:your_email@example.com).
EOL
    echo "Created README.md"
else
    echo "README.md already exists. Skipping creation."
fi

# 5. Create LICENSE (MIT License as an example) if it doesn't exist
if [ ! -f "LICENSE" ]; then
    cat <<EOL > LICENSE
MIT License

Copyright (c) $(date +%Y) Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy...
[Full MIT License text here]
EOL
    echo "Created LICENSE file. Please replace placeholder text with the full MIT License."
else
    echo "LICENSE file already exists. Skipping creation."
fi

# 6. Create requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    cat <<EOL > requirements.txt
openai
requests
schedule
speechrecognition
pyttsx3
Flask
python-dotenv
google-api-python-client
google-auth
EOL
    echo "Created requirements.txt"
else
    echo "requirements.txt already exists. Skipping creation."
fi

# 7. Create placeholder config files
touch config/config.yaml
echo "Created config/config.yaml"
touch config/secrets.env
echo "Created config/secrets.env (Please add your secrets here)"

# 8. Create src/main.py with basic content
if [ ! -f "src/main.py" ]; then
    cat <<EOL > src/main.py
from api.chatgpt_handler import ChatGPTHandler
from tasks.task_manager import TaskManager
from scheduler.scheduler import Scheduler
from voice.text_to_speech import speak
from voice.speech_recognition import listen

def handle_command(command, task_manager, chatgpt, scheduler):
    if command.startswith("add task"):
        return task_manager.add_task(command.replace("add task", "").strip())
    elif command.startswith("list tasks"):
        return task_manager.list_tasks()
    elif command.startswith("complete task"):
        try:
            task_num = int(command.replace("complete task", "").strip())
            return task_manager.complete_task(task_num)
        except ValueError:
            return "Please provide a valid task number."
    else:
        return chatgpt.get_response(command)

def main():
    chatgpt = ChatGPTHandler()
    task_manager = TaskManager()
    scheduler = Scheduler()
    
    print("Welcome to Jarvis! How can I assist you today?")
    while True:
        command = listen()
        if command.lower() in ["exit", "quit", "stop"]:
            speak("Goodbye!")
            break
        response = handle_command(command, task_manager, chatgpt, scheduler)
        speak(response)

if __name__ == "__main__":
    main()
EOL
    echo "Created src/main.py"
else
    echo "src/main.py already exists. Skipping creation."
fi

# 9. Create src/api/chatgpt_handler.py
if [ ! -f "src/api/chatgpt_handler.py" ]; then
    cat <<EOL > src/api/chatgpt_handler.py
import openai
import os
from utils.logger import logger
from dotenv import load_dotenv

load_dotenv(dotenv_path='../../config/secrets.env')

class ChatGPTHandler:
    def __init__(self):
        openai.api_key = os.getenv('OPENAI_API_KEY')
    
    def get_response(self, prompt):
        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are Jarvis, a personal assistant."},
                    {"role": "user", "content": prompt},
                ],
                max_tokens=150,
                temperature=0.7,
            )
            return response.choices[0].message['content'].strip()
        except Exception as e:
            logger.error(f"Error communicating with ChatGPT: {e}")
            return "I'm sorry, I couldn't process that request."
EOL
    echo "Created src/api/chatgpt_handler.py"
else
    echo "src/api/chatgpt_handler.py already exists. Skipping creation."
fi

# 10. Create src/tasks/task_manager.py
if [ ! -f "src/tasks/task_manager.py" ]; then
    cat <<EOL > src/tasks/task_manager.py
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
        response = "Here are your tasks:\\n"
        for idx, task in enumerate(self.tasks, 1):
            status = "✅" if task["completed"] else "❌"
            response += f"{idx}. {task['task']} {status}\\n"
        return response
    
    def complete_task(self, task_number):
        if 0 < task_number <= len(self.tasks):
            self.tasks[task_number - 1]["completed"] = True
            self.save_tasks()
            logger.info(f"Completed task #{task_number}")
            return "Task marked as completed."
        else:
            return "Invalid task number."
EOL
    echo "Created src/tasks/task_manager.py"
else
    echo "src/tasks/task_manager.py already exists. Skipping creation."
fi

# 11. Create src/scheduler/scheduler.py
if [ ! -f "src/scheduler/scheduler.py" ]; then
    cat <<EOL > src/scheduler/scheduler.py
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
            reminder = "You have the following pending tasks:\\n" + "\\n".join(pending_tasks)
            speak(reminder)
    
    def run_scheduler(self):
        scheduler_thread = threading.Thread(target=self.run_continuously)
        scheduler_thread.daemon = True
        scheduler_thread.start()
    
    def run_continuously(self):
        while True:
            schedule.run_pending()
            time.sleep(1)
EOL
    echo "Created src/scheduler/scheduler.py"
else
    echo "src/scheduler/scheduler.py already exists. Skipping creation."
fi

# 12. Create src/voice/speech_recognition.py
if [ ! -f "src/voice/speech_recognition.py" ]; then
    cat <<EOL > src/voice/speech_recognition.py
import speech_recognition as sr
from utils.logger import logger

def listen():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        logger.info("Listening for command...")
        audio = recognizer.listen(source)
    try:
        command = recognizer.recognize_google(audio)
        logger.info(f"User said: {command}")
        return command.lower()
    except sr.UnknownValueError:
        logger.warning("Speech Recognition could not understand audio")
        return "Sorry, I did not understand that."
    except sr.RequestError as e:
        logger.error(f"Could not request results; {e}")
        return "Sorry, my speech service is down."
EOL
    echo "Created src/voice/speech_recognition.py"
else
    echo "src/voice/speech_recognition.py already exists. Skipping creation."
fi

# 13. Create src/voice/text_to_speech.py
if [ ! -f "src/voice/text_to_speech.py" ]; then
    cat <<EOL > src/voice/text_to_speech.py
import pyttsx3
from utils.logger import logger

engine = pyttsx3.init()

def speak(text):
    logger.info(f"Jarvis: {text}")
    engine.say(text)
    engine.runAndWait()
EOL
    echo "Created src/voice/text_to_speech.py"
else
    echo "src/voice/text_to_speech.py already exists. Skipping creation."
fi

# 14. Create src/integrations/google_calendar.py
if [ ! -f "src/integrations/google_calendar.py" ]; then
    cat <<EOL > src/integrations/google_calendar.py
from google.oauth2 import service_account
from googleapiclient.discovery import build
import os
import time
from utils.logger import logger

SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
SERVICE_ACCOUNT_FILE = os.getenv('GOOGLE_SERVICE_ACCOUNT_FILE')

class GoogleCalendar:
    def __init__(self):
        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_FILE, scopes=SCOPES)
        self.service = build('calendar', 'v3', credentials=credentials)
    
    def get_upcoming_events(self, max_results=10):
        now = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        try:
            events_result = self.service.events().list(
                calendarId='primary', timeMin=now,
                maxResults=max_results, singleEvents=True,
                orderBy='startTime').execute()
            events = events_result.get('items', [])
            
            if not events:
                return 'No upcoming events found.'
            response = 'Your upcoming events:\\n'
            for event in events:
                start = event['start'].get('dateTime', event['start'].get('date'))
                response += f"{start} - {event.get('summary', 'No Title')}\\n"
            return response
        except Exception as e:
            logger.error(f"Error fetching Google Calendar events: {e}")
            return "I'm sorry, I couldn't retrieve your calendar events."
EOL
    echo "Created src/integrations/google_calendar.py"
else
    echo "src/integrations/google_calendar.py already exists. Skipping creation."
fi

# 15. Create src/utils/logger.py
if [ ! -f "src/utils/logger.py" ]; then
    cat <<EOL > src/utils/logger.py
import logging
import os

LOG_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'logs')
os.makedirs(LOG_DIR, exist_ok=True)

logging.basicConfig(
    filename=os.path.join(LOG_DIR, 'app.log'),
    filemode='a',
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

logger = logging.getLogger(__name__)
EOL
    echo "Created src/utils/logger.py"
else
    echo "src/utils/logger.py already exists. Skipping creation."
fi

# 16. Create tests/test_task_manager.py
if [ ! -f "tests/test_task_manager.py" ]; then
    cat <<EOL > tests/test_task_manager.py
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
        expected = "Here are your tasks:\\n1. Task 1 ❌\\n2. Task 2 ❌\\n"
        self.assertEqual(response, expected)

if __name__ == '__main__':
    unittest.main()
EOL
    echo "Created tests/test_task_manager.py"
else
    echo "tests/test_task_manager.py already exists. Skipping creation."
fi

# 17. Create scripts/setup_env.sh
if [ ! -f "scripts/setup_env.sh" ]; then
    cat <<EOL > scripts/setup_env.sh
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

echo "Virtual environment setup complete."
EOL
    chmod +x scripts/setup_env.sh
    echo "Created scripts/setup_env.sh and made it executable"
else
    echo "scripts/setup_env.sh already exists. Skipping creation."
fi

# 18. Create scripts/deploy.sh (placeholder)
if [ ! -f "scripts/deploy.sh" ]; then
    cat <<EOL > scripts/deploy.sh
#!/bin/bash

# Deployment script placeholder
echo "Deploying the application..."
# Add your deployment commands here
EOL
    chmod +x scripts/deploy.sh
    echo "Created scripts/deploy.sh and made it executable"
else
    echo "scripts/deploy.sh already exists. Skipping creation."
fi

# 19. Create docs/architecture.md
if [ ! -f "docs/architecture.md" ]; then
    cat <<EOL > docs/architecture.md
# Architecture

## Overview

The Jarvis Personal Assistant is structured into modular components to ensure scalability and maintainability. Below is an overview of the system architecture:

- **API Layer (`src/api/`):** Handles interactions with external APIs, such as OpenAI's ChatGPT and Google Calendar.
- **Task Management (`src/tasks/`):** Manages user tasks, including creation, listing, and completion.
- **Scheduler (`src/scheduler/`):** Handles scheduling tasks and reminders.
- **Voice Interaction (`src/voice/`):** Manages speech recognition and text-to-speech functionalities.
- **Integrations (`src/integrations/`):** Connects with third-party services like Google Calendar.
- **Utilities (`src/utils/`):** Contains utility modules like logging.
- **Tests (`tests/`):** Contains unit and integration tests to ensure code reliability.

## Data Flow

1. **User Input:** The user provides commands via voice or web interface.
2. **Speech Recognition:** If using voice, the `speech_recognition` module captures and processes the audio input.
3. **Command Handling:** The `main.py` script interprets the command and delegates it to the appropriate module (e.g., task management, ChatGPT API).
4. **API Interaction:** For complex queries, the `ChatGPTHandler` interacts with OpenAI's API to generate responses.
5. **Task Operations:** Task-related commands are handled by the `TaskManager`.
6. **Scheduling:** The `Scheduler` sets up reminders and executes scheduled tasks.
7. **Voice Response:** Responses are converted to speech using the `text_to_speech` module and played back to the user.
8. **Logging:** All operations and errors are logged using the `logger` utility for debugging and monitoring.

## Component Interactions

- **`main.py`** acts as the orchestrator, coordinating between different modules based on user input.
- **`ChatGPTHandler`** communicates with external APIs and returns processed responses.
- **`TaskManager`** maintains the state of user tasks and ensures persistence through JSON storage.
- **`Scheduler`** ensures timely reminders and task management without blocking the main application flow.
- **`Voice Modules`** handle all aspects of audio input and output, providing an interactive user experience.
- **`Logger`** records all significant events, aiding in troubleshooting and performance monitoring.

## Future Enhancements

- **Additional Integrations:** Incorporate more third-party services like email, messaging platforms, or smart home devices.
- **Enhanced Voice Capabilities:** Improve voice recognition accuracy and support multiple languages.
- **User Authentication:** Implement user accounts and authentication mechanisms for personalized experiences.
- **Web Interface Improvements:** Develop a more comprehensive web dashboard with advanced features and settings.

EOL
    echo "Created docs/architecture.md"
else
    echo "docs/architecture.md already exists. Skipping creation."
fi

# 20. Create docs/usage.md
if [ ! -f "docs/usage.md" ]; then
    cat <<EOL > docs/usage.md
# Usage Guide

## Getting Started

After setting up the project (see [Installation](../README.md#-installation)), you can start interacting with Jarvis.

## Command Line Interaction

### **Adding a Task**

**Command:**
\`\`\`bash
add task Buy groceries
\`\`\`

**Response:**
\`Jarvis: Task added successfully.\`

### **Listing Tasks**

**Command:**
\`\`\`bash
list tasks
\`\`\`

**Response:**
\`Jarvis: Here are your tasks:
1. Buy groceries ❌\`

### **Completing a Task**

**Command:**
\`\`\`bash
complete task 1
\`\`\`

**Response:**
\`Jarvis: Task marked as completed.\`

### **Exiting the Assistant**

**Command:**
\`\`\`bash
exit
\`\`\`

**Response:**
\`Jarvis: Goodbye!\`

## Web Interface Interaction

1. **Accessing the Web Interface:**

   Navigate to \`http://localhost:5000\` in your web browser.

2. **Entering Commands:**

   - Use the input field to type your commands.
   - Press the "Send" button to submit.

3. **Viewing Responses:**

   - Your commands and Jarvis's responses will be displayed on the page.

## Voice Interaction

Ensure your microphone is connected and properly configured.

1. **Speaking Commands:**

   - Speak your commands clearly when prompted.
   - Example: "Add task Schedule meeting with team."

2. **Listening to Responses:**

   - Jarvis will respond verbally through your speakers/headphones.

## Scheduling and Reminders

- **Default Reminder Time:** 09:00 AM daily.
- **Customizing Reminder Time:**
  - Modify the `src/scheduler/scheduler.py` file to change the reminder time.

## Integrations

### **Google Calendar**

- **Setup:**
  - Ensure you have a Google Cloud project with the Calendar API enabled.
  - Download the service account credentials JSON file.
  - Add the path to the JSON file in `config/secrets.env` as \`GOOGLE_SERVICE_ACCOUNT_FILE\`.

- **Fetching Events:**
  - Jarvis can fetch and announce your upcoming calendar events.

## Running Tests

Ensure all tests pass to verify functionality.

```bash
python -m unittest discover tests
