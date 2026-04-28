// lib/models/trending_video.dart
import 'package:flutter/material.dart';

enum SocialPlatform {
  instagram,
  twitter,
  facebook,
  youtube,
  tiktok,
  reddit,
}

extension SocialPlatformExtension on SocialPlatform {
  String get name {
    switch (this) {
      case SocialPlatform.instagram: return 'Instagram';
      case SocialPlatform.twitter: return 'X (Twitter)';
      case SocialPlatform.facebook: return 'Facebook';
      case SocialPlatform.youtube: return 'YouTube';
      case SocialPlatform.tiktok: return 'TikTok';
      case SocialPlatform.reddit: return 'Reddit';
    }
  }

  Color get color {
    switch (this) {
      case SocialPlatform.instagram: return const Color(0xFFE1306C);
      case SocialPlatform.twitter: return const Color(0xFF000000);
      case SocialPlatform.facebook: return const Color(0xFF1877F2);
      case SocialPlatform.youtube: return const Color(0xFFFF0000);
      case SocialPlatform.tiktok: return const Color(0xFF010101);
      case SocialPlatform.reddit: return const Color(0xFFFF4500);
    }
  }

  String get iconPath {
    switch (this) {
      case SocialPlatform.instagram: return 'assets/images/instagram.png';
      case SocialPlatform.twitter: return 'assets/images/twitter.png';
      case SocialPlatform.facebook: return 'assets/images/facebook.png';
      case SocialPlatform.youtube: return 'assets/images/youtube.png';
      case SocialPlatform.tiktok: return 'assets/images/tiktok.png';
      case SocialPlatform.reddit: return 'assets/images/reddit.png';
    }
  }
}

class LocationInfo {
  final String country;
  final String state;
  final String district;
  final String city;
  final double? latitude;
  final double? longitude;

  const LocationInfo({
    required this.country,
    required this.state,
    required this.district,
    required this.city,
    this.latitude,
    this.longitude,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
    country: json['country'] ?? '',
    state: json['state'] ?? '',
    district: json['district'] ?? '',
    city: json['city'] ?? '',
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'country': country,
    'state': state,
    'district': district,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
  };

  String get displayName {
    if (city.isNotEmpty) return city;
    if (district.isNotEmpty) return district;
    if (state.isNotEmpty) return state;
    return country;
  }
}

class ContentInsight {
  final String summary;
  final List<String> keyTopics;
  final List<String> contentIdeas;
  final String sentiment;
  final String category;
  final String targetAudience;
  final List<String> suggestedHashtags;
  final String bestTimeToPost;
  final int estimatedEngagement;

  const ContentInsight({
    required this.summary,
    required this.keyTopics,
    required this.contentIdeas,
    required this.sentiment,
    required this.category,
    required this.targetAudience,
    required this.suggestedHashtags,
    required this.bestTimeToPost,
    required this.estimatedEngagement,
  });

  factory ContentInsight.fromJson(Map<String, dynamic> json) => ContentInsight(
    summary: json['summary'] ?? '',
    keyTopics: List<String>.from(json['keyTopics'] ?? []),
    contentIdeas: List<String>.from(json['contentIdeas'] ?? []),
    sentiment: json['sentiment'] ?? 'neutral',
    category: json['category'] ?? 'General',
    targetAudience: json['targetAudience'] ?? 'General',
    suggestedHashtags: List<String>.from(json['suggestedHashtags'] ?? []),
    bestTimeToPost: json['bestTimeToPost'] ?? '',
    estimatedEngagement: json['estimatedEngagement'] ?? 0,
  );
}

class TrendingVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String originalUrl;
  final SocialPlatform platform;
  final String creator;
  final String creatorAvatar;
  final int viewCount;
  final int likeCount;
  final int shareCount;
  final int commentCount;
  final List<String> hashtags;
  final List<LocationInfo> trendingLocations;
  final DateTime publishedAt;
  final DateTime fetchedAt;
  final ContentInsight? insight;
  final int trendScore;
  final String category;
  final bool isLocationSpecific;
  final String duration;

  const TrendingVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.originalUrl,
    required this.platform,
    required this.creator,
    required this.creatorAvatar,
    required this.viewCount,
    required this.likeCount,
    required this.shareCount,
    required this.commentCount,
    required this.hashtags,
    required this.trendingLocations,
    required this.publishedAt,
    required this.fetchedAt,
    this.insight,
    required this.trendScore,
    required this.category,
    required this.isLocationSpecific,
    required this.duration,
  });

  factory TrendingVideo.fromJson(Map<String, dynamic> json) => TrendingVideo(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    thumbnailUrl: json['thumbnailUrl'] ?? '',
    videoUrl: json['videoUrl'] ?? '',
    originalUrl: json['originalUrl'] ?? '',
    platform: SocialPlatform.values.firstWhere(
      (p) => p.toString().split('.').last == json['platform'],
      orElse: () => SocialPlatform.youtube,
    ),
    creator: json['creator'] ?? '',
    creatorAvatar: json['creatorAvatar'] ?? '',
    viewCount: json['viewCount'] ?? 0,
    likeCount: json['likeCount'] ?? 0,
    shareCount: json['shareCount'] ?? 0,
    commentCount: json['commentCount'] ?? 0,
    hashtags: List<String>.from(json['hashtags'] ?? []),
    trendingLocations: (json['trendingLocations'] as List? ?? [])
        .map((l) => LocationInfo.fromJson(l))
        .toList(),
    publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    fetchedAt: DateTime.tryParse(json['fetchedAt'] ?? '') ?? DateTime.now(),
    insight: json['insight'] != null
        ? ContentInsight.fromJson(json['insight'])
        : null,
    trendScore: json['trendScore'] ?? 0,
    category: json['category'] ?? 'General',
    isLocationSpecific: json['isLocationSpecific'] ?? false,
    duration: json['duration'] ?? '0:00',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'thumbnailUrl': thumbnailUrl,
    'videoUrl': videoUrl,
    'originalUrl': originalUrl,
    'platform': platform.toString().split('.').last,
    'creator': creator,
    'creatorAvatar': creatorAvatar,
    'viewCount': viewCount,
    'likeCount': likeCount,
    'shareCount': shareCount,
    'commentCount': commentCount,
    'hashtags': hashtags,
    'trendingLocations': trendingLocations.map((l) => l.toJson()).toList(),
    'publishedAt': publishedAt.toIso8601String(),
    'fetchedAt': fetchedAt.toIso8601String(),
    'trendScore': trendScore,
    'category': category,
    'isLocationSpecific': isLocationSpecific,
    'duration': duration,
  };

  String get formattedViews {
    if (viewCount >= 1000000) return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    if (viewCount >= 1000) return '${(viewCount / 1000).toStringAsFixed(1)}K';
    return viewCount.toString();
  }

  String get formattedLikes {
    if (likeCount >= 1000000) return '${(likeCount / 1000000).toStringAsFixed(1)}M';
    if (likeCount >= 1000) return '${(likeCount / 1000).toStringAsFixed(1)}K';
    return likeCount.toString();
  }
}

class TrendingTopic {
  final String hashtag;
  final String category;
  final int videoCount;
  final int totalViews;
  final List<LocationInfo> locations;
  final List<SocialPlatform> platforms;
  final DateTime firstSeen;
  final int trendScore;
  final double growthRate; // percentage growth in last hour
  final List<String> relatedHashtags;

  const TrendingTopic({
    required this.hashtag,
    required this.category,
    required this.videoCount,
    required this.totalViews,
    required this.locations,
    required this.platforms,
    required this.firstSeen,
    required this.trendScore,
    required this.growthRate,
    required this.relatedHashtags,
  });

  factory TrendingTopic.fromJson(Map<String, dynamic> json) => TrendingTopic(
    hashtag: json['hashtag'] ?? '',
    category: json['category'] ?? '',
    videoCount: json['videoCount'] ?? 0,
    totalViews: json['totalViews'] ?? 0,
    locations: (json['locations'] as List? ?? [])
        .map((l) => LocationInfo.fromJson(l))
        .toList(),
    platforms: (json['platforms'] as List? ?? [])
        .map((p) => SocialPlatform.values.firstWhere(
              (sp) => sp.toString().split('.').last == p,
              orElse: () => SocialPlatform.youtube,
            ))
        .toList(),
    firstSeen: DateTime.tryParse(json['firstSeen'] ?? '') ?? DateTime.now(),
    trendScore: json['trendScore'] ?? 0,
    growthRate: (json['growthRate'] ?? 0).toDouble(),
    relatedHashtags: List<String>.from(json['relatedHashtags'] ?? []),
  );
}

class LocationFilter {
  final String? country;
  final String? state;
  final String? district;
  final String? city;

  const LocationFilter({
    this.country,
    this.state,
    this.district,
    this.city,
  });

  bool get isEmpty => country == null && state == null && district == null && city == null;

  String get displayText {
    if (city != null) return city!;
    if (district != null) return district!;
    if (state != null) return state!;
    if (country != null) return country!;
    return 'Global';
  }
}
