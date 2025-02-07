from kivymd.uix.screen import MDScreen
from datetime import datetime

class MainScreen(MDScreen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        
    def show_transaction_form(self):
        from src.ui.screens.transaction_form import TransactionForm
        self.add_widget(TransactionForm(name='transaction_form'))
        self.current = 'transaction_form'
        
    def switch_tab(self, tab_name):
        pass
        
    def previous_month(self):
        pass
        
    def toggle_favorite(self):
        pass
        
    def search(self):
        pass
        
    def show_menu(self):
        pass