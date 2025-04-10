import 'package:flutter/material.dart';

class AppConstants {
  // Uygulama adı
  static const String appName = 'Geri Sayım Uygulaması';
  
  // Varsayılan geçiş süresi
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Yüksek animasyon süresi
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // Renk sabitleri
  static const Color primaryColor = Color(0xFF7E57C2);
  static const Color secondaryColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color textColor = Color(0xFF212121);
  static const Color textLightColor = Color(0xFF757575);
  
  // Konfeti renkleri
  static const List<Color> confettiColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];
  
  // Tema renk seçenekleri
  static const List<Color> themeColorOptions = [
    Color(0xFF7E57C2), // Mor
    Color(0xFF2196F3), // Mavi
    Color(0xFF4CAF50), // Yeşil
    Color(0xFFFF9800), // Turuncu
    Color(0xFFF44336), // Kırmızı
    Color(0xFF009688), // Turkuaz
  ];
  
  // Metinler
  static const String countdownCompletedTitle = 'Geri Sayım Tamamlandı!';
  static const String countdownCompletedMessage = 'zamanı geldi!';
  static const String noEventName = 'Hedef zamanına ulaşıldı!';
  static const String createNewCountdown = 'Yeni Geri Sayım Oluştur';
  static const String eventNameHint = 'Örn: Doğum Günü, Tatil, Toplantı...';
  static const String eventNameLabel = 'Etkinlik Adı';
  static const String targetDateLabel = 'Hedef Tarih';
  static const String noDateSelected = 'Henüz seçilmedi';
  static const String remainingTime = 'Kalan Süre';
  static const String day = 'GÜN';
  static const String hour = 'SAAT';
  static const String minute = 'DAKİKA';
  static const String second = 'SANİYE';
  static const String start = 'Başlat';
  static const String pause = 'Durdur';
  static const String reset = 'Sıfırla';
  static const String selectDateTime = 'Tarih ve Saati Seç';
  static const String save = 'Kaydet';
  static const String cancel = 'İptal';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String settings = 'Ayarlar';
  static const String themeSettings = 'Tema Ayarları';
  static const String darkMode = 'Karanlık Mod';
  static const String useSystemTheme = 'Sistem Temasını Kullan';
  static const String selectTheme = 'Tema Seç';
  static const String myCountdowns = 'Geri Sayımlarım';
  static const String noCountdowns = 'Henüz geri sayım eklenmemiş';
  static const String addFirstCountdown = 'İlk geri sayımınızı ekleyin';
  
  // Simge boyutları
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Yazı tipi boyutları
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  
  // Kenar boşlukları
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Kenarlık yarıçapları
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  
  // Buton boyutları
  static const double buttonHeight = 56.0;
  
  // Bottom Navigation Bar yüksekliği
  static const double bottomNavBarHeight = 60.0;
}