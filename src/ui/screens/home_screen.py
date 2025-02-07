from kivymd.uix.screen import MDScreen
from kivymd.uix.boxlayout import MDBoxLayout
from ..widgets.balance_overview import BalanceOverview
from ..widgets.transaction_list import TransactionList
from ..widgets.add_transaction_fab import AddTransactionFAB

class HomeScreen(MDScreen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_ui()
    
    def setup_ui(self):
        layout = MDBoxLayout(orientation='vertical', spacing="10dp", padding="16dp")
        
        # Balance overview card
        self.balance = BalanceOverview()
        
        # Transaction list
        self.transactions = TransactionList()
        
        # Floating action button for adding transactions
        self.fab = AddTransactionFAB()
        
        # Add widgets
        layout.add_widget(self.balance)
        layout.add_widget(self.transactions)
        self.add_widget(layout)
        self.add_widget(self.fab)