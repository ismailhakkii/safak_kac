import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model ve Ekran importları
import 'views/screens/countdown_screen.dart';

void main() async {
  // Flutter bağlamının başlatıldığından emin ol
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ekran yönünü dikey olarak kilitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Türkçe tarih formatını başlat
  await initializeDateFormatting('tr_TR', null);
  
  // SharedPreferences'ın hazır olduğundan emin ol
  await SharedPreferences.getInstance();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geri Sayım Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7E57C2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF7E57C2),
          primary: Color(0xFF7E57C2),
          secondary: Color(0xFFFF9800),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Buton teması
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Kart teması
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // AppBar teması
        appBarTheme: AppBarTheme(
          elevation: 1,
          backgroundColor: Color(0xFF7E57C2),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
        const Locale('en', 'US'),
      ],
      locale: const Locale('tr', 'TR'),
      home: CountdownScreen(),
    );
  }
}