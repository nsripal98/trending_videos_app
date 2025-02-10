import requests
import os
from bs4 import BeautifulSoup

class InstagramService:
    def __init__(self):
        self.access_token = os.getenv('INSTAGRAM_ACCESS_TOKEN')
        self.api_base_url = 'https://graph.instagram.com/v12.0'

    def get_trending_videos(self, region_code='US', max_results=10):
        try:
            # Note: Instagram Graph API doesn't provide trending videos directly
            # We'll need to use hashtag search and engagement metrics
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            # Get trending hashtags for the region
            trending_hashtags = self._get_trending_hashtags(region_code)
            
            videos = []
            for hashtag in trending_hashtags:
                # Search for recent media with this hashtag
                response = requests.get(
                    f"{self.api_base_url}/tags/{hashtag}/media/recent",
                    headers=headers
                )
                
                if response.status_code == 200:
                    media_items = response.json().get('data', [])
                    for item in media_items:
                        if item['media_type'] == 'VIDEO':
                            video = {
                                'id': item['id'],
                                'title': item.get('caption', '')[:100],
                                'thumbnail': item['thumbnail_url'],
                                'views': item.get('video_view_count', 0),
                                'platform': 'instagram',
                                'likes': item.get('like_count', 0),
                                'comments': item.get('comments_count', 0)
                            }
                            videos.append(video)
                            
                            if len(videos) >= max_results:
                                break
                
                if len(videos) >= max_results:
                    break
            
            # Sort by views
            videos.sort(key=lambda x: x['views'], reverse=True)
            return videos[:max_results]
            
        except Exception as e:
            print(f"Error fetching Instagram trending videos: {e}")
            return []

    def get_trending_by_state(self, state_code, max_results=10):
        try:
            # Use location-based hashtags for the state
            state_hashtags = [f"#{state_code}", f"#{state_code}life", f"#{state_code}living"]
            videos = []
            
            for hashtag in state_hashtags:
                hashtag_videos = self._get_videos_by_hashtag(hashtag, max_results)
                videos.extend(hashtag_videos)
            
            # Sort by engagement (views + likes + comments)
            videos.sort(key=lambda x: x['views'] + x.get('likes', 0) + x.get('comments', 0), reverse=True)
            return videos[:max_results]
            
        except Exception as e:
            print(f"Error fetching state-specific videos: {e}")
            return []

    def _get_trending_hashtags(self, region_code):
        # This would typically involve scraping or using a third-party service
        # For now, return some generic trending hashtags
        return ['trending', 'viral', 'popular', region_code.lower()]

    def _get_videos_by_hashtag(self, hashtag, limit):
        try:
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            response = requests.get(
                f"{self.api_base_url}/tags/{hashtag}/media/recent",
                headers=headers
            )
            
            if response.status_code == 200:
                media_items = response.json().get('data', [])
                videos = []
                
                for item in media_items:
                    if item['media_type'] == 'VIDEO':
                        video = {
                            'id': item['id'],
                            'title': item.get('caption', '')[:100],
                            'thumbnail': item['thumbnail_url'],
                            'views': item.get('video_view_count', 0),
                            'platform': 'instagram',
                            'likes': item.get('like_count', 0),
                            'comments': item.get('comments_count', 0)
                        }
                        videos.append(video)
                        
                        if len(videos) >= limit:
                            break
                
                return videos
            return []
            
        except Exception as e:
            print(f"Error fetching hashtag videos: {e}")
            return []