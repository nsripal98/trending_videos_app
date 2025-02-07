from kivymd.uix.button import MDFloatingActionButton
from kivymd.uix.dialog import MDDialog
from kivymd.uix.boxlayout import MDBoxLayout
from kivymd.uix.button import MDFlatButton
from kivymd.uix.textfield import MDTextField
from kivymd.uix.menu import MDDropdownMenu

class AddTransactionFAB(MDFloatingActionButton):
    def __init__(self, **kwargs):
        super().__init__(
            icon="plus",
            pos_hint={"right": 0.95, "bottom": 0.05},
            md_bg_color="#009688",
            on_release=self.show_dialog
        )
        self.setup_dialog()
    
    def setup_dialog(self):
        self.dialog = MDDialog(
            title="Add Transaction",
            type="custom",
            content_cls=AddTransactionForm(),
            buttons=[
                MDFlatButton(
                    text="CANCEL",
                    theme_text_color="Custom",
                    text_color="#009688",
                    on_release=lambda x: self.dialog.dismiss()
                ),
                MDFlatButton(
                    text="SAVE",
                    theme_text_color="Custom",
                    text_color="#009688",
                    on_release=self.save_transaction
                ),
            ],
        )
    
    def show_dialog(self, instance):
        self.dialog.open()
        
    def save_transaction(self, instance):
        # Save transaction logic here
        self.dialog.dismiss()