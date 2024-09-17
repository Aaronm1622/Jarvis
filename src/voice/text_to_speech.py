import pyttsx3
from utils.logger import logger

engine = pyttsx3.init()

def speak(text):
    logger.info(f"Jarvis: {text}")
    engine.say(text)
    engine.runAndWait()
