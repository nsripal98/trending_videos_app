// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/trending_provider.dart';
import 'providers/location_provider.dart';
import 'constants/app_constants.dart';
import 'screens/home_screen.dart';
import 'screens/topics_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/location_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const TrendVaultApp());
}

class TrendVaultApp extends StatelessWidget {
  const TrendVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => TrendingProvider()),
      ],
      child: MaterialApp(
        title: 'TrendVault',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TopicsScreen(),
    const AnalyticsScreen(),
    const LocationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.trending_up, label: 'Trending', index: 0, currentIndex: _currentIndex, onTap: _setIndex),
                _NavItem(icon: Icons.tag, label: 'Topics', index: 1, currentIndex: _currentIndex, onTap: _setIndex),
                _NavItem(icon: Icons.auto_awesome, label: 'Insights', index: 2, currentIndex: _currentIndex, onTap: _setIndex),
                _NavItem(icon: Icons.location_on_outlined, label: 'Location', index: 3, currentIndex: _currentIndex, onTap: _setIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setIndex(int index) {
    setState(() => _currentIndex = index);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: selected
            ? BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
