from kivy.uix.screenmanager import Screen
from kivy.animation import Animation
from kivy.clock import Clock
from kivymd.uix.label import MDLabel
from kivymd.uix.image import MDImage

class SplashScreen(Screen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_ui()
        
    def setup_ui(self):
        # Logo
        self.logo = MDImage(
            source="assets/logo.png",
            pos_hint={'center_x': 0.5, 'center_y': 0.6},
            size_hint=(0.3, 0.3)
        )
        
        # App name
        self.app_name = MDLabel(
            text="Money Manager",
            halign="center",
            pos_hint={'center_x': 0.5, 'center_y': 0.4},
            font_style="H4"
        )
        
        self.add_widget(self.logo)
        self.add_widget(self.app_name)
        
    def on_enter(self):
        # Fade in animation
        anim = Animation(opacity=1, duration=1.5)
        anim.start(self.logo)
        anim.start(self.app_name)
        
        # Schedule transition to home screen
        Clock.schedule_once(self.switch_to_home, 2)