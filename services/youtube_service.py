import os
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

class YouTubeService:
    def __init__(self):
        self.api_key = os.getenv('YOUTUBE_API_KEY')
        self.youtube = build('youtube', 'v3', developerKey=self.api_key)

    def get_trending_videos(self, region_code='US', max_results=10):
        try:
            request = self.youtube.videos().list(
                part="snippet,statistics,contentDetails",
                chart="mostPopular",
                regionCode=region_code,
                maxResults=max_results
            )
            response = request.execute()
            
            videos = []
            for item in response['items']:
                video = {
                    'id': item['id'],
                    'title': item['snippet']['title'],
                    'thumbnail': item['snippet']['thumbnails']['high']['url'],
                    'views': item['statistics']['viewCount'],
                    'platform': 'youtube',
                    'description': item['snippet']['description'],
                    'duration': item['contentDetails']['duration']
                }
                videos.append(video)
            
            return videos
        except Exception as e:
            print(f"Error fetching YouTube trending videos: {e}")
            return []

    def get_trending_by_state(self, state_code, max_results=10):
        # Note: YouTube API doesn't support state-level trending
        # This would require additional data processing or a custom solution
        # For now, we'll use geolocation data from video metadata
        try:
            videos = self.get_trending_videos(region_code='US', max_results=50)
            # Filter videos based on state location mentions
            state_videos = [
                video for video in videos 
                if state_code.lower() in video['description'].lower()
            ]
            return state_videos[:max_results]
        except Exception as e:
            print(f"Error fetching state-specific videos: {e}")
            return []

    def analyze_content(self, video_id):
        try:
            request = self.youtube.videos().list(
                part="snippet,statistics,topicDetails",
                id=video_id
            )
            response = request.execute()
            
            if response['items']:
                video = response['items'][0]
                return {
                    'topics': video.get('topicDetails', {}).get('topicCategories', []),
                    'tags': video['snippet'].get('tags', []),
                    'category_id': video['snippet']['categoryId']
                }
            return None
        except Exception as e:
            print(f"Error analyzing video content: {e}")
            return None