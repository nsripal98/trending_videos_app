# Money Manager App

A voice-enabled money management application that tracks expenses through voice commands and SMS messages.

## Features

- Voice command transaction recording
- SMS transaction parsing
- Transaction categorization
- Simple Kivy-based UI

## Requirements

- Python 3.9+
- Kivy 2.1.0
- Speech Recognition 3.8.1
- pyttsx3 2.90
- pandas 1.5.3
- plyer

## Installation

1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Run the app: `python src/main.py`

## Usage

1. Click "Record Transaction" to add a transaction via voice
2. Speak your transaction (e.g., "spent $50 at Amazon")
3. The app will automatically categorize and save the transaction

## Permissions Required

- RECORD_AUDIO - For voice commands
- READ_SMS - For SMS transaction parsing
- INTERNET - For speech recognition