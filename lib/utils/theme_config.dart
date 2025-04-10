import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class ThemeConfig {
  // Tüm temaları al
  static Map<String, ThemeModel> getAllThemes() {
    return {
      'purple': _getPurpleTheme(),
      'blue': _getBlueTheme(),
      'green': _getGreenTheme(),
      'orange': _getOrangeTheme(),
      'red': _getRedTheme(),
      'teal': _getTealTheme(),
    };
  }

  // Mor Tema
  static ThemeModel _getPurpleTheme() {
    return ThemeModel(
      id: 'purple',
      name: 'Mor',
      primaryColor: Color(0xFF7E57C2),
      secondaryColor: Color(0xFFFF9800),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7E57C2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF7E57C2),
          primary: Color(0xFF7E57C2),
          secondary: Color(0xFFFF9800),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF7E57C2),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Mavi Tema
  static ThemeModel _getBlueTheme() {
    return ThemeModel(
      id: 'blue',
      name: 'Mavi',
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFFFF5722),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2196F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2196F3),
          primary: Color(0xFF2196F3),
          secondary: Color(0xFFFF5722),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Yeşil Tema
  static ThemeModel _getGreenTheme() {
    return ThemeModel(
      id: 'green',
      name: 'Yeşil',
      primaryColor: Color(0xFF4CAF50),
      secondaryColor: Color(0xFFE91E63),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4CAF50),
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFFE91E63),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Turuncu Tema
  static ThemeModel _getOrangeTheme() {
    return ThemeModel(
      id: 'orange',
      name: 'Turuncu',
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFF673AB7),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFF9800),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFF9800),
          primary: Color(0xFFFF9800),
          secondary: Color(0xFF673AB7),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF9800),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Kırmızı Tema
  static ThemeModel _getRedTheme() {
    return ThemeModel(
      id: 'red',
      name: 'Kırmızı',
      primaryColor: Color(0xFFF44336),
      secondaryColor: Color(0xFF00BCD4),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFFF44336),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF44336),
          primary: Color(0xFFF44336),
          secondary: Color(0xFF00BCD4),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF44336),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Turkuaz Tema
  static ThemeModel _getTealTheme() {
    return ThemeModel(
      id: 'teal',
      name: 'Turkuaz',
      primaryColor: Color(0xFF009688),
      secondaryColor: Color(0xFFFFC107),
      backgroundAsset: 'assets/images/background.png',
      isDark: false,
      theme: ThemeData(
        primaryColor: Color(0xFF009688),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF009688),
          primary: Color(0xFF009688),
          secondary: Color(0xFFFFC107),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF009688),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}