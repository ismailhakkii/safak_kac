# Geri Sayım Uygulaması

Önemli olaylar, etkinlikler veya tarihlere ne kadar süre kaldığını takip etmenizi sağlayan modern bir Flutter geri sayım uygulaması. Birden fazla geri sayımı yönetin, özelleştirilebilir temalar kullanın ve bildirimlerle hiçbir önemli anı kaçırmayın.

## 📱 Özellikler

- **Çoklu Geri Sayım**: Birden fazla etkinlik için geri sayım oluşturun ve yönetin
- **Özelleştirilebilir Temalar**: 8 farklı tema (aydınlık ve karanlık mod) ile uygulamanızı kişiselleştirin
- **Bildirimler**: Geri sayım tamamlandığında ve yaklaşan etkinlikler için bildirimler alın
- **Otomatik Kaydetme**: Tüm geri sayımlarınız ve ayarlarınız cihazda otomatik olarak kaydedilir
- **Sezgisel Arayüz**: Kullanımı kolay, modern ve şık kullanıcı arayüzü
- **Türkçe Dil Desteği**: Tamamen Türkçe olarak hazırlanmış arayüz

## 🛠️ Kurulum

### Ön Koşullar

- Flutter SDK (en az 3.7.2)
- Dart SDK
- Android Studio veya VS Code
- Git

### Kurulum Adımları

1. Projeyi klonlayın:
```bash
git clone https://github.com/kullaniciadi/geri_sayim_uygulamasi.git
cd geri_sayim_uygulamasi
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

### Android için Bildirimleri Yapılandırma

`android/app/src/main/AndroidManifest.xml` dosyasına aşağıdaki izinleri ekleyin:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

### iOS için Bildirimleri Yapılandırma

`ios/Runner/AppDelegate.swift` dosyasını açın ve aşağıdaki kodu ekleyin:

```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

## 📂 Proje Yapısı

```
lib/
  ├── models/               # Veri modelleri
  │   ├── countdown_model.dart
  │   └── theme_model.dart
  ├── providers/            # State yönetimi
  │   └── theme_provider.dart
  ├── services/             # Servisler
  │   └── notification_service.dart
  ├── views/                # UI bileşenleri
  │   ├── screens/          # Ekranlar
  │   │   └── countdown_screen.dart
  │   └── widgets/          # Yeniden kullanılabilir widget'lar
  │       ├── countdown_list.dart
  │       └── theme_selector.dart
  └── main.dart             # Uygulama girişi
```

## 📱 Nasıl Kullanılır

### Yeni Geri Sayım Ekleme

1. Ana ekranda sağ üst köşedeki "+" simgesine tıklayın
2. Etkinlik adını girin
3. "Tarih ve Saati Seç" butonuna tıklayın
4. İstediğiniz tarih ve saati seçin
5. Geri sayım otomatik olarak listeye eklenecektir

### Geri Sayımı Başlatma/Durdurma

- Seçili geri sayımı başlatmak için "Başlat" butonuna tıklayın
- Aktif bir geri sayımı durdurmak için "Durdur" butonuna tıklayın

### Tema Değiştirme

1. Ana ekranda sağ üst köşedeki renk paleti simgesine tıklayın
2. Listeden istediğiniz temayı seçin
3. Tema anında uygulanacak ve tercihiniz kaydedilecektir

### Bildirimler

- Geri sayım tamamlandığında bir bildirim alacaksınız
- Önemli etkinlikler için 1 gün ve 1 saat kala hatırlatıcılar alacaksınız
- Bildirimler, uygulama kapalı olduğunda bile çalışacaktır

## 🛠️ Kullanılan Teknolojiler

- **Flutter**: UI framework
- **Provider**: State yönetimi
- **SharedPreferences**: Yerel depolama
- **Flutter Local Notifications**: Bildirim sistemi
- **Intl**: Tarih ve saat formatlaması
- **UUID**: Benzersiz kimlikler
- **Animate_do & Flutter Staggered Animations**: Animasyonlar

## 📋 Yapılacaklar Listesi

- [ ] Kategoriler eklemek (İş, Kişisel, Tatil vb.)
- [ ] Widget desteği (Ana ekranda geri sayım widget'ı)
- [ ] İstatistikler ve geçmiş geri sayımlar
- [ ] Bulut senkronizasyonu
- [ ] Geri sayıma özel tema atama

## 📝 Lisans

Bu proje [MIT lisansı](LICENSE) altında lisanslanmıştır.

## 👨‍💻 Katkıda Bulunanlar

- [Katkıda Bulunanın Adı](https://github.com/kullaniciadi) - Geliştirici

## 📞 İletişim

Sorularınız veya önerileriniz için [e-posta adresiniz@example.com](mailto:e-posta adresiniz@example.com) adresine e-posta gönderebilirsiniz.
