import requests
import os

class FacebookService:
    def __init__(self):
        self.access_token = os.getenv('FACEBOOK_ACCESS_TOKEN')
        self.api_base_url = 'https://graph.facebook.com/v12.0'

    def get_trending_videos(self, region_code='US', max_results=10):
        try:
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            # Get trending videos from Facebook Graph API
            params = {
                'fields': 'id,title,description,thumbnail,video_insights',
                'type': 'video',
                'trending_now': 'true',
                'country': region_code,
                'limit': max_results
            }
            
            response = requests.get(
                f"{self.api_base_url}/trending",
                headers=headers,
                params=params
            )
            
            if response.status_code == 200:
                data = response.json().get('data', [])
                videos = []
                
                for item in data:
                    video = {
                        'id': item['id'],
                        'title': item.get('title', ''),
                        'thumbnail': item.get('thumbnail', {}).get('url', ''),
                        'views': item.get('video_insights', {}).get('total_video_views', 0),
                        'platform': 'facebook',
                        'description': item.get('description', '')
                    }
                    videos.append(video)
                
                return videos
            return []
            
        except Exception as e:
            print(f"Error fetching Facebook trending videos: {e}")
            return []

    def get_trending_by_state(self, state_code, max_results=10):
        try:
            # Use Facebook's location targeting for the specific state
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            # Get state-specific location ID
            location_response = requests.get(
                f"{self.api_base_url}/search",
                headers=headers,
                params={
                    'q': state_code,
                    'type': 'adgeolocation',
                    'location_types': ['state']
                }
            )
            
            if location_response.status_code == 200:
                locations = location_response.json().get('data', [])
                if locations:
                    state_id = locations[0]['key']
                    
                    # Get trending videos for this location
                    params = {
                        'fields': 'id,title,description,thumbnail,video_insights',
                        'type': 'video',
                        'trending_now': 'true',
                        'geo_locations': [state_id],
                        'limit': max_results
                    }
                    
                    response = requests.get(
                        f"{self.api_base_url}/trending",
                        headers=headers,
                        params=params
                    )
                    
                    if response.status_code == 200:
                        data = response.json().get('data', [])
                        videos = []
                        
                        for item in data:
                            video = {
                                'id': item['id'],
                                'title': item.get('title', ''),
                                'thumbnail': item.get('thumbnail', {}).get('url', ''),
                                'views': item.get('video_insights', {}).get('total_video_views', 0),
                                'platform': 'facebook',
                                'description': item.get('description', '')
                            }
                            videos.append(video)
                        
                        return videos
            return []
            
        except Exception as e:
            print(f"Error fetching state-specific videos: {e}")
            return []

    def analyze_content(self, video_id):
        try:
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            # Get video details including engagement metrics
            response = requests.get(
                f"{self.api_base_url}/{video_id}",
                headers=headers,
                params={
                    'fields': 'title,description,tags,category,video_insights'
                }
            )
            
            if response.status_code == 200:
                data = response.json()
                return {
                    'title': data.get('title', ''),
                    'description': data.get('description', ''),
                    'tags': data.get('tags', []),
                    'category': data.get('category', ''),
                    'insights': data.get('video_insights', {})
                }
            return None
            
        except Exception as e:
            print(f"Error analyzing video content: {e}")
            return None