from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel
from kivymd.uix.boxlayout import MDBoxLayout

class BalanceOverview(MDCard):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.padding = "16dp"
        self.setup_ui()
    
    def setup_ui(self):
        layout = MDBoxLayout(orientation='vertical', spacing="8dp")
        
        # Income
        income_layout = MDBoxLayout(orientation='horizontal')
        income_layout.add_widget(MDLabel(
            text="Income",
            theme_text_color="Secondary"
        ))
        income_layout.add_widget(MDLabel(
            text="$5,300",
            theme_text_color="Custom",
            text_color=(0, 0.7, 0, 1),
            halign="right"
        ))
        
        # Expenses
        expense_layout = MDBoxLayout(orientation='horizontal')
        expense_layout.add_widget(MDLabel(
            text="Expenses",
            theme_text_color="Secondary"
        ))
        expense_layout.add_widget(MDLabel(
            text="$3,200",
            theme_text_color="Custom",
            text_color=(0.7, 0, 0, 1),
            halign="right"
        ))
        
        # Net Balance
        balance_layout = MDBoxLayout(orientation='horizontal')
        balance_layout.add_widget(MDLabel(
            text="Net Balance",
            theme_text_color="Primary",
            font_style="H6"
        ))
        balance_layout.add_widget(MDLabel(
            text="$2,100",
            theme_text_color="Primary",
            font_style="H6",
            halign="right"
        ))
        
        layout.add_widget(income_layout)
        layout.add_widget(expense_layout)
        layout.add_widget(balance_layout)
        self.add_widget(layout)