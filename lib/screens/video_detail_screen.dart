// lib/screens/video_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoDetailScreen extends StatefulWidget {
  final TrendingVideo video;
  const VideoDetailScreen({super.key, required this.video});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                onPressed: () => _launchUrl(video.originalUrl),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => _shareVideo(video),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background.withOpacity(0.95)],
                      ),
                    ),
                  ),
                  // Play button
                  Center(
                    child: GestureDetector(
                      onTap: () => _launchUrl(video.originalUrl),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)],
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  // Platform badge
                  Positioned(
                    top: 80,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: video.platform.color.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        video.platform.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    video.title,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Creator + time
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary.withOpacity(0.3),
                        child: Text(
                          video.creator.isNotEmpty ? video.creator[0].toUpperCase() : '?',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(video.creator, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600)),
                          Text(timeago.format(video.publishedAt), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      // Trend score
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.trending, AppColors.hot]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${video.trendScore}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats grid
                  _buildStatsGrid(video),
                  const SizedBox(height: 16),
                  // Trending locations
                  if (video.trendingLocations.isNotEmpty) ...[
                    _buildLocationsSection(video),
                    const SizedBox(height: 16),
                  ],
                  // Tab bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      tabs: const [
                        Tab(text: '📋 Overview'),
                        Tab(text: '💡 Insights'),
                        Tab(text: '#️⃣ Hashtags'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(video),
                        _buildInsightsTab(video),
                        _buildHashtagsTab(video),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Open in platform button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(video.originalUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: video.platform.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      label: Text(
                        'Open on ${video.platform.name}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(TrendingVideo video) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _GridStat(icon: Icons.visibility, value: video.formattedViews, label: 'Views', color: AppColors.primary),
          _GridStat(icon: Icons.favorite, value: video.formattedLikes, label: 'Likes', color: AppColors.accent),
          _GridStat(icon: Icons.comment, value: '${video.commentCount}', label: 'Comments', color: AppColors.secondary),
          _GridStat(icon: Icons.share, value: '${video.shareCount}', label: 'Shares', color: AppColors.viral),
        ],
      ),
    );
  }

  Widget _buildLocationsSection(TrendingVideo video) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on, color: AppColors.rising, size: 16),
            SizedBox(width: 6),
            Text('Trending In', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: video.trendingLocations.map((loc) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.rising.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.rising.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: AppColors.rising, size: 12),
                const SizedBox(width: 4),
                Text(
                  '${loc.city.isNotEmpty ? loc.city : loc.district}, ${loc.state}',
                  style: const TextStyle(color: AppColors.rising, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(TrendingVideo video) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: '📝 Description',
            child: Text(video.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.6)),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: '📊 Category',
            child: Chip(
              label: Text(video.category, style: const TextStyle(color: AppColors.text)),
              backgroundColor: AppColors.primary.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: '⏱ Duration',
            child: Text(video.duration, style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab(TrendingVideo video) {
    final insight = video.insight;
    if (insight == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_outlined, color: AppColors.textSecondary, size: 48),
            SizedBox(height: 12),
            Text('No AI insights available', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          _SectionCard(
            title: '📋 Summary',
            gradient: true,
            child: Text(insight.summary, style: const TextStyle(color: Colors.white, height: 1.6)),
          ),
          const SizedBox(height: 12),

          // Sentiment
          _SectionCard(
            title: '😊 Sentiment',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getSentimentColor(insight.sentiment).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getSentimentColor(insight.sentiment).withOpacity(0.5)),
                  ),
                  child: Text(
                    '${_getSentimentEmoji(insight.sentiment)} ${insight.sentiment.toUpperCase()}',
                    style: TextStyle(
                      color: _getSentimentColor(insight.sentiment),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Key topics
          _SectionCard(
            title: '🎯 Key Topics',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: insight.keyTopics.map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: Text(t, style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Content ideas for creators
          _SectionCard(
            title: '💡 Content Ideas for Creators',
            child: Column(
              children: insight.contentIdeas.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value, style: const TextStyle(color: AppColors.text, height: 1.5)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Best time to post
          _SectionCard(
            title: '⏰ Best Time to Post',
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.viral, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(insight.bestTimeToPost,
                      style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Target audience
          _SectionCard(
            title: '👥 Target Audience',
            child: Text(insight.targetAudience, style: const TextStyle(color: AppColors.text)),
          ),
          const SizedBox(height: 12),

          // Engagement score
          _SectionCard(
            title: '📈 Estimated Engagement Score',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${insight.estimatedEngagement}%',
                      style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.trending_up, color: AppColors.rising, size: 24),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: insight.estimatedEngagement / 100,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHashtagsTab(TrendingVideo video) {
    final allHashtags = [
      ...video.hashtags,
      ...(video.insight?.suggestedHashtags ?? []),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: '🔥 Trending Hashtags',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: video.hashtags.map((h) => GestureDetector(
                onTap: () => _copyHashtag(h),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(h, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              )).toList(),
            ),
          ),
          if (video.insight?.suggestedHashtags.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: '✨ AI Suggested Hashtags',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Use these for maximum reach when creating similar content:',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: video.insight!.suggestedHashtags.map((h) => GestureDetector(
                      onTap: () => _copyHashtag(h),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(h, style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
                            const SizedBox(width: 4),
                            const Icon(Icons.copy, color: AppColors.secondary, size: 11),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          _SectionCard(
            title: '📋 Copy All Hashtags',
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    allHashtags.join(' '),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: allHashtags.join(' ')));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All hashtags copied!'), backgroundColor: AppColors.rising),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    icon: const Icon(Icons.copy, color: Colors.white),
                    label: const Text('Copy All', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyHashtag(String hashtag) {
    Clipboard.setData(ClipboardData(text: hashtag));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $hashtag'), backgroundColor: AppColors.rising, duration: const Duration(seconds: 1)),
    );
  }

  void _shareVideo(TrendingVideo video) {
    Clipboard.setData(ClipboardData(text: '${video.title}\n${video.originalUrl}\n${video.hashtags.join(' ')}'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video link copied!'), backgroundColor: AppColors.rising),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot open: $url'), backgroundColor: AppColors.accent),
        );
      }
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'excited':
      case 'euphoric':
      case 'celebratory': return AppColors.viral;
      case 'alarming':
      case 'urgent': return AppColors.trending;
      case 'heartwarming':
      case 'inspiring': return AppColors.secondary;
      default: return AppColors.primary;
    }
  }

  String _getSentimentEmoji(String sentiment) {
    switch (sentiment) {
      case 'excited': return '🎉';
      case 'euphoric': return '🚀';
      case 'celebratory': return '🏆';
      case 'alarming': return '⚠️';
      case 'urgent': return '🆘';
      case 'heartwarming': return '🥹';
      case 'inspiring': return '✨';
      case 'tense': return '😬';
      default: return '📊';
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool gradient;

  const _SectionCard({required this.title, required this.child, this.gradient = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.accent],
              )
            : null,
        color: gradient ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: gradient ? null : Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gradient ? Colors.white : AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _GridStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _GridStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
