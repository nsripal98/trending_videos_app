// lib/screens/topics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trending_provider.dart';
import '../providers/location_provider.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> with AutomaticKeepAliveClientMixin {
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
            Text('Trending Topics', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 18)),
            Text('Live hashtags & topics', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
        backgroundColor: AppColors.background,
      ),
      body: Consumer2<TrendingProvider, LocationProvider>(
        builder: (context, trendingProvider, locationProvider, _) {
          final topics = trendingProvider.topics;

          return RefreshIndicator(
            onRefresh: () => trendingProvider.fetchTrending(forceRefresh: true),
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // Location banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Trending in ${locationProvider.displayLocation}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          '${topics.length} topics',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // Topics list
                if (topics.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No trending topics found', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= topics.length) return const SizedBox(height: 80);
                        final topic = topics[index];
                        return _TopicCard(topic: topic, rank: index + 1);
                      },
                      childCount: topics.length + 1,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final TrendingTopic topic;
  final int rank;

  const _TopicCard({required this.topic, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTop3 ? AppColors.trending.withOpacity(0.4) : AppColors.divider,
          width: isTop3 ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: isTop3
                      ? const LinearGradient(colors: [AppColors.trending, AppColors.hot])
                      : null,
                  color: isTop3 ? null : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      color: isTop3 ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.hashtag,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      topic.category,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Growth rate
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.rising.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.rising.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.rising, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      '+${topic.growthRate.toStringAsFixed(0)}%',
                      style: const TextStyle(color: AppColors.rising, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              _TopicStat(icon: Icons.video_library, value: '${_formatCount(topic.videoCount)} videos', color: AppColors.primary),
              const SizedBox(width: 16),
              _TopicStat(icon: Icons.visibility, value: _formatCount(topic.totalViews), color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 10),
          // Platforms
          Row(
            children: [
              const Text('Platforms: ', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ...topic.platforms.map((p) => Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: p.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(p.name, style: TextStyle(color: p.color, fontSize: 10, fontWeight: FontWeight.w600)),
              )),
            ],
          ),
          // Locations
          if (topic.locations.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.rising, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    topic.locations.map((l) => l.displayName).join(', '),
                    style: const TextStyle(color: AppColors.rising, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          // Related hashtags
          if (topic.relatedHashtags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: topic.relatedHashtags.map((h) => Text(
                h,
                style: const TextStyle(color: AppColors.primary, fontSize: 11),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _TopicStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _TopicStat({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
