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
