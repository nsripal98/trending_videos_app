// lib/widgets/video_card.dart
import 'package:flutter/material.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoCard extends StatelessWidget {
  final TrendingVideo video;
  final VoidCallback onTap;
  final bool isCompact;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            _buildThumbnail(context),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform + Trend score row
                  Row(
                    children: [
                      _PlatformBadge(platform: video.platform),
                      const SizedBox(width: 8),
                      if (video.isLocationSpecific)
                        _LocationBadge(locations: video.trendingLocations),
                      const Spacer(),
                      _TrendScoreBadge(score: video.trendScore),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Creator row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primary.withOpacity(0.3),
                        child: Text(
                          video.creator.isNotEmpty ? video.creator[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 9, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          video.creator,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeago.format(video.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Stats row
                  _StatsRow(video: video),
                  const SizedBox(height: 10),
                  // Hashtags
                  if (video.hashtags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: video.hashtags.take(3).map((h) => _HashtagChip(hashtag: h)).toList(),
                    ),
                  // Category tag
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(video.category).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getCategoryColor(video.category).withOpacity(0.4)),
                        ),
                        child: Text(
                          video.category,
                          style: TextStyle(
                            color: _getCategoryColor(video.category),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (video.insight != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'AI Insights',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          Image.network(
            video.thumbnailUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: AppColors.surface,
              child: const Icon(Icons.video_library_outlined, color: AppColors.textSecondary, size: 48),
            ),
          ),
          // Duration badge
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                video.duration,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          // Play button overlay
          Positioned.fill(
            child: Center(
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
          // Hot streak indicator
          if (video.trendScore >= 95)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Text('VIRAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Politics': return const Color(0xFFFF6584);
      case 'Sports': return const Color(0xFF2ED573);
      case 'Entertainment': return const Color(0xFFFFBE76);
      case 'Technology': return const Color(0xFF45AAF2);
      case 'Business': return const Color(0xFF26D0CE);
      case 'Food': return const Color(0xFFF9CA24);
      case 'Travel': return const Color(0xFF6C5CE7);
      case 'News': return const Color(0xFFFF7675);
      case 'Environment': return const Color(0xFF55EFC4);
      default: return AppColors.primary;
    }
  }
}

class _PlatformBadge extends StatelessWidget {
  final SocialPlatform platform;
  const _PlatformBadge({required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: platform.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: platform.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPlatformIcon(platform), color: platform.color, size: 12),
          const SizedBox(width: 4),
          Text(
            platform.name,
            style: TextStyle(color: platform.color, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(SocialPlatform p) {
    switch (p) {
      case SocialPlatform.youtube: return Icons.play_circle_outline;
      case SocialPlatform.instagram: return Icons.camera_alt_outlined;
      case SocialPlatform.twitter: return Icons.alternate_email;
      case SocialPlatform.facebook: return Icons.facebook;
      case SocialPlatform.tiktok: return Icons.music_video_outlined;
      case SocialPlatform.reddit: return Icons.forum_outlined;
    }
  }
}

class _LocationBadge extends StatelessWidget {
  final List<LocationInfo> locations;
  const _LocationBadge({required this.locations});

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();
    final loc = locations.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.rising.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.rising.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: AppColors.rising, size: 10),
          const SizedBox(width: 2),
          Text(
            loc.displayName,
            style: const TextStyle(color: AppColors.rising, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TrendScoreBadge extends StatelessWidget {
  final int score;
  const _TrendScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 90) color = AppColors.trending;
    else if (score >= 75) color = AppColors.hot;
    else color = AppColors.rising;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, color: color, size: 12),
          const SizedBox(width: 3),
          Text(
            '$score',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final TrendingVideo video;
  const _StatsRow({required this.video});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(icon: Icons.visibility_outlined, value: video.formattedViews, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        _StatItem(icon: Icons.favorite_outline, value: video.formattedLikes, color: AppColors.accent),
        const SizedBox(width: 12),
        _StatItem(icon: Icons.comment_outlined, value: '${video.commentCount}', color: AppColors.textSecondary),
        const SizedBox(width: 12),
        _StatItem(icon: Icons.share_outlined, value: '${video.shareCount}', color: AppColors.secondary),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _HashtagChip extends StatelessWidget {
  final String hashtag;
  const _HashtagChip({required this.hashtag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        hashtag,
        style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
