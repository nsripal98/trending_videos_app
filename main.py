from kivy.lang import Builder
from kivymd.app import MDApp
from kivy.core.window import Window
from kivy.utils import platform
from services.youtube_service import YouTubeService
from services.instagram_service import InstagramService
from services.facebook_service import FacebookService

class TrendingVideosApp(MDApp):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Initialize services
        self.youtube_service = YouTubeService()
        self.instagram_service = InstagramService()
        self.facebook_service = FacebookService()
        
        # Set theme
        self.theme_cls.theme_style = "Dark"
        self.theme_cls.primary_palette = "DeepPurple"
        
        # Set window size for desktop development
        if platform != 'android':
            Window.size = (400, 800)

    def build(self):
        return Builder.load_file('ui/main.kv')

    def on_start(self):
        # Load initial data
        self.load_trending_videos()

    def load_trending_videos(self, region_code='US', state_code=None):
        # Get trending videos from each platform
        youtube_videos = self.youtube_service.get_trending_videos(region_code=region_code)
        instagram_videos = self.instagram_service.get_trending_videos(region_code=region_code)
        facebook_videos = self.facebook_service.get_trending_videos(region_code=region_code)
        
        if state_code:
            # Get state-specific trending videos
            youtube_state = self.youtube_service.get_trending_by_state(state_code)
            instagram_state = self.instagram_service.get_trending_by_state(state_code)
            facebook_state = self.facebook_service.get_trending_by_state(state_code)
            
            # Update UI with state-specific videos
            self.root.ids.state_video_grid.update_videos(
                youtube_state,
                instagram_state,
                facebook_state
            )
        
        # Update UI with country-wide videos
        self.root.ids.video_grid.update_videos(
            youtube_videos,
            instagram_videos,
            facebook_videos
        )

if __name__ == '__main__':
    TrendingVideosApp().run()