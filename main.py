import kivy
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.scrollview import ScrollView
from kivy.uix.gridlayout import GridLayout
from kivy.uix.image import AsyncImage
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.core.window import Window
from kivy.uix.textinput import TextInput
from kivy.network.urlrequest import UrlRequest
import json
import os
import ssl
from functools import partial

# Set app version
kivy.require('2.1.0')

# Platform-specific settings
from kivy.utils import platform
if platform == 'android':
    from android.permissions import request_permissions, Permission
    request_permissions([
        Permission.INTERNET,
        Permission.READ_EXTERNAL_STORAGE,
        Permission.WRITE_EXTERNAL_STORAGE
    ])

# Define color scheme
COLORS = {
    'primary': [0.2, 0.6, 0.9, 1],
    'secondary': [0.9, 0.3, 0.3, 1],
    'background': [0.95, 0.95, 0.95, 1],
    'text': [0.1, 0.1, 0.1, 1],
    'card': [1, 1, 1, 1]
}

# Mock data for development
PLATFORMS = ['youtube', 'instagram', 'facebook', 'twitter', 'tiktok']

COUNTRIES = [
    {'name': 'United States', 'code': 'us'},
    {'name': 'India', 'code': 'in'},
    {'name': 'United Kingdom', 'code': 'uk'},
    {'name': 'Canada', 'code': 'ca'},
    {'name': 'Australia', 'code': 'au'}
]

REGIONS = {
    'us': [
        {'name': 'California', 'code': 'ca'},
        {'name': 'New York', 'code': 'ny'},
        {'name': 'Texas', 'code': 'tx'},
        {'name': 'Florida', 'code': 'fl'}
    ],
    'in': [
        {'name': 'Maharashtra', 'code': 'mh'},
        {'name': 'Delhi', 'code': 'dl'},
        {'name': 'Karnataka', 'code': 'ka'},
        {'name': 'Tamil Nadu', 'code': 'tn'}
    ]
}

MOCK_VIDEOS = [
    {
        'id': '1',
        'title': 'Amazing Travel Vlog in Bali',
        'platform': 'youtube',
        'thumbnail': 'https://via.placeholder.com/300x200',
        'views': 1500000,
        'likes': 120000,
        'url': 'https://youtube.com/watch?v=example1'
    },
    {
        'id': '2',
        'title': 'Cooking Tutorial: Perfect Pasta',
        'platform': 'instagram',
        'thumbnail': 'https://via.placeholder.com/300x200',
        'views': 890000,
        'likes': 75000,
        'url': 'https://instagram.com/p/example2'
    },
    {
        'id': '3',
        'title': 'Tech Review: Latest Smartphone',
        'platform': 'youtube',
        'thumbnail': 'https://via.placeholder.com/300x200',
        'views': 2100000,
        'likes': 180000,
        'url': 'https://youtube.com/watch?v=example3'
    },
    {
        'id': '4',
        'title': 'Dance Challenge Goes Viral',
        'platform': 'tiktok',
        'thumbnail': 'https://via.placeholder.com/300x200',
        'views': 5000000,
        'likes': 950000,
        'url': 'https://tiktok.com/@user/video/example4'
    },
    {
        'id': '5',
        'title': 'Breaking News: Global Event',
        'platform': 'twitter',
        'thumbnail': 'https://via.placeholder.com/300x200',
        'views': 750000,
        'likes': 45000,
        'url': 'https://twitter.com/user/status/example5'
    }
]

# API functions
def fetch_trending_videos(country_code=None, region_code=None, platform=None, callback=None):
    """Fetch trending videos based on filters"""
    # In a real app, this would make an API request
    # For now, return mock data with basic filtering
    filtered_videos = MOCK_VIDEOS
    
    if platform:
        filtered_videos = [v for v in filtered_videos if v['platform'] == platform]
    
    # Simulate network delay
    from kivy.clock import Clock
    def delayed_callback(dt):
        if callback:
            callback(filtered_videos)
    
    Clock.schedule_once(delayed_callback, 1)

def fetch_content_analysis(video_id, callback=None):
    """Fetch content analysis for a video"""
    # Mock content analysis
    analysis = {
        'sentiment': 'positive',
        'topics': ['entertainment', 'lifestyle', 'travel'],
        'engagement_score': 8.7
    }
    
    from kivy.clock import Clock
    def delayed_callback(dt):
        if callback:
            callback(analysis)
    
    Clock.schedule_once(delayed_callback, 0.5)

# UI Components
class PlatformButton(Button):
    def __init__(self, platform, **kwargs):
        super(PlatformButton, self).__init__(**kwargs)
        self.platform = platform
        self.text = platform.capitalize()
        self.background_normal = ''
        self.background_color = COLORS['card']
        self.color = COLORS['text']
        self.size_hint = (None, None)
        self.size = (150, 50)
        self.selected = False
        
    def toggle_selection(self):
        self.selected = not self.selected
        if self.selected:
            self.background_color = COLORS['primary']
            self.color = [1, 1, 1, 1]
        else:
            self.background_color = COLORS['card']
            self.color = COLORS['text']

class VideoCard(BoxLayout):
    def __init__(self, video, **kwargs):
        super(VideoCard, self).__init__(**kwargs)
        self.orientation = 'vertical'
        self.size_hint_y = None
        self.height = 300
        self.padding = [10, 10]
        self.spacing = 5
        self.video = video
        
        # Card background
        self.canvas.before.add(kivy.graphics.Color(*COLORS['card']))
        self.canvas.before.add(kivy.graphics.Rectangle(pos=self.pos, size=self.size))
        
        # Thumbnail
        self.thumbnail = AsyncImage(
            source=video['thumbnail'],
            allow_stretch=True,
            keep_ratio=True,
            size_hint_y=None,
            height=180
        )
        
        # Platform indicator
        platform_layout = BoxLayout(size_hint_y=None, height=30)
        platform_label = Label(
            text=video['platform'].upper(),
            color=COLORS['primary'],
            size_hint_x=None,
            width=100,
            halign='left'
        )
        platform_layout.add_widget(platform_label)
        
        # Title
        title = Label(
            text=video['title'],
            color=COLORS['text'],
            size_hint_y=None,
            height=40,
            text_size=(self.width, None),
            halign='left',
            valign='top'
        )
        
        # Stats
        stats_layout = BoxLayout(size_hint_y=None, height=30)
        views_label = Label(
            text=f"{video['views']:,} views",
            color=COLORS['text'],
            halign='left'
        )
        likes_label = Label(
            text=f"{video['likes']:,} likes",
            color=COLORS['text'],
            halign='right'
        )
        stats_layout.add_widget(views_label)
        stats_layout.add_widget(likes_label)
        
        # Add all elements to card
        self.add_widget(self.thumbnail)
        self.add_widget(platform_layout)
        self.add_widget(title)
        self.add_widget(stats_layout)
        
        # Bind touch event to open video
        self.bind(on_touch_down=self.on_card_click)
        
    def on_card_click(self, instance, touch):
        if self.collide_point(*touch.pos):
            app = App.get_running_app()
            app.open_video(self.video)
            return True

# Screens
class HomeScreen(Screen):
    def __init__(self, **kwargs):
        super(HomeScreen, self).__init__(**kwargs)
        self.selected_platform = None
        self.selected_country = None
        self.selected_region = None
        
        # Main layout
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Header
        header = BoxLayout(size_hint_y=None, height=50)
        title = Label(text='Trending Videos', font_size=24, color=COLORS['text'])
        header.add_widget(title)
        
        # Platform filter
        platform_label = Label(
            text='Filter by Platform:',
            size_hint_y=None,
            height=30,
            halign='left',
            color=COLORS['text']
        )
        
        platform_scroll = ScrollView(
            size_hint_y=None,
            height=70,
            bar_width=0
        )
        platform_layout = BoxLayout(
            size_hint_x=None,
            spacing=10,
            padding=[5, 5]
        )
        platform_layout.bind(minimum_width=platform_layout.setter('width'))
        
        self.platform_buttons = {}
        for platform in PLATFORMS:
            btn = PlatformButton(platform=platform)
            btn.bind(on_release=self.on_platform_select)
            platform_layout.add_widget(btn)
            self.platform_buttons[platform] = btn
            
        platform_scroll.add_widget(platform_layout)
        
        # Country selection
        country_layout = BoxLayout(size_hint_y=None, height=50, spacing=10)
        country_label = Label(
            text='Country:',
            size_hint_x=None,
            width=100,
            color=COLORS['text']
        )
        self.country_spinner = Button(
            text='Select Country',
            background_normal='',
            background_color=COLORS['card'],
            color=COLORS['text']
        )
        self.country_spinner.bind(on_release=self.show_country_selection)
        country_layout.add_widget(country_label)
        country_layout.add_widget(self.country_spinner)
        
        # Region selection (initially hidden)
        self.region_layout = BoxLayout(size_hint_y=None, height=50, spacing=10, opacity=0)
        region_label = Label(
            text='Region:',
            size_hint_x=None,
            width=100,
            color=COLORS['text']
        )
        self.region_spinner = Button(
            text='Select Region',
            background_normal='',
            background_color=COLORS['card'],
            color=COLORS['text']
        )
        self.region_spinner.bind(on_release=self.show_region_selection)
        self.region_layout.add_widget(region_label)
        self.region_layout.add_widget(self.region_spinner)
        
        # Videos grid
        self.videos_scroll = ScrollView()
        self.videos_grid = GridLayout(
            cols=1,
            spacing=10,
            size_hint_y=None,
            padding=[10, 10]
        )
        self.videos_grid.bind(minimum_height=self.videos_grid.setter('height'))
        self.videos_scroll.add_widget(self.videos_grid)
        
        # Add all elements to main layout
        layout.add_widget(header)
        layout.add_widget(platform_label)
        layout.add_widget(platform_scroll)
        layout.add_widget(country_layout)
        layout.add_widget(self.region_layout)
        layout.add_widget(self.videos_scroll)
        
        self.add_widget(layout)
        
        # Load initial videos
        self.load_videos()
        
    def on_platform_select(self, button):
        button.toggle_selection()
        
        # Check if any platform is selected
        selected_platforms = [p for p, btn in self.platform_buttons.items() if btn.selected]
        
        if selected_platforms:
            self.selected_platform = selected_platforms[0]  # For now, just use the first selected
        else:
            self.selected_platform = None
            
        self.load_videos()
        
    def show_country_selection(self, button):
        app = App.get_running_app()
        app.show_countries(self.on_country_selected)
        
    def on_country_selected(self, country):
        self.selected_country = country
        self.country_spinner.text = country['name']
        
        # Show region selection if country has regions
        if country['code'] in REGIONS:
            self.region_layout.opacity = 1
            self.region_spinner.text = 'Select Region'
            self.selected_region = None
        else:
            self.region_layout.opacity = 0
            self.selected_region = None
            
        self.load_videos()
        
    def show_region_selection(self, button):
        if self.selected_country and self.selected_country['code'] in REGIONS:
            app = App.get_running_app()
            app.show_regions(self.selected_country['code'], self.on_region_selected)
        
    def on_region_selected(self, region):
        self.selected_region = region
        self.region_spinner.text = region['name']
        self.load_videos()
        
    def load_videos(self):
        # Clear current videos
        self.videos_grid.clear_widgets()
        
        # Show loading indicator
        loading_label = Label(
            text='Loading videos...',
            size_hint_y=None,
            height=100,
            color=COLORS['text']
        )
        self.videos_grid.add_widget(loading_label)
        
        # Fetch videos
        country_code = self.selected_country['code'] if self.selected_country else None
        region_code = self.selected_region['code'] if self.selected_region else None
        
        fetch_trending_videos(
            country_code=country_code,
            region_code=region_code,
            platform=self.selected_platform,
            callback=self.on_videos_loaded
        )
        
    def on_videos_loaded(self, videos):
        # Clear loading indicator
        self.videos_grid.clear_widgets()
        
        if not videos:
            no_videos_label = Label(
                text='No videos found. Try different filters.',
                size_hint_y=None,
                height=100,
                color=COLORS['text']
            )
            self.videos_grid.add_widget(no_videos_label)
            return
            
        # Add video cards
        for video in videos:
            card = VideoCard(video)
            self.videos_grid.add_widget(card)

class CountrySelectionScreen(Screen):
    def __init__(self, **kwargs):
        super(CountrySelectionScreen, self).__init__(**kwargs)
        self.callback = None
        
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Header
        header = BoxLayout(size_hint_y=None, height=50)
        back_btn = Button(
            text='Back',
            size_hint_x=None,
            width=80,
            background_normal='',
            background_color=COLORS['primary']
        )
        back_btn.bind(on_release=self.go_back)
        title = Label(text='Select Country', font_size=20, color=COLORS['text'])
        header.add_widget(back_btn)
        header.add_widget(title)
        
        # Countries list
        scroll = ScrollView()
        self.countries_grid = GridLayout(
            cols=1,
            spacing=5,
            size_hint_y=None,
            padding=[10, 10]
        )
        self.countries_grid.bind(minimum_height=self.countries_grid.setter('height'))
        scroll.add_widget(self.countries_grid)
        
        layout.add_widget(header)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
        
    def on_pre_enter(self):
        self.load_countries()
        
    def set_callback(self, callback):
        self.callback = callback
        
    def load_countries(self):
        self.countries_grid.clear_widgets()
        
        for country in COUNTRIES:
            btn = Button(
                text=country['name'],
                size_hint_y=None,
                height=60,
                background_normal='',
                background_color=COLORS['card'],
                color=COLORS['text']
            )
            btn.country = country
            btn.bind(on_release=self.on_country_select)
            self.countries_grid.add_widget(btn)
            
    def on_country_select(self, button):
        if self.callback:
            self.callback(button.country)
        self.go_back(None)
        
    def go_back(self, instance):
        app = App.get_running_app()
        app.screen_manager.transition.direction = 'right'
        app.screen_manager.current = 'home'

class RegionSelectionScreen(Screen):
    def __init__(self, **kwargs):
        super(RegionSelectionScreen, self).__init__(**kwargs)
        self.callback = None
        self.country_code = None
        
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Header
        header = BoxLayout(size_hint_y=None, height=50)
        back_btn = Button(
            text='Back',
            size_hint_x=None,
            width=80,
            background_normal='',
            background_color=COLORS['primary']
        )
        back_btn.bind(on_release=self.go_back)
        self.title_label = Label(text='Select Region', font_size=20, color=COLORS['text'])
        header.add_widget(back_btn)
        header.add_widget(self.title_label)
        
        # Regions list
        scroll = ScrollView()
        self.regions_grid = GridLayout(
            cols=1,
            spacing=5,
            size_hint_y=None,
            padding=[10, 10]
        )
        self.regions_grid.bind(minimum_height=self.regions_grid.setter('height'))
        scroll.add_widget(self.regions_grid)
        
        layout.add_widget(header)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
        
    def set_country(self, country_code, callback):
        self.country_code = country_code
        self.callback = callback
        
        # Update title
        country_name = next((c['name'] for c in COUNTRIES if c['code'] == country_code), 'Unknown')
        self.title_label.text = f'Regions in {country_name}'
        
    def on_pre_enter(self):
        self.load_regions()
        
    def load_regions(self):
        self.regions_grid.clear_widgets()
        
        if not self.country_code or self.country_code not in REGIONS:
            no_regions_label = Label(
                text='No regions available for this country',
                size_hint_y=None,
                height=100,
                color=COLORS['text']
            )
            self.regions_grid.add_widget(no_regions_label)
            return
            
        for region in REGIONS[self.country_code]:
            btn = Button(
                text=region['name'],
                size_hint_y=None,
                height=60,
                background_normal='',
                background_color=COLORS['card'],
                color=COLORS['text']
            )
            btn.region = region
            btn.bind(on_release=self.on_region_select)
            self.regions_grid.add_widget(btn)
            
    def on_region_select(self, button):
        if self.callback:
            self.callback(button.region)
        self.go_back(None)
        
    def go_back(self, instance):
        app = App.get_running_app()
        app.screen_manager.transition.direction = 'right'
        app.screen_manager.current = 'home'

class VideoDetailScreen(Screen):
    def __init__(self, **kwargs):
        super(VideoDetailScreen, self).__init__(**kwargs)
        self.video = None
        
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Header
        header = BoxLayout(size_hint_y=None, height=50)
        back_btn = Button(
            text='Back',
            size_hint_x=None,
            width=80,
            background_normal='',
            background_color=COLORS['primary']
        )
        back_btn.bind(on_release=self.go_back)
        self.title_label = Label(
            text='Video Details',
            font_size=20,
            color=COLORS['text'],
            shorten=True,
            shorten_from='right'
        )
        header.add_widget(back_btn)
        header.add_widget(self.title_label)
        
        # Video content
        content_scroll = ScrollView()
        self.content_layout = BoxLayout(
            orientation='vertical',
            spacing=15,
            size_hint_y=None,
            padding=[10, 10]
        )
        self.content_layout.bind(minimum_height=self.content_layout.setter('height'))
        
        # Thumbnail
        self.thumbnail = AsyncImage(
            allow_stretch=True,
            keep_ratio=True,
            size_hint_y=None,
            height=200
        )
        
        # Platform and stats
        self.platform_label = Label(
            size_hint_y=None,
            height=30,
            color=COLORS['primary'],
            halign='left'
        )
        
        self.stats_label = Label(
            size_hint_y=None,
            height=50,
            color=COLORS['text'],
            halign='left'
        )
        
        # Open button
        self.open_btn = Button(
            text='Open Video',
            size_hint_y=None,
            height=60,
            background_normal='',
            background_color=COLORS['secondary']
        )
        self.open_btn.bind(on_release=self.open_video_url)
        
        # Content analysis section
        self.analysis_title = Label(
            text='Content Analysis',
            font_size=18,
            size_hint_y=None,
            height=40,
            color=COLORS['text'],
            halign='left'
        )
        
        self.analysis_layout = BoxLayout(
            orientation='vertical',
            size_hint_y=None,
            height=150,
            spacing=10
        )
        
        # Add all elements
        self.content_layout.add_widget(self.thumbnail)
        self.content_layout.add_widget(self.platform_label)
        self.content_layout.add_widget(self.stats_label)
        self.content_layout.add_widget(self.open_btn)
        self.content_layout.add_widget(self.analysis_title)
        self.content_layout.add_widget(self.analysis_layout)
        
        content_scroll.add_widget(self.content_layout)
        
        layout.add_widget(header)
        layout.add_widget(content_scroll)
        
        self.add_widget(layout)
        
    def set_video(self, video):
        self.video = video
        self.title_label.text = video['title']
        self.thumbnail.source = video['thumbnail']
        self.platform_label.text = f"Platform: {video['platform'].upper()}"
        self.stats_label.text = f"{video['views']:,} views • {video['likes']:,} likes"
        
        # Clear previous analysis
        self.analysis_layout.clear_widgets()
        loading_label = Label(
            text='Loading analysis...',
            color=COLORS['text']
        )
        self.analysis_layout.add_widget(loading_label)
        
        # Fetch content analysis
        fetch_content_analysis(video['id'], self.on_analysis_loaded)
        
    def on_analysis_loaded(self, analysis):
        self.analysis_layout.clear_widgets()
        
        sentiment_layout = BoxLayout(size_hint_y=None, height=30)
        sentiment_label = Label(
            text='Sentiment:',
            size_hint_x=None,
            width=100,
            color=COLORS['text'],
            halign='left'
        )
        sentiment_value = Label(
            text=analysis['sentiment'].capitalize(),
            color=[0.2, 0.8, 0.2, 1] if analysis['sentiment'] == 'positive' else [0.8, 0.2, 0.2, 1],
            halign='left'
        )
        sentiment_layout.add_widget(sentiment_label)
        sentiment_layout.add_widget(sentiment_value)
        
        topics_layout = BoxLayout(size_hint_y=None, height=30)
        topics_label = Label(
            text='Topics:',
            size_hint_x=None,
            width=100,
            color=COLORS['text'],
            halign='left'
        )
        topics_value = Label(
            text=', '.join(topic.capitalize() for topic in analysis['topics']),
            color=COLORS['text'],
            halign='left'
        )
        topics_layout.add_widget(topics_label)
        topics_layout.add_widget(topics_value)
        
        score_layout = BoxLayout(size_hint_y=None, height=30)
        score_label = Label(
            text='Engagement:',
            size_hint_x=None,
            width=100,
            color=COLORS['text'],
            halign='left'
        )
        score_value = Label(
            text=f"{analysis['engagement_score']}/10",
            color=COLORS['primary'],
            halign='left'
        )
        score_layout.add_widget(score_label)
        score_layout.add_widget(score_value)
        
        self.analysis_layout.add_widget(sentiment_layout)
        self.analysis_layout.add_widget(topics_layout)
        self.analysis_layout.add_widget(score_layout)
        
    def open_video_url(self, instance):
        if self.video and 'url' in self.video:
            import webbrowser
            webbrowser.open(self.video['url'])
        
    def go_back(self, instance):
        app = App.get_running_app()
        app.screen_manager.transition.direction = 'right'
        app.screen_manager.current = 'home'

# Main App
class TrendingVideosApp(App):
    def build(self):
        # Set window size for desktop testing
        if platform != 'android' and platform != 'ios':
            Window.size = (400, 700)
            
        # Create screen manager
        self.screen_manager = ScreenManager()
        
        # Add screens
        self.home_screen = HomeScreen(name='home')
        self.country_screen = CountrySelectionScreen(name='countries')
        self.region_screen = RegionSelectionScreen(name='regions')
        self.video_detail_screen = VideoDetailScreen(name='video_detail')
        
        self.screen_manager.add_widget(self.home_screen)
        self.screen_manager.add_widget(self.country_screen)
        self.screen_manager.add_widget(self.region_screen)
        self.screen_manager.add_widget(self.video_detail_screen)
        
        return self.screen_manager
        
    def show_countries(self, callback):
        self.country_screen.set_callback(callback)
        self.screen_manager.transition.direction = 'left'
        self.screen_manager.current = 'countries'
        
    def show_regions(self, country_code, callback):
        self.region_screen.set_country(country_code, callback)
        self.screen_manager.transition.direction = 'left'
        self.screen_manager.current = 'regions'
        
    def open_video(self, video):
        self.video_detail_screen.set_video(video)
        self.screen_manager.transition.direction = 'left'
        self.screen_manager.current = 'video_detail'

if __name__ == '__main__':
    TrendingVideosApp().run()