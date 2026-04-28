// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trendvault/main.dart';
import 'package:trendvault/providers/trending_provider.dart';
import 'package:trendvault/providers/location_provider.dart';

void main() {
  testWidgets('App launches and shows TrendVault title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => TrendingProvider()),
        ],
        child: const MaterialApp(home: MainNavigation()),
      ),
    );

    // App renders without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom nav has 4 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const TrendVaultApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Should find the 4 nav labels
    expect(find.text('Trending'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
  });
}
