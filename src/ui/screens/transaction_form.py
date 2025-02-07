from kivymd.uix.screen import MDScreen
from datetime import datetime
from kivy.properties import StringProperty, BooleanProperty
from kivy.metrics import dp

class TransactionForm(MDScreen):
    form_title = StringProperty("Expense")
    current_date = StringProperty("")
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.transaction_type = 'expense'
        self.update_date()
        
    def update_date(self):
        self.current_date = datetime.now().strftime("%-m/%-d/%y (%a) %H:%M")
        
    def set_type(self, type_name):
        self.transaction_type = type_name
        self.form_title = type_name.capitalize()
        
    def get_type_color(self, type_name):
        colors = {
            'income': "1565C0" if self.transaction_type == 'income' else "1a1f2b",
            'expense': "D32F2F" if self.transaction_type == 'expense' else "1a1f2b",
            'transfer': "1a1f2b" if self.transaction_type == 'transfer' else "1a1f2b"
        }
        return colors.get(type_name, "1a1f2b")
        
    def go_back(self):
        self.parent.current = 'transactions'
        self.parent.remove_widget(self)
        
    def toggle_favorite(self):
        pass