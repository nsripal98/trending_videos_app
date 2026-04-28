// lib/providers/trending_provider.dart
import 'package:flutter/material.dart';
import '../models/trending_video.dart';
import '../services/mock_data_service.dart';

enum TrendingViewMode { all, byLocation, byPlatform, byCategory }
enum SortMode { trendScore, viewCount, likeCount, recent }

class TrendingProvider with ChangeNotifier {
  List<TrendingVideo> _videos = [];
  List<TrendingTopic> _topics = [];
  bool _isLoading = false;
  String? _error;
  LocationFilter _locationFilter = const LocationFilter();
  SocialPlatform? _platformFilter;
  String _categoryFilter = 'All';
  SortMode _sortMode = SortMode.trendScore;
  TrendingViewMode _viewMode = TrendingViewMode.all;
  String _searchQuery = '';
  int _refreshInterval = 30; // seconds
  DateTime? _lastRefreshed;

  // Getters
  List<TrendingVideo> get videos => _filteredAndSorted();
  List<TrendingTopic> get topics => _topics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  LocationFilter get locationFilter => _locationFilter;
  SocialPlatform? get platformFilter => _platformFilter;
  String get categoryFilter => _categoryFilter;
  SortMode get sortMode => _sortMode;
  TrendingViewMode get viewMode => _viewMode;
  String get searchQuery => _searchQuery;
  DateTime? get lastRefreshed => _lastRefreshed;

  List<TrendingVideo> _filteredAndSorted() {
    var list = List<TrendingVideo>.from(_videos);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((v) =>
        v.title.toLowerCase().contains(q) ||
        v.description.toLowerCase().contains(q) ||
        v.hashtags.any((h) => h.toLowerCase().contains(q)) ||
        v.creator.toLowerCase().contains(q) ||
        v.category.toLowerCase().contains(q)
      ).toList();
    }

    switch (_sortMode) {
      case SortMode.trendScore:
        list.sort((a, b) => b.trendScore.compareTo(a.trendScore));
        break;
      case SortMode.viewCount:
        list.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
      case SortMode.likeCount:
        list.sort((a, b) => b.likeCount.compareTo(a.likeCount));
        break;
      case SortMode.recent:
        list.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        break;
    }

    return list;
  }

  Future<void> fetchTrending({bool forceRefresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      _videos = MockDataService.generateTrendingVideos(
        locationFilter: _locationFilter,
        platform: _platformFilter,
        category: _categoryFilter == 'All' ? null : _categoryFilter,
      );

      _topics = MockDataService.getTrendingTopics(
        locationFilter: _locationFilter,
      );

      _lastRefreshed = DateTime.now();
    } catch (e) {
      _error = 'Failed to fetch trending content: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLocationFilter(LocationFilter filter) {
    _locationFilter = filter;
    fetchTrending();
  }

  void clearLocationFilter() {
    _locationFilter = const LocationFilter();
    fetchTrending();
  }

  void setPlatformFilter(SocialPlatform? platform) {
    _platformFilter = platform;
    fetchTrending();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    fetchTrending();
  }

  void setSortMode(SortMode mode) {
    _sortMode = mode;
    notifyListeners();
  }

  void setViewMode(TrendingViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _locationFilter = const LocationFilter();
    _platformFilter = null;
    _categoryFilter = 'All';
    _searchQuery = '';
    _sortMode = SortMode.trendScore;
    fetchTrending();
  }

  Map<String, int> get platformDistribution {
    final map = <String, int>{};
    for (final video in _videos) {
      final name = video.platform.name;
      map[name] = (map[name] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get categoryDistribution {
    final map = <String, int>{};
    for (final video in _videos) {
      map[video.category] = (map[video.category] ?? 0) + 1;
    }
    return map;
  }

  List<TrendingVideo> get locationSpecificVideos =>
      _videos.where((v) => v.isLocationSpecific).toList();

  List<TrendingVideo> getVideosByCategory(String category) =>
      _videos.where((v) => v.category == category).toList();

  List<TrendingVideo> getVideosByPlatform(SocialPlatform platform) =>
      _videos.where((v) => v.platform == platform).toList();
}
