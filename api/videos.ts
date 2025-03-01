import { Video } from '@/types/video';

// Mock data for trending videos
const mockVideos: Video[] = [
  {
    id: 'yt-001',
    title: 'How to Make the Perfect Chocolate Chip Cookies',
    description: 'Learn the secrets to making the perfect chocolate chip cookies with this step-by-step tutorial. These cookies are crispy on the outside, chewy on the inside, and absolutely delicious!',
    thumbnailUrl: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?q=80&w=400&auto=format&fit=crop',
    url: 'https://www.youtube.com/watch?v=example1',
    platform: 'YouTube',
    views: 2500000,
    likes: 125000,
    comments: 8500,
    publishedAt: '2023-05-15T14:30:00Z',
    duration: 485,
    category: 'Food & Cooking',
    creatorName: 'Baking Brilliance',
    creatorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
    creatorFollowers: 1200000,
    trendingRegions: ['United States', 'California', 'New York', 'Texas'],
    contentAnalysis: {
      'Engagement Rate': '5.2%',
      'Audience Retention': '76%',
      'Key Topics': 'Baking, Desserts, Chocolate',
      'Sentiment': 'Overwhelmingly Positive'
    }
  },
  {
    id: 'ig-001',
    title: 'Morning Yoga Routine for Beginners',
    description: 'Start your day right with this 10-minute morning yoga routine perfect for beginners. Improve flexibility, reduce stress, and boost your energy levels!',
    thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=400&auto=format&fit=crop',
    url: 'https://www.instagram.com/p/example1',
    platform: 'Instagram',
    views: 1800000,
    likes: 320000,
    comments: 12000,
    publishedAt: '2023-06-02T08:15:00Z',
    duration: 600,
    category: 'Fitness & Health',
    creatorName: 'Yoga With Sarah',
    creatorAvatarUrl: 'https://images.unsplash.com/photo-1 <boltArtifact id="trending-videos-app-continued" title="Trending Videos App (Continued)">
  }
]