from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel
from kivy.uix.image import AsyncImage

class VideoCard(MDCard):
    def __init__(self, video_data, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'vertical'
        self.size_hint_y = None
        self.height = "200dp"
        self.padding = "8dp"
        self.md_bg_color = [0.1, 0.1, 0.1, 1]
        self.radius = [15, 15, 15, 15]
        
        # Thumbnail
        self.thumbnail = AsyncImage(
            source=video_data['thumbnail'],
            allow_stretch=True,
            keep_ratio=True,
            size_hint_y=0.7
        )
        
        # Platform Icon
        platform_colors = {
            'youtube': [1, 0, 0, 1],
            'instagram': [0.8, 0.2, 0.8, 1],
            'facebook': [0.2, 0.4, 0.8, 1]
        }
        
        self.platform = MDLabel(
            text=video_data['platform'].capitalize(),
            theme_text_color="Custom",
            text_color=platform_colors.get(video_data['platform'], [1, 1, 1, 1]),
            size_hint_y=0.1,
            font_style="Caption"
        )
        
        # Title
        self.title = MDLabel(
            text=video_data['title'],
            theme_text_color="Custom",
            text_color=[1, 1, 1, 1],
            size_hint_y=0.2,
            font_style="Caption"
        )
        
        # Views
        self.views = MDLabel(
            text=f"{int(video_data['views']):,} views",
            theme_text_color="Custom",
            text_color=[0.7, 0.7, 0.7, 1],
            size_hint_y=0.1,
            font_style="Caption"
        )
        
        # Add widgets
        self.add_widget(self.thumbnail)
        self.add_widget(self.platform)
        self.add_widget(self.title)
        self.add_widget(self.views)