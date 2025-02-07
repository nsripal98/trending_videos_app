from kivymd.uix.gridlayout import MDGridLayout
from kivymd.uix.button import MDIconButton
from kivymd.uix.label import MDLabel

class QuickActionsGrid(MDGridLayout):
    def __init__(self, actions, **kwargs):
        super().__init__(**kwargs)
        self.cols = 3
        self.spacing = "10dp"
        self.padding = "10dp"
        
        for action in actions:
            btn = MDIconButton(
                icon=action["icon"],
                theme_text_color="Custom",
                text_color="#009688"
            )
            label = MDLabel(
                text=action["text"],
                halign="center",
                theme_text_color="Secondary"
            )
            self.add_widget(btn)
            self.add_widget(label)