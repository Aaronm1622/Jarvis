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
