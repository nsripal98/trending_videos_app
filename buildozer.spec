# Updated buildozer.spec for trending videos app

[app]
title = TrendingVideosApp
package.name = trending_videos
package.domain = com.example
source.dir = .
version = 1.0

requirements = python3,kivy,requests,beautifulsoup4,pytube

android.permissions = INTERNET, WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE

[buildozer]
default.android.ndk = 21
android.api = 33
android.minapi = 21
android.ndk = 21e
android.arch = arm64-v8a

# Fixed import issues and updated file paths
import os
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
import requests

class TrendingApp(App):
    def build(self):
        layout = BoxLayout()
        layout.add_widget(kivy.uix.label.Label(text="Trending Videos"))
        return layout

if __name__ == '__main__':
    TrendingApp().run()
