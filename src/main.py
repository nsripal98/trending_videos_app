from kivymd.app import MDApp
from kivy.lang import Builder
from kivy.core.window import Window
from kivy.utils import platform
from src.ui.screens.main_screen import MainScreen

class MoneyManagerApp(MDApp):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Set app theme
        self.theme_cls.theme_style = "Dark"
        self.theme_cls.primary_palette = "Blue"  # Facebook blue
        self.theme_cls.accent_palette = "Red"
        
        # Set window properties for development
        if platform != 'android':
            Window.size = (400, 800)
        
    def build(self):
        # Load all KV files
        for kv_file in [
            'src/ui/screens/main_screen.kv',
            'src/ui/screens/transaction_form.kv',
            'src/ui/screens/daily_view.kv',
            'src/ui/screens/calendar_view.kv',
            'src/ui/screens/monthly_view.kv',
            'src/ui/screens/total_view.kv',
            'src/ui/screens/note_view.kv'
        ]:
            Builder.load_file(kv_file)
        return MainScreen()

if __name__ == '__main__':
    MoneyManagerApp().run()