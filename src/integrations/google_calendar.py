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
            response = 'Your upcoming events:\n'
            for event in events:
                start = event['start'].get('dateTime', event['start'].get('date'))
                response += f"{start} - {event.get('summary', 'No Title')}\n"
            return response
        except Exception as e:
            logger.error(f"Error fetching Google Calendar events: {e}")
            return "I'm sorry, I couldn't retrieve your calendar events."
