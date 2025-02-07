from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.uix.spinner import Spinner
from ..services.transaction_service import TransactionService

class MoneyManagerApp(App):
    def __init__(self):
        super().__init__()
        self.transaction_service = TransactionService()

    def build(self):
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Title
        title_label = Label(
            text='Money Manager',
            font_size='24sp',
            size_hint_y=None,
            height='48dp'
        )
        layout.add_widget(title_label)
        
        # Amount input
        self.amount_input = TextInput(
            hint_text='Amount (e.g., 50.00)',
            multiline=False,
            input_filter='float',
            size_hint_y=None,
            height='48dp'
        )
        layout.add_widget(self.amount_input)
        
        # Merchant input
        self.merchant_input = TextInput(
            hint_text='Merchant name',
            multiline=False,
            size_hint_y=None,
            height='48dp'
        )
        layout.add_widget(self.merchant_input)
        
        # Category spinner
        self.category_spinner = Spinner(
            text='Category',
            values=('Shopping', 'Dining', 'Housing', 'Other'),
            size_hint_y=None,
            height='48dp'
        )
        layout.add_widget(self.category_spinner)
        
        # Save button
        save_btn = Button(
            text="Save Transaction",
            size_hint_y=None,
            height='48dp'
        )
        save_btn.bind(on_press=self.save_transaction)
        layout.add_widget(save_btn)
        
        # Transaction display label
        self.transaction_label = Label(
            text="No transactions recorded.",
            size_hint_y=None,
            height='48dp'
        )
        layout.add_widget(self.transaction_label)
        
        return layout

    def save_transaction(self, instance):
        try:
            amount = float(self.amount_input.text)
            merchant = self.merchant_input.text
            category = self.category_spinner.text
            
            if amount and merchant:
                transaction = self.transaction_service.add_manual_transaction(
                    amount=amount,
                    merchant=merchant,
                    category=category
                )
                self.transaction_label.text = f"Saved: ${amount:.2f} at {merchant}"
                # Clear inputs
                self.amount_input.text = ''
                self.merchant_input.text = ''
            else:
                self.transaction_label.text = "Please fill in all fields"
        except ValueError:
            self.transaction_label.text = "Please enter a valid amount"