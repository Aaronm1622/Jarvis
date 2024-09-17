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
