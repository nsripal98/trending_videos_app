// test/models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:trendvault/models/trending_video.dart';
import 'package:trendvault/services/mock_data_service.dart';

void main() {
  // ── Model Tests ──────────────────────────────────────────
  group('TrendingVideo model', () {
    test('formattedViews returns K suffix for thousands', () {
      final video = _makeVideo(viewCount: 5000);
      expect(video.formattedViews, '5.0K');
    });

    test('formattedViews returns M suffix for millions', () {
      final video = _makeVideo(viewCount: 2500000);
      expect(video.formattedViews, '2.5M');
    });

    test('formattedViews returns raw number below 1000', () {
      final video = _makeVideo(viewCount: 999);
      expect(video.formattedViews, '999');
    });

    test('fromJson roundtrip', () {
      final original = _makeVideo();
      final json = original.toJson();
      final restored = TrendingVideo.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.platform, original.platform);
      expect(restored.trendScore, original.trendScore);
    });
  });

  // ── LocationInfo Tests ───────────────────────────────────
  group('LocationInfo', () {
    test('displayName returns city when available', () {
      const loc = LocationInfo(
        country: 'India', state: 'Telangana',
        district: 'Hyderabad', city: 'Hyderabad',
      );
      expect(loc.displayName, 'Hyderabad');
    });

    test('displayName falls back to district when city empty', () {
      const loc = LocationInfo(
        country: 'India', state: 'Telangana',
        district: 'Rangareddy', city: '',
      );
      expect(loc.displayName, 'Rangareddy');
    });

    test('displayName falls back to country as last resort', () {
      const loc = LocationInfo(
        country: 'India', state: '', district: '', city: '',
      );
      expect(loc.displayName, 'India');
    });
  });

  // ── LocationFilter Tests ─────────────────────────────────
  group('LocationFilter', () {
    test('isEmpty is true when all fields are null', () {
      const filter = LocationFilter();
      expect(filter.isEmpty, isTrue);
    });

    test('isEmpty is false when any field is set', () {
      const filter = LocationFilter(state: 'Telangana');
      expect(filter.isEmpty, isFalse);
    });

    test('displayText shows city when set', () {
      const filter = LocationFilter(
        country: 'India', state: 'Telangana',
        district: 'Hyderabad', city: 'Hyderabad',
      );
      expect(filter.displayText, 'Hyderabad');
    });

    test('displayText shows Global when empty', () {
      const filter = LocationFilter();
      expect(filter.displayText, 'Global');
    });
  });

  // ── MockDataService Tests ────────────────────────────────
  group('MockDataService', () {
    test('generateTrendingVideos returns non-empty list', () {
      final videos = MockDataService.generateTrendingVideos();
      expect(videos, isNotEmpty);
    });

    test('videos sorted by trendScore descending', () {
      final videos = MockDataService.generateTrendingVideos();
      for (int i = 0; i < videos.length - 1; i++) {
        expect(videos[i].trendScore >= videos[i + 1].trendScore, isTrue);
      }
    });

    test('location filter returns only matching videos', () {
      const filter = LocationFilter(state: 'Telangana', city: 'Hyderabad');
      final videos = MockDataService.generateTrendingVideos(locationFilter: filter);
      for (final video in videos) {
        final matchesLocation = video.trendingLocations.any((loc) =>
          loc.city.toLowerCase().contains('hyderabad') ||
          loc.state.toLowerCase().contains('telangana'),
        );
        expect(matchesLocation, isTrue);
      }
    });

    test('platform filter returns only matching platform', () {
      final videos = MockDataService.generateTrendingVideos(
        platform: SocialPlatform.youtube,
      );
      for (final video in videos) {
        expect(video.platform, SocialPlatform.youtube);
      }
    });

    test('category filter works correctly', () {
      final videos = MockDataService.generateTrendingVideos(category: 'Sports');
      for (final video in videos) {
        expect(video.category, 'Sports');
      }
    });

    test('getTrendingTopics returns non-empty list', () {
      final topics = MockDataService.getTrendingTopics();
      expect(topics, isNotEmpty);
    });

    test('getIndianStates returns all major states', () {
      final states = MockDataService.getIndianStates();
      expect(states, contains('Telangana'));
      expect(states, contains('Maharashtra'));
      expect(states, contains('Karnataka'));
      expect(states, contains('Delhi'));
    });

    test('getCategories includes All', () {
      final cats = MockDataService.getCategories();
      expect(cats.first, 'All');
    });
  });

  // ── SocialPlatform extension Tests ───────────────────────
  group('SocialPlatform extension', () {
    test('platform names are correct', () {
      expect(SocialPlatform.instagram.name, 'Instagram');
      expect(SocialPlatform.twitter.name, 'X (Twitter)');
      expect(SocialPlatform.youtube.name, 'YouTube');
      expect(SocialPlatform.facebook.name, 'Facebook');
    });

    test('platform colors are non-null', () {
      for (final p in SocialPlatform.values) {
        expect(p.color, isNotNull);
      }
    });
  });
}

// ── Helper ───────────────────────────────────────────────────
TrendingVideo _makeVideo({int viewCount = 1000, int likeCount = 100}) {
  return TrendingVideo(
    id: 'test_001',
    title: 'Test Video Title',
    description: 'Test description',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    videoUrl: 'https://youtube.com/watch?v=test',
    originalUrl: 'https://youtube.com/watch?v=test',
    platform: SocialPlatform.youtube,
    creator: 'TestCreator',
    creatorAvatar: '',
    viewCount: viewCount,
    likeCount: likeCount,
    shareCount: 50,
    commentCount: 25,
    hashtags: ['#test', '#trending'],
    trendingLocations: const [
      LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad'),
    ],
    publishedAt: DateTime(2025, 1, 1),
    fetchedAt: DateTime(2025, 1, 1),
    trendScore: 85,
    category: 'Technology',
    isLocationSpecific: true,
    duration: '5:30',
  );
}
