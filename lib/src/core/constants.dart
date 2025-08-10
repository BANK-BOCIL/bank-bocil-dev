import 'package:flutter/material.dart';

enum ThemeColor {
  pink,
  blue,
  green,
  purple,
}

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Pink Theme (Original Tingkat 1)
  static const Color pinkPrimary = Color(0xFFFF6B9D);
  static const Color pinkSecondary = Color(0xFFFFE5F1);
  static const Color pinkAccent = Color(0xFFFF8FA3);

  // Blue Theme (Original Tingkat 3)
  static const Color bluePrimary = Color(0xFF3B82F6);
  static const Color blueSecondary = Color(0xFFEBF5FF);
  static const Color blueAccent = Color(0xFF60A5FA);

  // Green Theme (Original Tingkat 2)
  static const Color greenPrimary = Color(0xFF06D6A0);
  static const Color greenSecondary = Color(0xFFE8F8F5);
  static const Color greenAccent = Color(0xFF40E0D0);

  // Purple Theme (Original Parent)
  static const Color purplePrimary = Color(0xFF8B5CF6);
  static const Color purpleSecondary = Color(0xFFF3F0FF);
  static const Color purpleAccent = Color(0xFFA78BFA);

  // Age Tier Colors (maintain backward compatibility)
  static const Color tingkat1Primary = pinkPrimary;
  static const Color tingkat1Secondary = pinkSecondary;
  static const Color tingkat1Accent = pinkAccent;

  static const Color tingkat2Primary = greenPrimary;
  static const Color tingkat2Secondary = greenSecondary;
  static const Color tingkat2Accent = greenAccent;

  static const Color tingkat3Primary = bluePrimary;
  static const Color tingkat3Secondary = blueSecondary;
  static const Color tingkat3Accent = blueAccent;

  static const Color parentPrimary = purplePrimary;
  static const Color parentSecondary = purpleSecondary;
  static const Color parentAccent = purpleAccent;

  // Dynamic theme colors based on selected theme
  static Color getCurrentPrimary(ThemeColor theme) {
    switch (theme) {
      case ThemeColor.pink:
        return pinkPrimary;
      case ThemeColor.blue:
        return bluePrimary;
      case ThemeColor.green:
        return greenPrimary;
      case ThemeColor.purple:
        return purplePrimary;
    }
  }

  static Color getCurrentSecondary(ThemeColor theme) {
    switch (theme) {
      case ThemeColor.pink:
        return pinkSecondary;
      case ThemeColor.blue:
        return blueSecondary;
      case ThemeColor.green:
        return greenSecondary;
      case ThemeColor.purple:
        return purpleSecondary;
    }
  }

  static Color getCurrentAccent(ThemeColor theme) {
    switch (theme) {
      case ThemeColor.pink:
        return pinkAccent;
      case ThemeColor.blue:
        return blueAccent;
      case ThemeColor.green:
        return greenAccent;
      case ThemeColor.purple:
        return purpleAccent;
    }
  }

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
}

class AppConstants {
  // App Information
  static const String appName = 'NabungYuk';
  static const String appVersion = '1.0.0';

  // Age Ranges
  static const int tingkat1MinAge = 6;
  static const int tingkat1MaxAge = 9;
  static const int tingkat2MinAge = 10;
  static const int tingkat2MaxAge = 12;
  static const int tingkat3MinAge = 13;
  static const int tingkat3MaxAge = 17;

  // Transaction Limits
  static const double tingkat1MaxTransaction = 50000; // 50k IDR
  static const double tingkat2MaxTransaction = 100000; // 100k IDR
  static const double tingkat3MaxTransaction = 500000; // 500k IDR

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Categories for Tingkat 2 & 3
  static const List<String> expenseCategories = [
    'Makanan & Minuman',
    'Mainan & Hobi',
    'Buku & Alat Tulis',
    'Pakaian',
    'Transportasi',
    'Hiburan',
    'Lainnya',
  ];

  // Mission Icons
  static const Map<String, String> missionIcons = {
    'cleaning': '🧹',
    'homework': '📚',
    'exercise': '🏃',
    'help': '🤝',
    'reading': '📖',
    'organize': '📦',
    'default': '⭐',
  };

  // Savings Goal Icons
  static const Map<String, String> goalIcons = {
    'toys': '🧸',
    'robot': '🤖',
    'car': '�',
    'bike': '🚲',
    'ball': '⚽',
    'book': '�',
    'game': '🎮',
    'laptop': '💻',
    'phone': '📱',
    'clothes': '👕',
    'shoes': '👟',
    'bag': '🎒',
    'watch': '⌚',
    'travel': '✈️',
    'food': '🍕',
    'ice_cream': '🍦',
    'cake': '🎂',
    'music': '🎵',
    'art': '🎨',
    'education': '🎓',
    'gift': '🎁',
    'star': '⭐',
    'heart': '💝',
    'default': '🎯',
  };

  // Theme Options
  static const List<Map<String, dynamic>> themeOptions = [
    {
      'name': 'Pink',
      'emoji': '💗',
      'theme': ThemeColor.pink,
      'description': 'Warna pink yang manis'
    },
    {
      'name': 'Biru',
      'emoji': '🤖',
      'theme': ThemeColor.blue,
      'description': 'Warna biru yang tenang'
    },
    {
      'name': 'Hijau',
      'emoji': '🌲',
      'theme': ThemeColor.green,
      'description': 'Warna hijau yang segar'
    },
    {
      'name': 'Ungu',
      'emoji': '🦄',
      'theme': ThemeColor.purple,
      'description': 'Warna ungu yang elegan'
    },
  ];
}
