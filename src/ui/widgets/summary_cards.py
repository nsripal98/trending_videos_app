from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel

class SummaryCards(MDCard):
    def __init__(self, data, **kwargs):
        super().__init__(**kwargs)
        self.orientation = "horizontal"
        self.padding = "10dp"
        self.spacing = "10dp"
        self.setup_cards(data)
    
    def setup_cards(self, data):
        for title, value in data.items():
            card = MDCard(
                MDLabel(
                    text=title,
                    theme_text_color="Secondary",
                    halign="center"
                ),
                MDLabel(
                    text=value,
                    theme_text_color="Primary",
                    halign="center",
                    font_style="H5"
                ),
                orientation="vertical",
                size_hint=(None, None),
                size=("100dp", "100dp"),
                elevation=2
            )
            self.add_widget(card)