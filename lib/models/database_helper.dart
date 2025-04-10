import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'countdown_model.dart';
import 'theme_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'countdown_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE countdowns(
        id TEXT PRIMARY KEY,
        eventName TEXT,
        targetDateTime INTEGER,
        isActive INTEGER,
        notificationId TEXT,
        themeColor TEXT,
        isCompleted INTEGER,
        createdAt INTEGER
      )
    ''');
  }

  // Geri sayım kaydetme
  Future<void> saveCountdown(CountdownModel countdown) async {
    final db = await database;
    await db.insert(
      'countdowns',
      countdown.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Geri sayım güncelleme
  Future<void> updateCountdown(CountdownModel countdown) async {
    final db = await database;
    await db.update(
      'countdowns',
      countdown.toMap(),
      where: 'id = ?',
      whereArgs: [countdown.id],
    );
  }

  // Geri sayım silme
  Future<void> deleteCountdown(String id) async {
    final db = await database;
    await db.delete(
      'countdowns',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tüm geri sayımları getirme
  Future<List<CountdownModel>> getAllCountdowns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('countdowns');
    
    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
  }

  // Tek bir geri sayımı getirme
  Future<CountdownModel?> getCountdown(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return CountdownModel.fromMap(maps.first);
    }
    return null;
  }

  // Aktif geri sayımları getirme
  Future<List<CountdownModel>> getActiveCountdowns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'isActive = ? AND isCompleted = ?',
      whereArgs: [1, 0],
    );
    
    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
  }

  // Tema tercihlerini kaydetme
  Future<void> saveThemePreferences(ThemePreferences prefs) async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('themeId', prefs.themeId);
      await sp.setBool('useDarkMode', prefs.useDarkMode);
      await sp.setBool('useSystemTheme', prefs.useSystemTheme);
    } catch (e) {
      print('Error saving theme preferences: $e');
    }
  }

  // Tema tercihlerini getirme
  Future<ThemePreferences> getThemePreferences() async {
    try {
      // Bu kısmı düzelttim - önce yerel değişken oluşturup sonra kullan
      final prefs = await SharedPreferences.getInstance();
      
      final String themeId = prefs.getString('themeId') ?? 'purple';
      final bool useDarkMode = prefs.getBool('useDarkMode') ?? false;
      final bool useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
      
      return ThemePreferences(
        themeId: themeId,
        useDarkMode: useDarkMode,
        useSystemTheme: useSystemTheme,
      );
    } catch (e) {
      print('Error retrieving theme preferences: $e');
      // Hata durumunda varsayılan tercihleri döndür
      return ThemePreferences.defaultPrefs();
    }
  }
}