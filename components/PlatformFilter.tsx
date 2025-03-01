import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { Instagram, Youtube, Facebook, Twitter, Video } from 'lucide-react-native';
import { getPlatformColor, getPlatformIcon } from '@/utils/platforms';

interface PlatformFilterProps {
  selectedPlatform: string | null;
  onSelectPlatform: (platform: string | null) => void;
}

const platforms = [
  { id: null, name: 'All' },
  { id: 'instagram', name: 'Instagram' },
  { id: 'youtube', name: 'YouTube' },
  { id: 'facebook', name: 'Facebook' },
  { id: 'twitter', name: 'Twitter' },
  { id: 'tiktok', name: 'TikTok' },
];

export default function PlatformFilter({ selectedPlatform, onSelectPlatform }: PlatformFilterProps) {
  return (
    <View style={styles.container}>
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {platforms.map((platform) => {
          const isSelected = selectedPlatform === platform.id;
          const PlatformIcon = platform.id ? getPlatformIcon(platform.id) : null;
          const platformColor = platform.id ? getPlatformColor(platform.id) : '#007AFF';
          
          return (
            <TouchableOpacity
              key={platform.id || 'all'}
              style={[
                styles.platformButton,
                isSelected && { backgroundColor: platformColor + '20', borderColor: platformColor }
              ]}
              onPress={() => onSelectPlatform(platform.id)}
            >
              {PlatformIcon && <PlatformIcon size={16} color={isSelected ? platformColor : '#8E8E93'} style={styles.icon} />}
              <Text 
                style={[
                  styles.platformText,
                  isSelected && { color: platformColor, fontWeight: '600' }
                ]}
              >
                {platform.name}
              </Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5EA',
  },
  scrollContent: {
    paddingHorizontal: 12,
    paddingVertical: 12,
  },
  platformButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 20,
    marginHorizontal: 4,
    borderWidth: 1,
    borderColor: '#E5E5EA',
  },
  icon: {
    marginRight: 6,
  },
  platformText: {
    fontSize: 14,
    color: '#8E8E93',
  },
});