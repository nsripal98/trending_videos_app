import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Video } from '@/types/video';
import { formatNumber } from '@/utils/formatters';
import { getPlatformColor, getPlatformIcon } from '@/utils/platforms';

interface ContentAnalysisCardProps {
  video: Video;
  rank?: number;
}

export default function ContentAnalysisCard({ video, rank }: ContentAnalysisCardProps) {
  const router = useRouter();
  const PlatformIcon = getPlatformIcon(video.platform);
  const platformColor = getPlatformColor(video.platform);

  const handlePress = () => {
    router.push(`/video/${video.id}`);
  };

  return (
    <TouchableOpacity style={styles.container} onPress={handlePress}>
      {rank && (
        <View style={[styles.rankContainer, { backgroundColor: platformColor }]}>
          <Text style={styles.rankText}>#{rank}</Text>
        </View>
      )}
      
      <View style={styles.headerContainer}>
        <View style={styles.titleRow}>
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
          <Text style={styles.creatorName}>{video.creatorName}</Text>
          <Text style={styles.viewCount}>{formatNumber(video.views)} views</Text>
        </View>
      </View>
      
      <View style={styles.contentContainer}>
        <View style={styles.thumbnailContainer}>
          <Image 
            source={{ uri: video.thumbnailUrl }} 
            style={styles.thumbnail}
            resizeMode="cover"
          />
        </View>
        
        <View style={styles.analysisContainer}>
          <Text style={styles.analysisTitle}>Content Analysis</Text>
          
          {video.contentAnalysis ? (
            <View style={styles.analysisItems}>
              {Object.entries(video.contentAnalysis).map(([key, value]) => (
                <View key={key} style={styles.analysisItem}>
                  <Text style={styles.analysisLabel}>{key}:</Text>
                  <Text style={styles.analysisValue}>{value}</Text>
                </View>
              ))}
            </View>
          ) : (
            <Text style={styles.noAnalysisText}>No content analysis available</Text>
          )}
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
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
    paddingHorizontal: 12,
    paddingVertical: 6,
    alignSelf: 'flex-start',
    borderTopLeftRadius: 12,
    borderBottomRightRadius: 12,
  },
  rankText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  headerContainer: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5EA',
  },
  titleRow: {
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
    marginRight: 8,
  },
  viewCount: {
    fontSize: 12,
    color: '#8E8E93',
  },
  contentContainer: {
    flexDirection: 'row',
    padding: 12,
  },
  thumbnailContainer: {
    width: 120,
    height: 90,
    borderRadius: 8,
    overflow: 'hidden',
    marginRight: 12,
  },
  thumbnail: {
    width: '100%',
    height: '100%',
  },
  analysisContainer: {
    flex: 1,
  },
  analysisTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 8,
  },
  analysisItems: {},
  analysisItem: {
    flexDirection: 'row',
    marginBottom: 4,
  },
  analysisLabel: {
    fontSize: 12,
    fontWeight: '500',
    color: '#000000',
    width: 80,
  },
  analysisValue: {
    fontSize: 12,
    color: '#000000',
    flex: 1,
  },
  noAnalysisText: {
    fontSize: 12,
    color: '#8E8E93',
    fontStyle: 'italic',
  },
});