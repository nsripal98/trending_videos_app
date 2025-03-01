import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { ThumbsUp, MessageCircle, Eye } from 'lucide-react-native';
import { Video } from '@/types/video';
import { formatNumber, formatDate, formatDuration } from '@/utils/formatters';
import { getPlatformColor, getPlatformIcon } from '@/utils/platforms';

interface VideoCardProps {
  video: Video;
  rank?: number;
}

export default function VideoCard({ video, rank }: VideoCardProps) {
  const router = useRouter();
  const PlatformIcon = getPlatformIcon(video.platform);
  const platformColor = getPlatformColor(video.platform);

  const handlePress = () => {
    router.push(`/video/${video.id}`);
  };

  return (
    <TouchableOpacity style={styles.container} onPress={handlePress}>
      {rank && (
        <View style={styles.rankContainer}>
          <Text style={styles.rankText}>{rank}</Text>
        </View>
      )}
      
      <View style={styles.thumbnailContainer}>
        <Image 
          source={{ uri: video.thumbnailUrl }} 
          style={styles.thumbnail}
          resizeMode="cover"
        />
        <View style={styles.durationBadge}>
          <Text style={styles.durationText}>{formatDuration(video.duration)}</Text>
        </View>
      </View>
      
      <View style={styles.contentContainer}>
        <View style={styles.headerContainer}>
          <Text style={styles.title} numberOfLines={2}>{video.title}</Text>
          <View style={[styles.platformBadge, { backgroundColor: platformColor + '20' }]}>
            {PlatformIcon && <PlatformIcon size={14} color={platformColor} style={styles.platformIcon} />}
            <Text style={[styles.platformText, { color: platformColor }]}>{video.platform}</Text>
          </View>
        </View>
        
        <View style={styles.creatorContainer}>
          <Image 
            source={{ uri: video.creatorAvatarUrl }} 
            style={styles.creatorAvatar}
          />
          <Text style={styles.creatorName} numberOfLines={1}>{video.creatorName}</Text>
        </View>
        
        <View style={styles.statsContainer}>
          <View style={styles.statItem}>
            <Eye size={14} color="#8E8E93" style={styles.statIcon} />
            <Text style={styles.statText}>{formatNumber(video.views)}</Text>
          </View>
          <View style={styles.statItem}>
            <ThumbsUp size={14} color="#8E8E93" style={styles.statIcon} />
            <Text style={styles.statText}>{formatNumber(video.likes)}</Text>
          </View>
          <View style={styles.statItem}>
            <MessageCircle size={14} color="#8E8E93" style={styles.statIcon} />
            <Text style={styles.statText}>{formatNumber(video.comments)}</Text>
          </View>
          <Text style={styles.dateText}>{formatDate(video.publishedAt)}</Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
    overflow: 'hidden',
  },
  rankContainer: {
    position: 'absolute',
    top: 8,
    left: 8,
    zIndex: 1,
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  rankText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  thumbnailContainer: {
    width: 120,
    position: 'relative',
  },
  thumbnail: {
    width: '100%',
    height: '100%',
  },
  durationBadge: {
    position: 'absolute',
    bottom: 8,
    right: 8,
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  durationText: {
    color: '#FFFFFF',
    fontSize: 10,
    fontWeight: '500',
  },
  contentContainer: {
    flex: 1,
    padding: 12,
  },
  headerContainer: {
    marginBottom: 8,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  platformBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  platformIcon: {
    marginRight: 4,
  },
  platformText: {
    fontSize: 10,
    fontWeight: '600',
  },
  creatorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  creatorAvatar: {
    width: 20,
    height: 20,
    borderRadius: 10,
    marginRight: 6,
  },
  creatorName: {
    fontSize: 12,
    color: '#8E8E93',
  },
  statsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
  },
  statItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 8,
  },
  statIcon: {
    marginRight: 2,
  },
  statText: {
    fontSize: 12,
    color: '#8E8E93',
  },
  dateText: {
    fontSize: 12,
    color: '#8E8E93',
    marginLeft: 'auto',
  },
});