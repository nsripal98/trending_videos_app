import { Instagram, Youtube, Facebook, Twitter, Video } from 'lucide-react-native';

export function getPlatformIcon(platform: string) {
  switch (platform.toLowerCase()) {
    case 'instagram':
      return Instagram;
    case 'youtube':
      return Youtube;
    case 'facebook':
      return Facebook;
    case 'twitter':
    case 'x':
      return Twitter;
    default:
      return Video;
  }
}

export function getPlatformColor(platform: string): string {
  switch (platform.toLowerCase()) {
    case 'instagram':
      return '#E1306C';
    case 'youtube':
      return '#FF0000';
    case 'facebook':
      return '#1877F2';
    case 'twitter':
    case 'x':
      return '#1DA1F2';
    case 'tiktok':
      return '#000000';
    default:
      return '#007AFF';
  }
}