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
                part="snippet,statistics",
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
                    'platform': 'youtube'
                }
                videos.append(video)
            
            return videos
        except Exception as e:
            print(f"Error fetching YouTube trending videos: {e}")
            return []

    def get_trending_by_state(self, state_code, max_results=10):
        # Note: YouTube API doesn't support state-level trending
        # This would require additional data processing
        return self.get_trending_videos(region_code='US', max_results=max_results)