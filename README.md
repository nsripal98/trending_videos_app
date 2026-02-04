# Trending Videos App

A cross-platform mobile application that aggregates trending videos from various social media platforms.

## Features are below

1. **Country-wide Trending Videos**
   - Shows top 10 most viewed videos from each platform at the country level
   - Currently supports USA, India, and UK
   - Videos are sorted by view count and can be filtered by platform

2. **State/Region-wise Trending**
   - Displays top 10 videos for each state/region within countries
   - Implemented for all US states, Indian states, and UK regions
   - Accessible through the Regions tab

3. **Content Analysis**
   - Shows top 3 videos based on content analysis for each country and region
   - Includes engagement metrics, audience retention, key topics, and sentiment analysis
   - Available through a tab interface on country and region screens

## Supported Platforms

- YouTube
- Instagram
- Facebook
- Twitter
- TikTok

## Building the APK

This app uses Buildozer to create an Android APK. To build the APK:

1. Install Buildozer and its dependencies:
   ```
   pip install buildozer
   ```

2. For Ubuntu/Debian, install required packages:
   ```
   sudo apt-get install -y python3-pip build-essential git python3 python3-dev ffmpeg libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libportmidi-dev libswscale-dev libavformat-dev libavcodec-dev zlib1g-dev
   ```

3. Build the APK:
   ```
   buildozer android debug
   ```

4. The APK will be generated in the `bin/` directory.

## Requirements

- Python 3.7+
- Kivy 2.2.1
- KivyMD 1.1.1

## License

MIT