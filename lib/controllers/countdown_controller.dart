import 'dart:async';
import 'package:flutter/material.dart';
import '../models/countdown_model.dart';
import '../models/database_helper.dart';

class CountdownController with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<CountdownModel> _countdowns = [];
  List<CountdownModel> _activeCountdowns = [];
  Map<String, Timer?> _timers = {};
  CountdownModel? _currentCountdown;

  // Getters
  List<CountdownModel> get countdowns => _countdowns;
  List<CountdownModel> get activeCountdowns => _activeCountdowns;
  CountdownModel? get currentCountdown => _currentCountdown;

  // Başlangıçta tüm geri sayımları yükle
  Future<void> loadAllCountdowns() async {
    _countdowns = await _db.getAllCountdowns();
    _activeCountdowns = await _db.getActiveCountdowns();
    
    // Aktif sayaçları başlat
    for (var countdown in _activeCountdowns) {
      startCountdownTimer(countdown.id);
    }
    
    notifyListeners();
  }

  // Yeni geri sayım ekleme
  Future<void> addCountdown(CountdownModel countdown) async {
    await _db.saveCountdown(countdown);
    await loadAllCountdowns();
  }

  // Geri sayım güncelleme
  Future<void> updateCountdown(CountdownModel countdown) async {
    await _db.updateCountdown(countdown);
    
    // Aktif zamanlayıcıyı güncelle
    if (_timers.containsKey(countdown.id)) {
      _timers[countdown.id]?.cancel();
      if (countdown.isActive && !countdown.isCompleted) {
        startCountdownTimer(countdown.id);
      }
    }
    
    await loadAllCountdowns();
  }

  // Geri sayım silme
  Future<void> deleteCountdown(String id) async {
    // Varsa zamanlayıcıyı durdur
    if (_timers.containsKey(id)) {
      _timers[id]?.cancel();
      _timers.remove(id);
    }
    
    await _db.deleteCountdown(id);
    await loadAllCountdowns();
  }

  // Geri sayım zamanlayıcısını başlatma
  void startCountdownTimer(String id) async {
    // Varsa zamanlayıcıyı durdur
    if (_timers.containsKey(id)) {
      _timers[id]?.cancel();
    }
    
    // Geri sayımı bul
    final countdown = await _db.getCountdown(id);
    if (countdown == null) return;
    
    // Geri sayım zaten tamamlanmışsa
    if (countdown.checkIfCompleted()) {
      final updatedCountdown = countdown.copyWith(
        isCompleted: true,
        isActive: false,
      );
      await _db.updateCountdown(updatedCountdown);
      notifyListeners();
      return;
    }
    
    // Zamanlayıcıyı başlat
    _timers[id] = Timer.periodic(Duration(seconds: 1), (timer) async {
      final currentCountdown = await _db.getCountdown(id);
      if (currentCountdown == null) {
        timer.cancel();
        return;
      }
      
      // Geri sayım tamamlandı mı kontrol et
      if (currentCountdown.checkIfCompleted() && !currentCountdown.isCompleted) {
        final updatedCountdown = currentCountdown.copyWith(
          isCompleted: true,
          isActive: false,
        );
        await _db.updateCountdown(updatedCountdown);
        timer.cancel();
        _timers.remove(id);
        
        // Eğer bu, şu anda görüntülenen geri sayım ise bildirimi gönder
        if (_currentCountdown?.id == id) {
          notifyCountdownCompleted(updatedCountdown);
        }
        
        await loadAllCountdowns();
      }
    });
    
    // Geri sayımı aktif olarak işaretle ve kaydet
    final updatedCountdown = countdown.copyWith(isActive: true);
    await _db.updateCountdown(updatedCountdown);
    
    notifyListeners();
  }

  // Geri sayım zamanlayıcısını durdurma
  void stopCountdownTimer(String id) async {
    if (_timers.containsKey(id)) {
      _timers[id]?.cancel();
      _timers.remove(id);
      
      // Geri sayımı bul ve pasif olarak işaretle
      final countdown = await _db.getCountdown(id);
      if (countdown != null) {
        final updatedCountdown = countdown.copyWith(isActive: false);
        await _db.updateCountdown(updatedCountdown);
        await loadAllCountdowns();
      }
    }
  }

  // Şu anki görüntülenen geri sayımı ayarlama
  void setCurrentCountdown(CountdownModel? countdown) {
    _currentCountdown = countdown;
    notifyListeners();
  }

  // Geri sayım tamamlandı bildirimi
  void notifyCountdownCompleted(CountdownModel countdown) {
    // Bu bir callback olarak kullanılacak
    // Bu noktada UI'da tamamlanma dialogunu gösterecek bir şekilde düzenlenmeli
  }

  // Tüm zamanlayıcıları temizleme
  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer?.cancel();
    }
    _timers.clear();
    super.dispose();
  }
}