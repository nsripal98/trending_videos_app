from kivymd.uix.screen import MDScreen
from kivymd.uix.list import MDList, OneLineIconListItem
from kivymd.uix.card import MDCard
from ..widgets.transaction_form import TransactionForm
from ..widgets.monthly_overview import MonthlyOverview

class AddTransactionScreen(MDScreen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_ui()
    
    def setup_ui(self):
        # Transaction input form
        self.form = TransactionForm()
        
        # Quick summary circles
        self.summary = MDCard(
            MDLabel(text="13.5k"),
            MDLabel(text="6.0k"),
            MDLabel(text="36.9k"),
            MDLabel(text="23.6k"),
            orientation="horizontal",
            spacing="10dp"
        )
        
        # Monthly overview chart
        self.overview = MonthlyOverview()
        
        # Transaction type list
        self.types = MDList(
            OneLineIconListItem(text="Log-Wise Transactions"),
            OneLineIconListItem(text="Split-Wise Transactions")
        )
        
        # Add all components
        self.add_widget(self.form)
        self.add_widget(self.summary) 
        self.add_widget(self.overview)
        self.add_widget(self.types)