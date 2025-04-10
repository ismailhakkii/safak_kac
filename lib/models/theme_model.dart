import 'package:flutter/material.dart';

class ThemeModel {
  final String id;
  final String name;
  final ThemeData theme;
  final String backgroundAsset;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  ThemeModel({
    required this.id,
    required this.name,
    required this.theme,
    required this.backgroundAsset,
    required this.primaryColor,
    required this.secondaryColor,
    this.isDark = false,
  });

  // JSON veri dönüşümü için (sadece ID kaydediliyor)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}

class ThemePreferences {
  final String themeId;
  final bool useDarkMode;
  final bool useSystemTheme;

  ThemePreferences({
    required this.themeId,
    this.useDarkMode = false,
    this.useSystemTheme = true,
  });

  // JSON veri dönüşümü
  Map<String, dynamic> toMap() {
    return {
      'themeId': themeId,
      'useDarkMode': useDarkMode,
      'useSystemTheme': useSystemTheme,
    };
  }

  // JSON veriden oluşturma
  factory ThemePreferences.fromMap(Map<String, dynamic> map) {
    return ThemePreferences(
      themeId: map['themeId'] ?? 'purple',
      useDarkMode: map['useDarkMode'] ?? false,
      useSystemTheme: map['useSystemTheme'] ?? true,
    );
  }

  // Varsayılan tema tercihleri
  factory ThemePreferences.defaultPrefs() {
    return ThemePreferences(
      themeId: 'purple',
      useDarkMode: false,
      useSystemTheme: true,
    );
  }

  // Kopyasını oluşturma
  ThemePreferences copyWith({
    String? themeId,
    bool? useDarkMode,
    bool? useSystemTheme,
  }) {
    return ThemePreferences(
      themeId: themeId ?? this.themeId,
      useDarkMode: useDarkMode ?? this.useDarkMode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
    );
  }
}