import speech_recognition as sr
import pyttsx3

class SpeechService:
    def __init__(self):
        self.recognizer = sr.Recognizer()
        self.engine = pyttsx3.init()

    def listen(self):
        with sr.Microphone() as source:
            print("Listening for a transaction command...")
            self.engine.say("Please tell me your transaction details.")
            self.engine.runAndWait()
            self.recognizer.adjust_for_ambient_noise(source)
            audio = self.recognizer.listen(source)
        
        try:
            return self.recognizer.recognize_google(audio)
        except sr.UnknownValueError:
            self.engine.say("Sorry, I couldn't understand you.")
            self.engine.runAndWait()
            return None
        except sr.RequestError as e:
            print(f"Error with speech recognition service: {e}")
            return None

    def speak(self, text):
        self.engine.say(text)
        self.engine.runAndWait()