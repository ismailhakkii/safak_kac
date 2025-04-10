import 'package:intl/intl.dart';

class DateTimeUtils {
  // İki basamaklı sayı formatı
  static String twoDigits(int n) => n.toString().padLeft(2, '0');
  
  // Süreyi formatla (1g 12s 30d 45sn)
  static String formatDurationShort(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    
    return '${duration.inDays}g ${twoDigitHours}s ${twoDigitMinutes}d ${twoDigitSeconds}sn';
  }
  
  // Süreyi uzun formatta formatla (1 gün 12 saat 30 dakika 45 saniye)
  static String formatDurationLong(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    
    return '${duration.inDays} gün ${twoDigitHours} saat ${twoDigitMinutes} dakika ${twoDigitSeconds} saniye';
  }
  
  // Tarihi formatla (15 Nisan 2023 14:30)
  static String formatDateTime(DateTime dateTime, {String locale = 'tr_TR'}) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', locale);
    return '${dateFormat.format(dateTime)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }
  
  // Tarihi kısa formatla (15 Nis 14:30)
  static String formatDateTimeShort(DateTime dateTime, {String locale = 'tr_TR'}) {
    DateFormat dateFormat = DateFormat('dd MMM', locale);
    return '${dateFormat.format(dateTime)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }
  
  // Kaç gün kaldığını hesapla
  static int daysUntil(DateTime targetDate) {
    final now = DateTime.now();
    
    if (targetDate.isBefore(now)) {
      return 0;
    }
    
    return targetDate.difference(now).inDays;
  }
  
  // İleri bir tarih olup olmadığını kontrol et
  static bool isFutureDate(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now);
  }
  
  // Bugünün tarihi olup olmadığını kontrol et
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  // Yarının tarihi olup olmadığını kontrol et
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }
  
  // Bu haftanın tarihi olup olmadığını kontrol et
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final endOfWeek = DateTime(now.year, now.month, now.day + (7 - now.weekday));
    return date.isBefore(endOfWeek) && date.isAfter(now);
  }
  
  // "Şimdi", "Bugün", "Yarın" gibi göreceli tarih metinleri
  static String getRelativeDateString(DateTime date, {String locale = 'tr_TR'}) {
    if (isToday(date)) {
      return 'Bugün, ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
    } else if (isTomorrow(date)) {
      return 'Yarın, ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
    } else if (isThisWeek(date)) {
      DateFormat weekdayFormat = DateFormat('EEEE', locale);
      return '${weekdayFormat.format(date)}, ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
    } else {
      return formatDateTime(date, locale: locale);
    }
  }
}