import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { fetchRegions } from '@/api/regions';
import { Region } from '@/types/region';
import CountryPicker from '@/components/CountryPicker';

export default function RegionsScreen() {
  const router = useRouter();
  const [regions, setRegions] = useState<Region[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCountry, setSelectedCountry] = useState('usa');
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadRegions();
  }, [selectedCountry]);

  const loadRegions = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchRegions(selectedCountry);
      setRegions(data);
    } catch (err) {
      setError('Failed to load regions. Please try again later.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleRegionPress = (regionCode: string) => {
    router.push(`/region/${selectedCountry}/${regionCode}`);
  };

  const handleCountryChange = (countryCode: string) => {
    setSelectedCountry(countryCode);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Regions</Text>
        <Text style={styles.subtitle}>Select a region to view trending videos</Text>
      </View>

      <CountryPicker 
        selectedCountry={selectedCountry}
        onSelectCountry={handleCountryChange}
      />

      {loading ? (
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#007AFF" />
          <Text style={styles.loadingText}>Loading regions...</Text>
        </View>
      ) : error ? (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity style={styles.retryButton} onPress={loadRegions}>
            <Text style={styles.retryButtonText}>Retry</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={regions}
          keyExtractor={(item) => item.code}
          renderItem={({ item }) => (
            <TouchableOpacity 
              style={styles.regionItem}
              onPress={() => handleRegionPress(item.code)}
            >
              <Text style={styles.regionName}>{item.name}</Text>
              <Text style={styles.videoCount}>{item.videoCount} trending videos</Text>
            </TouchableOpacity>
          )}
          contentContainerStyle={styles.listContent}
          numColumns={2}
          ListEmptyComponent={
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyText}>No regions found</Text>
              <Text style={styles.emptySubtext}>Try selecting a different country</Text>
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
  header: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 8,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5EA',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#000000',
  },
  subtitle: {
    fontSize: 16,
    color: '#8E8E93',
    marginTop: 4,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#8E8E93',
  },
  listContent: {
    padding: 8,
  },
  regionItem: {
    flex: 1,
    margin: 8,
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  regionName: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  videoCount: {
    fontSize: 14,
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