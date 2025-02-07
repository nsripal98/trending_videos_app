from kivymd.uix.screen import MDScreen
from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel
from ..widgets.transaction_chart import TransactionChart
from ..widgets.quick_actions import QuickActionsGrid
from ..widgets.summary_cards import SummaryCards

class DashboardScreen(MDScreen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_ui()
    
    def setup_ui(self):
        # Main chart showing transaction history
        self.chart = TransactionChart()
        
        # Summary cards showing transactions, income, expenses
        self.summary = SummaryCards(
            data={
                "Transactions": "3",
                "Income": "2300",
                "Transactions": "2300"
            }
        )
        
        # Quick action buttons grid
        self.actions = QuickActionsGrid(
            actions=[
                {"icon": "email", "text": "Daily\nTransactions"},
                {"icon": "chart-pie", "text": "Income\nSummary"},
                {"icon": "chart-arc", "text": "Food\nExpenses"},
                {"icon": "calendar", "text": "Monthly\nView"},
                {"icon": "account-group", "text": "Split\nWise"},
                {"icon": "heart", "text": "Favorites"}
            ]
        )
        
        # Add widgets to screen
        self.add_widget(self.chart)
        self.add_widget(self.summary)
        self.add_widget(self.actions)