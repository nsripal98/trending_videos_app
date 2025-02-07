from kivymd.uix.list import MDList, TwoLineIconListItem
from kivymd.uix.card import MDCard
from kivymd.uix.boxlayout import MDBoxLayout

class TransactionList(MDCard):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.padding = "8dp"
        self.setup_ui()
    
    def setup_ui(self):
        layout = MDBoxLayout(orientation='vertical')
        self.list = MDList()
        
        # Sample transactions
        transactions = [
            {"amount": "5.30", "type": "Income", "category": "Salary"},
            {"amount": "5.20", "type": "Expense", "category": "Food"},
            {"amount": "5.25", "type": "Expense", "category": "Transport"}
        ]
        
        for t in transactions:
            item = TwoLineIconListItem(
                text=f"${t['amount']} - {t['type']}",
                secondary_text=t['category'],
                on_release=lambda x, t=t: self.show_transaction_details(t)
            )
            self.list.add_widget(item)
            
        layout.add_widget(self.list)
        self.add_widget(layout)
    
    def show_transaction_details(self, transaction):
        # Show transaction details dialog
        pass