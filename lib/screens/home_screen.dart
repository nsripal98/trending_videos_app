// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trending_provider.dart';
import '../providers/location_provider.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';
import '../widgets/video_card.dart';
import 'video_detail_screen.dart';
import 'location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrendingProvider>().fetchTrending();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(context, innerBoxIsScrolled),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: _showSearch ? 160 : 120,
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeader(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final trendingProvider = context.watch<TrendingProvider>();

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_up, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TrendVault',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Trending videos across platforms',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              // Search toggle
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search, color: AppColors.text),
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                      trendingProvider.setSearchQuery('');
                    }
                  });
                },
              ),
              // Filter button
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.text),
                onPressed: () => _showFilterSheet(context),
              ),
            ],
          ),
          // Location row
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    locationProvider.displayLocation,
                    style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                ],
              ),
            ),
          ),
          // Search bar
          if (_showSearch) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: trendingProvider.setSearchQuery,
              autofocus: true,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Search videos, hashtags, creators...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<TrendingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.videos.isEmpty) {
          return _buildShimmerLoader();
        }

        if (provider.error != null && provider.videos.isEmpty) {
          return _buildError(provider);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchTrending(forceRefresh: true),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            slivers: [
              // Category filter bar
              SliverToBoxAdapter(child: _buildCategoryBar(provider)),
              // Platform filter chips
              SliverToBoxAdapter(child: _buildPlatformBar(provider)),
              // Sort options
              SliverToBoxAdapter(child: _buildSortBar(provider)),
              // Stats bar
              SliverToBoxAdapter(child: _buildStatsBar(provider)),
              // Videos list
              if (provider.videos.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, color: AppColors.textSecondary, size: 64),
                        SizedBox(height: 16),
                        Text('No videos found', style: TextStyle(color: AppColors.textSecondary)),
                        SizedBox(height: 8),
                        Text('Try changing filters or location', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= provider.videos.length) {
                        return const SizedBox(height: 80);
                      }
                      final video = provider.videos[index];
                      return VideoCard(
                        video: video,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDetailScreen(video: video),
                          ),
                        ),
                      );
                    },
                    childCount: provider.videos.length + 1,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBar(TrendingProvider provider) {
    final categories = ['All', 'Politics', 'Sports', 'Entertainment', 'Technology', 'News', 'Food', 'Travel', 'Business', 'Environment', 'Viral'];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final selected = provider.categoryFilter == cat;
          return GestureDetector(
            onTap: () => provider.setCategoryFilter(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(colors: [AppColors.primary, AppColors.accent])
                    : null,
                color: selected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? Colors.transparent : AppColors.divider,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlatformBar(TrendingProvider provider) {
    final platforms = SocialPlatform.values;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _PlatformFilterChip(
            label: 'All',
            selected: provider.platformFilter == null,
            color: AppColors.primary,
            onTap: () => provider.setPlatformFilter(null),
          ),
          ...platforms.map((p) => _PlatformFilterChip(
            label: p.name,
            selected: provider.platformFilter == p,
            color: p.color,
            onTap: () => provider.setPlatformFilter(provider.platformFilter == p ? null : p),
          )),
        ],
      ),
    );
  }

  Widget _buildSortBar(TrendingProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Text('Sort by:', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          ...SortMode.values.map((mode) {
            final selected = provider.sortMode == mode;
            return GestureDetector(
              onTap: () => provider.setSortMode(mode),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.divider,
                  ),
                ),
                child: Text(
                  _sortModeLabel(mode),
                  style: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsBar(TrendingProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCounter(
            value: '${provider.videos.length}',
            label: 'Videos',
            icon: Icons.video_library,
            color: AppColors.primary,
          ),
          _StatCounter(
            value: '${provider.topics.length}',
            label: 'Topics',
            icon: Icons.tag,
            color: AppColors.secondary,
          ),
          _StatCounter(
            value: '${provider.locationSpecificVideos.length}',
            label: 'Local',
            icon: Icons.location_on,
            color: AppColors.rising,
          ),
          if (provider.lastRefreshed != null)
            _StatCounter(
              value: _formatRefreshTime(provider.lastRefreshed!),
              label: 'Updated',
              icon: Icons.refresh,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }

  String _formatRefreshTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    return '${diff.inMinutes}m ago';
  }

  String _sortModeLabel(SortMode mode) {
    switch (mode) {
      case SortMode.trendScore: return '🔥 Trend';
      case SortMode.viewCount: return '👁 Views';
      case SortMode.likeCount: return '❤️ Likes';
      case SortMode.recent: return '🕐 Recent';
    }
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 320,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildError(TrendingProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.accent, size: 64),
          const SizedBox(height: 16),
          Text(provider.error ?? 'Error occurred', textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => provider.fetchTrending(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrendingProvider>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Filters', style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(
                onPressed: () { provider.clearFilters(); Navigator.pop(context); },
                child: const Text('Clear All', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Currently no additional filters', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _PlatformFilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppColors.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _StatCounter extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCounter({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
