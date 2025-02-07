from kivymd.uix.boxlayout import MDBoxLayout
from kivymd.uix.textfield import MDTextField
from kivymd.uix.button import MDRaisedButton
from kivymd.uix.spinner import MDSpinner
from kivymd.uix.list import OneLineIconListItem

class TransactionForm(MDBoxLayout):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = "vertical"
        self.spacing = "16dp"
        self.padding = "16dp"
        self.setup_form()
    
    def setup_form(self):
        # Amount input
        self.amount_input = MDTextField(
            hint_text="Amount (e.g., 50.00)",
            helper_text="Please enter a valid amount",
            helper_text_mode="on_error",
            input_filter="float",
            size_hint_y=None,
            height="48dp"
        )
        
        # Merchant input
        self.merchant_input = MDTextField(
            hint_text="Merchant name",
            helper_text="Enter merchant name",
            helper_text_mode="on_error",
            size_hint_y=None,
            height="48dp"
        )
        
        # Category selection
        self.category_input = MDTextField(
            hint_text="Category",
            helper_text="Select transaction category",
            helper_text_mode="on_error",
            size_hint_y=None,
            height="48dp",
            readonly=True,
            on_focus=self.show_category_dialog
        )
        
        # Add widgets
        self.add_widget(self.amount_input)
        self.add_widget(self.merchant_input)
        self.add_widget(self.category_input)
    
    def show_category_dialog(self, instance, value):
        if value:  # Only show when focused
            # Add category selection dialog logic here
            pass
            
    def validate(self):
        is_valid = True
        
        if not self.amount_input.text:
            self.amount_input.error = True
            is_valid = False
            
        if not self.merchant_input.text:
            self.merchant_input.error = True
            is_valid = False
            
        if not self.category_input.text:
            self.category_input.error = True
            is_valid = False
            
        return is_valid