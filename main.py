layout.add_widget(scroll)
        layout.add_widget(footer)
        
        self.add_widget(layout)

class CountryScreen(Screen):
    def __init__(self, country_code, **kwargs):
        super(CountryScreen, self).__init__(**kwargs)
        self.name = f"country_{country_code}"
        self.country_code = country_code
        
        # Get country name
        country_name = next((c["name"] for c in COUNTRIES if c["code"] == country_code), "Unknown")
        
        layout = MDBoxLayout(orientation="vertical")
        
        # Header with back button
        header = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60),
            padding=[dp(10), dp(10)],
            md_bg_color=[1, 1, 1, 1]
        )
        
        back_button = MDFlatButton(
            text="Back",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1],
            on_release=self.go_back
        )
        
        title = MDLabel(
            text=country_name,
            font_style="H5",
            halign="center"
        )
        
        header.add_widget(back_button)
        header.add_widget(title)
        
        # Platform filter
        platforms = ["All", "YouTube", "Instagram", "Facebook", "Twitter", "TikTok"]
        platform_filter = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60),
            padding=[dp(10), dp(10)],
            md_bg_color=[1, 1, 1, 1]
        )
        
        for platform in platforms:
            btn = MDFlatButton(
                text=platform,
                theme_text_color="Custom",
                text_color=[0, 0, 0, 1] if platform == "All" else [0.5, 0.5, 0.5, 1]
            )
            platform_filter.add_widget(btn)
        
        # Tabs for trending vs content analysis
        tabs = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(50),
            md_bg_color=[1, 1, 1, 1]
        )
        
        trending_tab = MDFlatButton(
            text="Top 10 Trending",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1],
            line_color=[0, 0.48, 1, 1],
            line_width=2
        )
        
        content_tab = MDFlatButton(
            text="Top 3 Content",
            theme_text_color="Custom",
            text_color=[0.5, 0.5, 0.5, 1]
        )
        
        tabs.add_widget(trending_tab)
        tabs.add_widget(content_tab)
        
        # Videos list
        scroll = ScrollView()
        videos_list = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            padding=[dp(10), dp(10)],
            spacing=dp(10)
        )
        videos_list.bind(minimum_height=videos_list.setter('height'))
        
        # Add video cards
        for video in TRENDING_VIDEOS:
            card = VideoCard(video)
            videos_list.add_widget(card)
        
        scroll.add_widget(videos_list)
        
        # Add all sections to main layout
        layout.add_widget(header)
        layout.add_widget(platform_filter)
        layout.add_widget(tabs)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
    
    def go_back(self, instance):
        app = MDApp.get_running_app()
        app.root.transition.direction = 'right'
        app.root.current = "countries"

class RegionScreen(Screen):
    def __init__(self, country_code, region_code, **kwargs):
        super(RegionScreen, self).__init__(**kwargs)
        self.name = f"region_{country_code}_{region_code}"
        self.country_code = country_code
        self.region_code = region_code
        
        # Get country and region names
        country_name = next((c["name"] for c in COUNTRIES if c["code"] == country_code), "Unknown")
        
        regions = []
        if country_code == "usa":
            regions = USA_REGIONS
        elif country_code == "ind":
            regions = INDIA_REGIONS
        elif country_code == "gbr":
            regions = UK_REGIONS
            
        region_name = next((r["name"] for r in regions if r["code"] == region_code), "Unknown")
        
        layout = MDBoxLayout(orientation="vertical")
        
        # Header with back button
        header = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60),
            padding=[dp(10), dp(10)],
            md_bg_color=[1, 1, 1, 1]
        )
        
        back_button = MDFlatButton(
            text="Back",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1],
            on_release=self.go_back
        )
        
        title = MDLabel(
            text=f"{region_name}, {country_name}",
            font_style="H5",
            halign="center"
        )
        
        header.add_widget(back_button)
        header.add_widget(title)
        
        # Platform filter
        platforms = ["All", "YouTube", "Instagram", "Facebook", "Twitter", "TikTok"]
        platform_filter = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60),
            padding=[dp(10), dp(10)],
            md_bg_color=[1, 1, 1, 1]
        )
        
        for platform in platforms:
            btn = MDFlatButton(
                text=platform,
                theme_text_color="Custom",
                text_color=[0, 0, 0, 1] if platform == "All" else [0.5, 0.5, 0.5, 1]
            )
            platform_filter.add_widget(btn)
        
        # Tabs for trending vs content analysis
        tabs = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(50),
            md_bg_color=[1, 1, 1, 1]
        )
        
        trending_tab = MDFlatButton(
            text="Top 10 Trending",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1],
            line_color=[0, 0.48, 1, 1],
            line_width=2
        )
        
        content_tab = MDFlatButton(
            text="Top 3 Content",
            theme_text_color="Custom",
            text_color=[0.5, 0.5, 0.5, 1]
        )
        
        tabs.add_widget(trending_tab)
        tabs.add_widget(content_tab)
        
        # Videos list
        scroll = ScrollView()
        videos_list = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            padding=[dp(10), dp(10)],
            spacing=dp(10)
        )
        videos_list.bind(minimum_height=videos_list.setter('height'))
        
        # Add video cards - filter by region
        for video in TRENDING_VIDEOS:
            if any(region_name in region for region in video["trendingRegions"]):
                card = VideoCard(video)
                videos_list.add_widget(card)
        
        scroll.add_widget(videos_list)
        
        # Add all sections to main layout
        layout.add_widget(header)
        layout.add_widget(platform_filter)
        layout.add_widget(tabs)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
    
    def go_back(self, instance):
        app = MDApp.get_running_app()
        app.root.transition.direction = 'right'
        app.root.current = "regions"

class VideoDetailScreen(Screen):
    def __init__(self, video, **kwargs):
        super(VideoDetailScreen, self).__init__(**kwargs)
        self.name = f"video_{video['id']}"
        self.video = video
        
        layout = MDBoxLayout(orientation="vertical")
        
        # Header with back button
        header = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60),
            padding=[dp(10), dp(10)],
            md_bg_color=[1, 1, 1, 1]
        )
        
        back_button = MDFlatButton(
            text="Back",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1],
            on_release=self.go_back
        )
        
        title = MDLabel(
            text="Video Details",
            font_style="H5",
            halign="center"
        )
        
        share_button = MDFlatButton(
            text="Share",
            theme_text_color="Custom",
            text_color=[0, 0.48, 1, 1]
        )
        
        header.add_widget(back_button)
        header.add_widget(title)
        header.add_widget(share_button)
        
        # Scroll content
        scroll = ScrollView()
        content = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            spacing=dp(10)
        )
        content.bind(minimum_height=content.setter('height'))
        
        # Thumbnail
        thumbnail_box = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            height=dp(220)
        )
        
        thumbnail = AsyncImage(
            source=video["thumbnailUrl"],
            allow_stretch=True,
            keep_ratio=False
        )
        
        watch_button = MDRaisedButton(
            text=f"Watch on {video['platform']}",
            pos_hint={"right": 0.95, "center_y": 0.1},
            on_release=self.open_video
        )
        
        thumbnail_box.add_widget(thumbnail)
        thumbnail_box.add_widget(watch_button)
        
        # Video details
        details_box = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            padding=[dp(16), dp(16)],
            spacing=dp(10),
            md_bg_color=[1, 1, 1, 1]
        )
        details_box.bind(minimum_height=details_box.setter('height'))
        
        # Title and platform
        title_box = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            height=dp(80)
        )
        
        video_title = MDLabel(
            text=video["title"],
            font_style="H6"
        )
        
        platform_color = get_platform_color(video["platform"])
        platform_badge = MDLabel(
            text=video["platform"],
            size_hint=(None, None),
            size=(dp(100), dp(30)),
            halign="center",
            valign="middle",
            md_bg_color=platform_color,
            theme_text_color="Custom",
            text_color=[1, 1, 1, 1],
            radius=[dp(5)]
        )
        
        title_box.add_widget(video_title)
        title_box.add_widget(platform_badge)
        
        # Stats
        stats_box = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(40)
        )
        
        views = MDLabel(
            text=f"{format_number(video['views'])} views",
            font_style="Body2",
            size_hint_x=0.33
        )
        
        likes = MDLabel(
            text=f"{format_number(video['likes'])} likes",
            font_style="Body2",
            size_hint_x=0.33
        )
        
        comments = MDLabel(
            text=f"{format_number(video['comments'])} comments",
            font_style="Body2",
            size_hint_x=0.33
        )
        
        stats_box.add_widget(views)
        stats_box.add_widget(likes)
        stats_box.add_widget(comments)
        
        # Divider
        divider1 = MDBoxLayout(
            size_hint_y=None,
            height=dp(1),
            md_bg_color=[0.9, 0.9, 0.9, 1]
        )
        
        # Creator info
        creator_box = MDBoxLayout(
            orientation="horizontal",
            size_hint_y=None,
            height=dp(60)
        )
        
        creator_avatar = AsyncImage(
            source=video["creatorAvatarUrl"],
            size_hint=(None, None),
            size=(dp(48), dp(48))
        )
        
        creator_info = MDBoxLayout(
            orientation="vertical",
            padding=[dp(10), 0, 0, 0]
        )
        
        creator_name = MDLabel(
            text=video["creatorName"],
            font_style="Subtitle1"
        )
        
        creator_followers = MDLabel(
            text=f"{format_number(video['creatorFollowers'])} followers",
            font_style="Caption",
            theme_text_color="Secondary"
        )
        
        creator_info.add_widget(creator_name)
        creator_info.add_widget(creator_followers)
        
        creator_box.add_widget(creator_avatar)
        creator_box.add_widget(creator_info)
        
        # Divider
        divider2 = MDBoxLayout(
            size_hint_y=None,
            height=dp(1),
            md_bg_color=[0.9, 0.9, 0.9, 1]
        )
        
        # Description
        description_label = MDLabel(
            text="Description",
            font_style="H6",
            size_hint_y=None,
            height=dp(40)
        )
        
        description = MDLabel(
            text=video["description"],
            font_style="Body1",
            size_hint_y=None,
            height=dp(100)
        )
        
        # Content Analysis
        if "contentAnalysis" in video and video["contentAnalysis"]:
            analysis_label = MDLabel(
                text="Content Analysis",
                font_style="H6",
                size_hint_y=None,
                height=dp(40)
            )
            
            analysis_box = MDBoxLayout(
                orientation="vertical",
                size_hint_y=None,
                md_bg_color=[0.95, 0.95, 0.95, 1],
                padding=dp(10),
                radius=[dp(5)]
            )
            analysis_box.bind(minimum_height=analysis_box.setter('height'))
            
            for key, value in video["contentAnalysis"].items():
                item_box = MDBoxLayout(
                    orientation="horizontal",
                    size_hint_y=None,
                    height=dp(30)
                )
                
                key_label = MDLabel(
                    text=f"{key}:",
                    font_style="Body2",
                    bold=True,
                    size_hint_x=0.4
                )
                
                value_label = MDLabel(
                    text=value,
                    font_style="Body2",
                    size_hint_x=0.6
                )
                
                item_box.add_widget(key_label)
                item_box.add_widget(value_label)
                analysis_box.add_widget(item_box)
        
        # Trending regions
        regions_label = MDLabel(
            text="Trending In",
            font_style="H6",
            size_hint_y=None,
            height=dp(40)
        )
        
        regions_box = MDBoxLayout(
            orientation="vertical",
            size_hint_y=None,
            height=dp(60),
            md_bg_color=[0.95, 0.95, 0.95, 1],
            padding=dp(10),
            radius=[dp(5)]
        )
        
        regions_text = MDLabel(
            text=", ".join(video["trendingRegions"]),
            font_style="Body1"
        )
        
        regions_box.add_widget(regions_text)
        
        # Watch button
        watch_full_button = MDRaisedButton(
            text=f"Watch on {video['platform']}",
            size_hint_x=1,
            height=dp(50),
            on_release=self.open_video
        )
        
        # Add all widgets to details box
        details_box.add_widget(title_box)
        details_box.add_widget(stats_box)
        details_box.add_widget(divider1)
        details_box.add_widget(creator_box)
        details_box.add_widget(divider2)
        details_box.add_widget(description_label)
        details_box.add_widget(description)
        
        if "contentAnalysis" in video and video["contentAnalysis"]:
            details_box.add_widget(analysis_label)
            details_box.add_widget(analysis_box)
        
        details_box.add_widget(regions_label)
        details_box.add_widget(regions_box)
        details_box.add_widget(MDBoxLayout(size_hint_y=None, height=dp(20)))
        details_box.add_widget(watch_full_button)
        
        # Add all sections to content
        content.add_widget(thumbnail_box)
        content.add_widget(details_box)
        
        scroll.add_widget(content)
        
        # Add all sections to main layout
        layout.add_widget(header)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
    
    def go_back(self, instance):
        app = MDApp.get_running_app()
        app.root.transition.direction = 'right'
        app.root.current = app.previous_screen
    
    def open_video(self, instance):
        import webbrowser
        webbrowser.open(self.video["url"])

class TrendingVideosApp(MDApp):
    def __init__(self, **kwargs):
        super(TrendingVideosApp, self).__init__(**kwargs)
        self.title = "Trending Videos"
        self.previous_screen = "home"
    
    def build(self):
        self.theme_cls.primary_palette = "Blue"
        
        # Create screen manager
        sm = ScreenManager()
        
        # Add screens
        sm.add_widget(HomeScreen())
        sm.add_widget(CountriesScreen())
        sm.add_widget(RegionsScreen())
        sm.add_widget(SettingsScreen())
        
        return sm
    
    def show_country_videos(self, country_code):
        self.previous_screen = self.root.current
        country_screen = CountryScreen(country_code)
        self.root.add_widget(country_screen)
        self.root.transition.direction = 'left'
        self.root.current = country_screen.name
    
    def show_region_videos(self, country_code, region_code):
        self.previous_screen = self.root.current
        region_screen = RegionScreen(country_code, region_code)
        self.root.add_widget(region_screen)
        self.root.transition.direction = 'left'
        self.root.current = region_screen.name
    
    def show_video_details(self, video):
        self.previous_screen = self.root.current
        video_screen = VideoDetailScreen(video)
        self.root.add_widget(video_screen)
        self.root.transition.direction = 'left'
        self.root.current = video_screen.name

if __name__ == '__main__':
    TrendingVideosApp().run()