import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { ChevronLeft } from 'lucide-react-native';
import { fetchTrendingVideos } from '@/api/videos';
import { fetchRegionDetails } from '@/api/regions';
import { fetchCountryDetails } from '@/api/countries';
import { Video } from '@/types/video';
import PlatformFilter from '@/components/PlatformFilter';
import VideoCard from '@/components/VideoCard';
import ContentAnalysisCard from '@/components/ContentAnalysisCard';

export default function RegionScreen() {
  const { country, code } = useLocalSearchParams<{ country: string, code: string }>();
  const router = useRouter();
  const [countryName, setCountryName] = useState('');
  const [regionName, setRegionName] = useState('');
  const [videos, setVideos] = useState<Video[]>([]);
  const [topContent, setTopContent] = useState<Video[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedPlatform, setSelectedPlatform] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState('trending');

  useEffect(() => {
    if (!country || !code) return;
    
    const loadData = async () => {
      try {
        setLoading(true);
        setError(null);
        
        // Fetch country and region details
        const countryDetails = await fetchCountryDetails(country);
        setCountryName(countryDetails.name);
        
        const regionDetails = await fetchRegionDetails(country, code);
        setRegionName(regionDetails.name);
        
        // Fetch trending videos
        const trendingData = await fetchTrendingVideos(country, code, selectedPlatform);
        setVideos(trendingData);
        
        // Fetch top content videos
        const contentData = await fetchTrendingVideos(country, code, selectedPlatform, true);
        setTopContent(contentData.slice(0, 3));
      } catch (err) {
        setError('Failed to load data. Please try again later.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    
    loadData();
  }, [country, code, selectedPlatform]);

  const handlePlatformChange = (platform: string | null) => {
    setSelectedPlatform(platform);
  };

  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#007AFF" />
        <Text style={styles.loadingText}>Loading videos...</Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <Stack.Screen 
        options={{
          headerShown: true,
          headerTitle: `${regionName}, ${countryName}`,
          headerLeft: () => (
            <TouchableOpacity onPress={() => router.back()}>
              <ChevronLeft size={24} color="#007AFF" />
            </TouchableOpacity>
          ),
        }} 
      />

      <PlatformFilter 
        selectedPlatform={selectedPlatform} 
        onSelectPlatform={handlePlatformChange} 
      />

      <View style={styles.tabContainer}>
        <TouchableOpacity 
          style={[styles.tab, activeTab === 'trending' && styles.activeTab]}
          onPress={() => handleTabChange('trending')}
        >
          <Text style={[styles.tabText, activeTab === 'trending' && styles.activeTabText]}>
            Top 10 Trending
          </Text>
        </TouchableOpacity>
        <TouchableOpacity 
          style={[styles.tab, activeTab === 'content' && styles.activeTab]}
          onPress={() => handleTabChange('content')}
        >
          <Text style={[styles.tabText, activeTab === 'content' && styles.activeTabText]}>
            Top 3 Content
          </Text>
        </TouchableOpacity>
      </View>

      {error ? (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity 
            style={styles.retryButton} 
            onPress={() => {
              setLoading(true);
              // Re-fetch data
            }}
          >
            <Text style={styles.retryButtonText}>Retry</Text>
          </TouchableOpacity>
        </View>
      ) : activeTab === 'trending' ? (
        <FlatList
          data={videos}
          keyExtractor={(item) => item.id}
          renderItem={({ item, index }) => (
            <VideoCard video={item} rank={index + 1} />
          )}
          contentContainerStyle={styles.listContent}
          ListEmptyComponent={
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyText}>No videos found</Text>
              <Text style={styles.emptySubtext}>Try selecting a different platform or check back later</Text>
            </View>
          }
        />
      ) : (
        <FlatList
          data={topContent}
          keyExtractor={(item) => item.id}
          renderItem={({ item, index }) => (
            <ContentAnalysisCard video={item} rank={index + 1} />
          )}
          contentContainerStyle={styles.listContent}
          ListEmptyComponent={
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyText}>No content analysis available</Text>
              <Text style={styles.emptySubtext}>Try selecting a different platform or check back later</Text>
            </View>
          }
        />
      )}
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
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5EA',
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: '#007AFF',
  },
  tabText: {
    fontSize: 16,
    color: '#8E8E93',
  },
  activeTabText: {
    color: '#007AFF',
    fontWeight: '600',
  },
  listContent: {
    padding: 16,
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
  emptyContainer: {
    padding: 20,
    alignItems: 'center',
  },
  emptyText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#8E8E93',
    marginBottom: 8,
  },
  emptySubtext: {
    fontSize: 14,
    color: '#8E8E93',
    textAlign: 'center',
  },
});