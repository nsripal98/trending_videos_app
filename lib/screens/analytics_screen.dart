// lib/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trending_provider.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Creator Insights', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 18)),
            Text('Data to help you create better content', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
        backgroundColor: AppColors.background,
      ),
      body: Consumer<TrendingProvider>(
        builder: (context, provider, _) {
          final videos = provider.videos;
          if (videos.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform distribution
                _buildPlatformChart(provider),
                const SizedBox(height: 20),
                // Category breakdown
                _buildCategoryBreakdown(provider),
                const SizedBox(height: 20),
                // Top performers
                _buildTopPerformers(videos),
                const SizedBox(height: 20),
                // Content ideas aggregated
                _buildAggregatedIdeas(videos),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlatformChart(TrendingProvider provider) {
    final dist = provider.platformDistribution;
    final total = dist.values.fold(0, (a, b) => a + b);

    return _Card(
      title: '📱 Platform Distribution',
      subtitle: 'Where trending content originates',
      child: Column(
        children: SocialPlatform.values.map((p) {
          final count = dist[p.name] ?? 0;
          final pct = total > 0 ? count / total : 0.0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getPlatformIcon(p), color: p.color, size: 16),
                    const SizedBox(width: 8),
                    Text(p.name, style: const TextStyle(color: AppColors.text, fontSize: 13)),
                    const Spacer(),
                    Text('$count videos', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    const SizedBox(width: 8),
                    Text('${(pct * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: p.color, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(p.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryBreakdown(TrendingProvider provider) {
    final dist = provider.categoryDistribution;
    final sorted = dist.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return _Card(
      title: '🏷️ Category Breakdown',
      subtitle: 'Most trending content categories',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: sorted.map((e) {
          final color = _getCategoryColor(e.key);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.key, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Text('${e.value}', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopPerformers(List<TrendingVideo> videos) {
    final top = videos.take(5).toList();
    return _Card(
      title: '🏆 Top Performing Videos',
      subtitle: 'Highest trend score right now',
      child: Column(
        children: top.asMap().entries.map((e) {
          final video = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: e.key == 0 ? AppColors.viral : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${e.key + 1}',
                      style: TextStyle(
                        color: e.key == 0 ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.title, style: const TextStyle(color: AppColors.text, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: video.platform.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text(video.platform.name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                          const SizedBox(width: 8),
                          Text(video.formattedViews + ' views', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.trending.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '🔥 ${video.trendScore}',
                    style: const TextStyle(color: AppColors.trending, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAggregatedIdeas(List<TrendingVideo> videos) {
    final ideas = <String>[];
    for (final video in videos) {
      if (video.insight != null) {
        ideas.addAll(video.insight!.contentIdeas.take(2));
      }
    }

    if (ideas.isEmpty) return const SizedBox.shrink();

    return _Card(
      title: '💡 Content Creator Ideas',
      subtitle: 'AI-generated ideas based on current trends',
      child: Column(
        children: ideas.take(10).asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.08), AppColors.accent.withOpacity(0.08)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(e.value, style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.4)),
              ),
            ],
          ),
        )).toList(),
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
      default: return AppColors.primary;
    }
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Card({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 16)),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
