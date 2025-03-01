export interface Video {
  id: string;
  title: string;
  description: string;
  thumbnailUrl: string;
  url: string;
  platform: string;
  views: number;
  likes: number;
  comments: number;
  publishedAt: string;
  duration: number;
  category: string;
  creatorName: string;
  creatorAvatarUrl: string;
  creatorFollowers: number;
  trendingRegions: string[];
  contentAnalysis?: {
    [key: string]: string;
  };
}