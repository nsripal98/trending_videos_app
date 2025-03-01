import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator, Image, Linking, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { ChevronLeft, Share2, ThumbsUp, MessageCircle, Eye, Calendar, Clock, Tag } from 'lucide-react-native';
import { fetchVideoDetails } from '@/api/videos';
import { Video } from '@/types/video';
import { formatNumber, formatDate, formatDuration } from '@/utils/formatters';
import { getPlatformColor, getPlatformIcon } from '@/utils/platforms';

export default function VideoDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [video, setVideo] = useState<Video | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    
    const loadVideoDetails = async () => {
      try {
        setLoading(true);
        setError(null);
        const data = await fetchVideoDetails(id);
        setVideo(data);
      } catch (err) {
        setError('Failed to load video details. Please try again later.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    
    loadVideoDetails();
  }, [id]);

  const handleOpenVideo = () => {
    if (video?.url) {
      Linking.openURL(video.url).catch((err) => {
        console.error('Error opening video URL:', err);
      });
    }
  };

  const handleShare = () => {
    if (video?.url) {
      if (Platform.OS === 'web') {
        // Web implementation
        navigator.clipboard.writeText(video.url);
        alert('Link copied to clipboard!');
      } else {
        // Native implementation
        Linking.share({
          title: video.title,
          url: video.url,
        });
      }
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#007AFF" />
        <Text style={styles.loadingText}>Loading video details...</Text>
      </SafeAreaView>
    );
  }

  if (error || !video) {
    return (
      <SafeAreaView style={styles.errorContainer}>
        <Text style={styles.errorText}>{error || 'Video not found'}</Text>
        <TouchableOpacity style={styles.retryButton} onPress={() => router.back()}>
          <Text style={styles.retryButtonText}>Go Back</Text>
        </TouchableOpacity>
      </SafeAreaView>
    );
  }

  const PlatformIcon = getPlatformIcon(video.platform);
  const platformColor = getPlatformColor(video.platform);

  return (
    <SafeAreaView style={styles.container}>
      <Stack.Screen 
        options={{
          headerShown: true,
          headerTitle: 'Video Details',
          headerLeft: () => (
            <TouchableOpacity onPress={() => router.back()}>
              <ChevronLeft size={24} color="#007AFF" />
            </TouchableOpacity>
          ),
          headerRight: () => (
            <TouchableOpacity onPress={handleShare} style={styles.shareButton}>
              <Share2 size={22} color="#007AFF" />
            </TouchableOpacity>
          ),
        }} 
      />

      <ScrollView style={styles.scrollView}>
        <View style={styles.thumbnailContainer}>
          <Image 
            source={{ uri: video.thumbnailUrl }} 
            style={styles.thumbnail}
            resizeMode="cover"
          />
          <TouchableOpacity 
            style={styles.playButton}
            onPress={handleOpenVideo}
          >
            <Text style={styles.playButtonText}>Watch on {video.platform}</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.contentContainer}>
          <View style={styles.titleContainer}>
            <Text style={styles.title}>{video.title}</Text>
            <View style={[styles.platformBadge, { backgroundColor: platformColor + '20' }]}>
              {PlatformIcon && <PlatformIcon size={16} color={platformColor} style={styles.platformIcon} />}
              <Text style={[styles.platformText, { color: platformColor }]}>{video.platform}</Text>
            </View>
          </View>

          <View style={styles.statsContainer}>
            <View style={styles.statItem}>
              <Eye size={16} color="#8E8E93" style={styles.statIcon} />
              <Text style={styles.statText}>{formatNumber(video.views)} views</Text>
            </View>
            <View style={styles.statItem}>
              <ThumbsUp size={16} color="#8E8E93" style={styles.statIcon} />
              <Text style={styles.statText}>{formatNumber(video.likes)} likes</Text>
            </View>
            <View style={styles.statItem}>
              <MessageCircle size={16} color="#8E8E93" style={styles.statIcon} />
              <Text style={styles.statText}>{formatNumber(video.comments)} comments</Text>
            </View>
          </View>

          <View style={styles.divider} />

          <View style={styles.creatorContainer}>
            <Image 
              source={{ uri: video.creatorAvatarUrl }} 
              style={styles.creatorAvatar}
            />
            <View style={styles.creatorInfo}>
              <Text style={styles.creatorName}>{video.creatorName}</Text>
              <Text style={styles.creatorFollowers}>{formatNumber(video.creatorFollowers)} followers</Text>
            </View>
          </View>

          <View style={styles.divider} />

          <View style={styles.metadataContainer}>
            <View style={styles.metadataItem}>
              <Calendar size={16} color="#8E8E93" style={styles.metadataIcon} />
              <Text style={styles.metadataLabel}>Published:</Text>
              <Text style={styles.metadataValue}>{formatDate(video.publishedAt)}</Text>
            </View>
            <View style={styles.metadataItem}>
              <Clock size={16} color="#8E8E93" style={styles.metadataIcon} />
              <Text style={styles.metadataLabel}>Duration:</Text>
              <Text style={styles.metadataValue}>{formatDuration(video.duration)}</Text>
            </View>
            <View style={styles.metadataItem}>
              <Tag size={16} color="#8E8E93" style={styles.metadataIcon} />
              <Text style={styles.metadataLabel}>Category:</Text>
              <Text style={styles.metadataValue}>{video.category}</Text>
            </View>
          </View>

          <View style={styles.divider} />

          <Text style={styles.sectionTitle}>Description</Text>
          <Text style={styles.description}>{video.description}</Text>

          {video.contentAnalysis && (
            <>
              <View style={styles.divider} />
              <Text style={styles.sectionTitle}>Content Analysis</Text>
              <View style={styles.analysisContainer}>
                {Object.entries(video.contentAnalysis).map(([key, value]) => (
                  <View key={key} style={styles.analysisItem}>
                    <Text style={styles.analysisLabel}>{key}:</Text>
                    <Text style={styles.analysisValue}>{value}</Text>
                  </View>
                ))}
              </View>
            </>
          )}

          <View style={styles.divider} />

          <Text style={styles.sectionTitle}>Trending In</Text>
          <View style={styles.locationContainer}>
            <Text style={styles.locationText}>
              {video.trendingRegions.join(', ')}
            </Text>
          </View>

          <TouchableOpacity 
            style={styles.watchButton}
            onPress={handleOpenVideo}
          >
            <Text style={styles.watchButtonText}>Watch on {video.platform}</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F2F2F7',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F2F2F7',
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#8E8E93',
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  errorText: {
    fontSize: 16,
    color: '#FF3B30',
    textAlign: 'center',
    marginBottom: 16,
  },
  retryButton: {
    backgroundColor: '#007AFF',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
  },
  retryButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
  scrollView: {
    flex: 1,
  },
  shareButton: {
    padding: 8,
  },
  thumbnailContainer: {
    position: 'relative',
    width: '100%',
    height: 220,
  },
  thumbnail: {
    width: '100%',
    height: '100%',
  },
  playButton: {
    position: 'absolute',
    bottom: 16,
    right: 16,
    backgroundColor: '#007AFF',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
  },
  playButtonText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '600',
  },
  contentContainer: {
    padding: 16,
    backgroundColor: '#FFFFFF',
  },
  titleContainer: {
    marginBottom: 12,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 8,
  },
  platformBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  platformIcon: {
    marginRight: 4,
  },
  platformText: {
    fontSize: 12,
    fontWeight: '600',
  },
  statsContainer: {
    flexDirection: 'row',
    marginBottom: 16,
  },
  statItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
  },
  statIcon: {
    marginRight: 4,
  },
  statText: {
    fontSize: 14,
    color: '#8E8E93',
  },
  divider: {
    height: 1,
    backgroundColor: '#E5E5EA',
    marginVertical: 16,
  },
  creatorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  creatorAvatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    marginRight: 12,
  },
  creatorInfo: {
    flex: 1,
  },
  creatorName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  creatorFollowers: {
    fontSize: 14,
    color: '#8E8E93',
  },
  metadataContainer: {
    marginBottom: 16,
  },
  metadataItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  metadataIcon: {
    marginRight: 8,
  },
  metadataLabel: {
    fontSize: 14,
    color: '#8E8E93',
    width: 80,
  },
  metadataValue: {
    fontSize: 14,
    color: '#000000',
    flex: 1,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 12,
  },
  description: {
    fontSize: 14,
    lineHeight: 20,
    color: '#000000',
  },
  analysisContainer: {
    backgroundColor: '#F2F2F7',
    borderRadius: 8,
    padding: 12,
  },
  analysisItem: {
    flexDirection: 'row',
    marginBottom: 8,
  },
  analysisLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
    width: 120,
  },
  analysisValue: {
    fontSize: 14,
    color: '#000000',
    flex: 1,
  },
  locationContainer: {
    backgroundColor: '#F2F2F7',
    borderRadius: 8,
    padding: 12,
    marginBottom: 16,
  },
  locationText: {
    fontSize: 14,
    color: '#000000',
  },
  watchButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 14,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 16,
  },
  watchButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
});