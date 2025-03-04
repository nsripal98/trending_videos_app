chip = MDChip(
                text=platform,
                icon="",
                callback=lambda x, p=platform: self.filter_by_platform(p)
            )
            platform_layout.add_widget(chip)
        
        platform_scroll.add_widget(platform_layout)
        
        # Tabs
        tabs_layout = MDBoxLayout(
            orientation='horizontal',
            size_hint_y=None,
            height=dp(48),
            spacing=dp(8),
            padding=[dp(8), 0]
        )
        
        trending_tab = MDRaisedButton(
            text="Top 10 Trending",
            on_release=lambda x: self.switch_tab('trending'),
            size_hint_x=0.5
        )
        
        content_tab = MDFlatButton(
            text="Top 3 Content",
            on_release=lambda x: self.switch_tab('content'),
            size_hint_x=0.5
        )
        
        tabs_layout.add_widget(trending_tab)
        tabs_layout.add_widget(content_tab)
        
        # Videos list
        scroll = ScrollView()
        self.videos_layout = MDList()
        self.update_videos_list()
        scroll.add_widget(self.videos_layout)
        
        # Add all sections to main layout
        layout.add_widget(toolbar)
        layout.add_widget(platform_scroll)
        layout.add_widget(tabs_layout)
        layout.add_widget(scroll)
        
        self.add_widget(layout)
    
    def filter_by_platform(self, platform):
        self.selected_platform = platform
        self.update_videos_list()
    
    def switch_tab(self, tab):
        self.active_tab = tab
        self.update_videos_list()
    
    def update_videos_list(self):
        self.videos_layout.clear_widgets()
        
        filtered_videos = self.videos
        
        # Filter by platform if selected
        if self.selected_platform:
            filtered_videos = [v for v in filtered_videos if v['platform'] == self.selected_platform]
        
        # Filter by region
        region_names = {
            'usa': {
                'ca': 'California',
                'ny': 'New York',
                'tx': 'Texas',
                'fl': 'Florida',
                'il': 'Illinois'
            },
            'ind': {
                'mh': 'Maharashtra',
                'dl': 'Delhi',
                'ka': 'Karnataka',
                'tn': 'Tamil Nadu',
                'tg': 'Telangana'
            },
            'gbr': {
                'ldn': 'London',
                'man': 'Manchester',
                'bham': 'Birmingham',
                'gla': 'Glasgow',
                'liv': 'Liverpool'
            }
        }
        region_name = region_names.get(self.country_code, {}).get(self.region_code, '')
        filtered_videos = [v for v in filtered_videos if region_name in v['trendingRegions']]
        
        if self.active_tab == 'trending':
            # Sort by views (most viewed first)
            filtered_videos = sorted(filtered_videos, key=lambda x: x['views'], reverse=True)
            
            # Take top 10
            filtered_videos = filtered_videos[:10]
            
            for i, video in enumerate(filtered_videos):
                card = MDCard(
                    orientation='vertical',
                    size_hint_y=None,
                    height=dp(320),
                    padding=dp(8),
                    spacing=dp(8),
                    radius=[dp(10)],
                    elevation=2,
                    ripple_behavior=True
                )
                
                # Rank badge
                rank_layout = MDBoxLayout(
                    size_hint=(None, None),
                    size=(dp(30), dp(30)),
                    md_bg_color=get_platform_color(video['platform']),
                    radius=[dp(15)],
                    pos_hint={'center_x': 0.05, 'center_y': 0.95}
                )
                
                rank_label = MDLabel(
                    text=f"#{i+1}",
                    halign='center',
                    theme_text_color="Custom",
                    text_color=[1, 1, 1, 1],
                    font_style="Body1"
                )
                
                rank_layout.add_widget(rank_label)
                
                # Thumbnail
                thumbnail_box = MDBoxLayout(
                    size_hint_y=None,
                    height=dp(180)
                )
                
                thumbnail = AsyncImage(
                    source=video['thumbnailUrl'],
                    allow_stretch=True,
                    keep_ratio=False
                )
                
                duration_box = MDBoxLayout(
                    size_hint=(None, None),
                    size=(dp(60), dp(25)),
                    md_bg_color=[0, 0, 0, 0.7],
                    radius=[dp(5)],
                    padding=[dp(5), dp(2)],
                    pos_hint={'center_x': 0.9, 'center_y': 0.1}
                )
                
                duration_label = MDLabel(
                    text=format_duration(video['duration']),
                    halign='center',
                    theme_text_color="Custom",
                    text_color=[1, 1, 1, 1],
                    font_style="Caption"
                )
                
                duration_box.add_widget(duration_label)
                
                thumbnail_box.add_widget(thumbnail)
                thumbnail_box.add_widget(duration_box)
                thumbnail_box.add_widget(rank_layout)
                
                # Title and platform
                title_box = MDBoxLayout(
                    orientation='vertical',
                    size_hint_y=None,
                    height=dp(60),
                    padding=[0, dp(4)]
                )
                
                title = MDLabel(
                    text=video['title'],
                    font_style="Subtitle1",
                    size_hint_y=None,
                    height=dp(40)
                )
                
                platform_box = MDBoxLayout(
                    orientation='horizontal',
                    size_hint_y=None,
                    height=dp(20)
                )
                
                platform_badge = MDLabel(
                    text=video['platform'],
                    theme_text_color="Custom",
                    text_color=get_platform_color(video['platform']),
                    font_style="Caption",
                    bold=True
                )
                
                platform_box.add_widget(platform_badge)
                
                title_box.add_widget(title)
                title_box.add_widget(platform_box)
                
                # Stats
                stats_box = MDBoxLayout(
                    orientation='horizontal',
                    size_hint_y=None,
                    height=dp(30)
                )
                
                views = MDLabel(
                    text=f"{format_number(video['views'])} views",
                    font_style="Caption",
                    size_hint_x=0.33
                )
                
                likes = MDLabel(
                    text=f"{format_number(video['likes'])} likes",
                    font_style="Caption",
                    size_hint_x=0.33
                )
                
                comments = MDLabel(
                    text=f"{format_number(video['comments'])} comments",
                    font_style="Caption",
                    size_hint_x=0.33
                )
                
                stats_box.add_widget(views)
                stats_box.add_widget(likes)
                stats_box.add_widget(comments)
                
                # Watch button
                button_box = MDBoxLayout(
                    size_hint_y=None,
                    height=dp(40),
                    padding=[0, dp(5)]
                )
                
                watch_button = MDRaisedButton(
                    text=f"Watch on {video['platform']}",
                    on_release=lambda x, v=video: self.open_video(v),
                    size_hint_x=1
                )
                
                button_box.add_widget(watch_button)
                
                # Add all sections to card
                card.add_widget(thumbnail_box)
                card.add_widget(title_box)
                card.add_widget(stats_box)
                card.add_widget(button_box)
                
                # Add card to list
                item = OneLineAvatarListItem(
                    text="",
                    divider=None,
                    _no_ripple_effect=True
                )
                item.add_widget(card)
                
                # Add tap event to show video details
                card.bind(on_release=lambda x, v=video: self.show_video_details(v))
                
                self.videos_layout.add_widget(item)
        else:  # Content analysis tab
            # Sort by engagement rate (using a random value for demo)
            filtered_videos = sorted(filtered_videos, key=lambda x: float(x['contentAnalysis']['Engagement Rate'].replace('%', '')), reverse=True)
            
            # Take top 3
            filtered_videos = filtered_videos[:3]
            
            for i, video in enumerate(filtered_videos):
                card = MDCard(
                    orientation='vertical',
                    size_hint_y=None,
                    height=dp(400),
                    padding=dp(8),
                    spacing=dp(8),
                    radius=[dp(10)],
                    elevation=2,
                    ripple_behavior=True
                )
                
                # Rank badge
                rank_layout = MDBoxLayout(
                    size_hint=(None, None),
                    size=(dp(30), dp(30)),
                    md_bg_color=get_platform_color(video['platform']),
                    radius=[dp(15)],
                    pos_hint={'center_x': 0.05, 'center_y': 0.95}
                )
                
                rank_label = MDLabel(
                    text=f"#{i+1}",
                    halign='center',
                    theme_text_color="Custom",
                    text_color=[1, 1, 1, 1],
                    font_style="Body1"
                )
                
                rank_layout.add_widget(rank_label)
                
                # Thumbnail
                thumbnail_box = MDBoxLayout(
                    size_hint_y=None,
                    height=dp(180)
                )
                
                thumbnail = AsyncImage(
                    source=video['thumbnailUrl'],
                    allow_stretch=True,
                    keep_ratio=False
                )
                
                thumbnail_box.add_widget(thumbnail)
                thumbnail_box.add_widget(rank_layout)
                
                # Title and platform
                title_box = MDBoxLayout(
                    orientation='vertical',
                    size_hint_y=None,
                    height=dp(60),
                    padding=[0, dp(4)]
                )
                
                title = MDLabel(
                    text=video['title'],
                    font_style="Subtitle1",
                    size_hint_y=None,
                    height=dp(40)
                )
                
                platform_box = MDBoxLayout(
                    orientation='horizontal',
                    size_hint_y=None,
                    height=dp(20)
                )
                
                platform_badge = MDLabel(
                    text=video['platform'],
                    theme_text_color="Custom",
                    text_color=get_platform_color(video['platform']),
                    font_style="Caption",
                    bold=True
                )
                
                platform_box.add_widget(platform_badge)
                
                title_box.add_widget(title)
                title_box.add_widget(platform_box)
                
                # Content Analysis
                analysis_label = MDLabel(
                    text="Content Analysis",
                    font_style="H6",
                    size_hint_y=None,
                    height=dp(40)
                )
                
                analysis_box = MDBoxLayout(
                    orientation='vertical',
                    size_hint_y=None,
                    height=dp(120),
                    md_bg_color=[0.95, 0.95, 0.95, 1],
                    padding=dp(10),
                    radius=[dp(5)]
                )
                
                for key, value in video['contentAnalysis'].items():
                    item_box = MDBoxLayout(
                        orientation='horizontal',
                        size_hint_y=None,
                        height=dp(25)
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
                
                # Add all sections to card
                card.add_widget(thumbnail_box)
                card.add_widget(title_box)
                card.add_widget(analysis_label)
                card.add_widget(analysis_box)
                
                # Add card to list
                item = OneLineAvatarListItem(
                    text="",
                    divider=None,
                    _no_ripple_effect=True
                )
                item.add_widget(card)
                
                # Add tap event to show video details
                card.bind(on_release=lambda x, v=video: self.show_video_details(v))
                
                self.videos_layout.add_widget(item)
    
    def open_video(self, video):
        webbrowser.open(video['url'])
    
    def show_video_details(self, video):
        app = MDApp.get_running_app()
        app.show_video_details(video)
    
    def go_back(self, instance):
        app = MDApp.get_running_app()
        app.root.transition.direction = 'right'
        app.root.current = app.previous_screen

class VideoDetailScreen(Screen):
    def __init__(self, video, **kwargs):
        super(VideoDetailScreen, self).__init__(**kwargs)
        self.name = f"video_{video['id']}"
        self.video = video
        
        # Main layout
        layout = MDBoxLayout(orientation='vertical')
        
        # Toolbar
        header = MDTopAppBar(
            title="Video Details",
            elevation=10,
            pos_hint={"top": 1},
            left_action_items=[["arrow-left", self.go_back]]
        )
        
        # Content
        scroll = ScrollView()
        content = MDBoxLayout(
            orientation='vertical',
            size_hint_y=None,
            padding=dp(16),
            spacing=dp(16)
        )
        content.bind(minimum_height=content.setter('height'))
        
        # Thumbnail
        thumbnail_box = MDBoxLayout(
            size_hint_y=None,
            height=dp(200),
            radius=[dp(10)],
            elevation=2
        )
        
        thumbnail = AsyncImage(
            source=video["thumbnailUrl"],
            allow_stretch=True,
            keep_ratio=False
        )
        
        thumbnail_box.add_widget(thumbnail)
        
        # Details
        details_box = MDBoxLayout(
            orientation='vertical',
            size_hint_y=None,
            spacing=dp(16)
        )
        details_box.bind(minimum_height=details_box.setter('height'))
        
        # Title and platform
        title_box = MDBoxLayout(
            orientation='vertical',
            size_hint_y=None,
            height=dp(80)
        )
        
        video_title = MDLabel(
            text=video["title"],
            font_style="H5",
            size_hint_y=None,
            height=dp(60)
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