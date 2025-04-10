import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/theme_model.dart';
import '../models/database_helper.dart';
import '../utils/theme_config.dart';

class ThemeController with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  
  // Tema koleksiyonu
  final Map<String, ThemeModel> _themes = {};
  
  // Aktif tema
  late ThemeModel _activeTheme;
  
  // Tema tercihleri
  late ThemePreferences _preferences;
  
  // Getters
  ThemeModel get activeTheme => _activeTheme;
  List<ThemeModel> get availableThemes => _themes.values.toList();
  ThemePreferences get preferences => _preferences;
  bool get isDarkMode => _preferences.useDarkMode;
  bool get useSystemTheme => _preferences.useSystemTheme;
  
  // Başlangıç ayarları
  Future<void> initialize() async {
    // Tema koleksiyonunu oluştur
    _initThemes();
    
    // Kaydedilmiş tema tercihlerini yükle
    _preferences = await _db.getThemePreferences();
    
    // Aktif temayı ayarla
    _setActiveTheme();
    
    notifyListeners();
  }
  
  // Tema koleksiyonunu oluşturma
  void _initThemes() {
    _themes.addAll(ThemeConfig.getAllThemes());
  }
  
  // Aktif temayı ayarlama
  void _setActiveTheme() {
    // Tema ID'si ile tema bulma
    if (_themes.containsKey(_preferences.themeId)) {
      _activeTheme = _themes[_preferences.themeId]!;
    } else {
      // Varsayılan tema
      _activeTheme = _themes['purple']!;
    }
    
    // Sistem teması kontrolü
    if (_preferences.useSystemTheme) {
      final platformBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      final isDark = platformBrightness == Brightness.dark;
      
      if (isDark != _preferences.useDarkMode) {
        _preferences = _preferences.copyWith(useDarkMode: isDark);
      }
    }
  }
  
  // Tema değiştirme
  Future<void> changeTheme(String themeId) async {
    if (_themes.containsKey(themeId)) {
      _preferences = _preferences.copyWith(themeId: themeId);
      _setActiveTheme();
      await _savePreferences();
      notifyListeners();
    }
  }
  
  // Karanlık mod değiştirme
  Future<void> toggleDarkMode(bool value) async {
    if (_preferences.useSystemTheme) {
      _preferences = _preferences.copyWith(useSystemTheme: false);
    }
    
    _preferences = _preferences.copyWith(useDarkMode: value);
    _setActiveTheme();
    await _savePreferences();
    notifyListeners();
  }
  
  // Sistem teması kullanımını değiştirme
  Future<void> toggleUseSystemTheme(bool value) async {
    _preferences = _preferences.copyWith(useSystemTheme: value);
    _setActiveTheme();
    await _savePreferences();
    notifyListeners();
  }
  
  // Tema tercihlerini kaydetme
  Future<void> _savePreferences() async {
    await _db.saveThemePreferences(_preferences);
  }
  
  // Tema rengini al
  ThemeData getCurrentTheme() {
    if (_preferences.useDarkMode) {
      return _activeTheme.theme.copyWith(brightness: Brightness.dark);
    } else {
      return _activeTheme.theme.copyWith(brightness: Brightness.light);
    }
  }
  
  // Tema arka plan resmi
  String getBackgroundImage() {
    return _activeTheme.backgroundAsset;
  }
}