// lib/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF03DAC6);
  static const accent = Color(0xFFFF6584);
  static const background = Color(0xFF0D0D1A);
  static const surface = Color(0xFF1A1A2E);
  static const card = Color(0xFF16213E);
  static const cardLight = Color(0xFF1F2B47);
  static const text = Color(0xFFF0F0F0);
  static const textSecondary = Color(0xFFB0B0C0);
  static const divider = Color(0xFF2A2A3E);
  static const trending = Color(0xFFFF4757);
  static const hot = Color(0xFFFF6B35);
  static const rising = Color(0xFF2ED573);
  static const viral = Color(0xFFECAD0B);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: Color(0xFFCF6679),
    ),
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardLight,
      selectedColor: AppColors.primary.withOpacity(0.3),
      labelStyle: const TextStyle(color: AppColors.text, fontSize: 12),
      side: const BorderSide(color: AppColors.divider),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
      bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 11),
      labelLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    dividerColor: AppColors.divider,
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}
