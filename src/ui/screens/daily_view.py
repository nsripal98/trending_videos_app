from kivymd.uix.screen import MDScreen
from kivymd.uix.list import MDList, OneLineListItem
from datetime import datetime

class DailyView(MDScreen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.load_transactions()
    
    def load_transactions(self):
        transactions = [
            {
                'date': '03',
                'day': 'Fri',
                'description': 'MRT charges Card (Weekdays)',
                'amount': 261.22,
                'currency': 'S$',
                'type': 'expense'
            },
            {
                'date': '02',
                'day': 'Thu',
                'description': 'MRT charges Card (Weekdays)',
                'amount': 261.22,
                'currency': 'S$',
                'type': 'expense'
            },
            {
                'date': '01',
                'day': 'Wed',
                'description': 'MRT charges Card (Weekdays)',
                'amount': 261.22,
                'currency': 'S$',
                'type': 'expense'
            }
        ]
        
        for t in transactions:
            self.add_transaction(t)
            
    def add_transaction(self, transaction):
        item = OneLineListItem(
            text=f"{transaction['date']} {transaction['day']} - {transaction['description']} - {transaction['currency']}{transaction['amount']:.2f}"
        )
        self.ids.transaction_list.add_widget(item)