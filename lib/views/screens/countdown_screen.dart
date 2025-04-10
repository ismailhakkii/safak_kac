import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/countdown_model.dart';
import '../widgets/countdown_list.dart';

class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with SingleTickerProviderStateMixin {
  List<CountdownModel> _countdowns = [];
  CountdownModel? _selectedCountdown;
  Timer? _countdownTimer;
  Duration _remainingTime = Duration.zero;
  bool _isCountdownActive = false;
  TextEditingController _eventController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showAddForm = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadCountdowns();
  }
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _eventController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCountdowns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countdownsJson = prefs.getStringList('countdowns') ?? [];
      
      setState(() {
        _countdowns = countdownsJson
            .map((json) => CountdownModel.fromMap(jsonDecode(json)))
            .toList();
        
        // En son eklenen veya aktif olan bir geri sayımı seç
        if (_countdowns.isNotEmpty) {
          final activeCountdown = _countdowns.firstWhere(
            (c) => c.isActive, 
            orElse: () => _countdowns.first
          );
          _selectCountdown(activeCountdown);
        }
      });
    } catch (e) {
      print('Error loading countdowns: $e');
    }
  }
  
  Future<void> _saveCountdowns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countdownsJson = _countdowns
          .map((countdown) => jsonEncode(countdown.toMap()))
          .toList();
      
      await prefs.setStringList('countdowns', countdownsJson);
    } catch (e) {
      print('Error saving countdowns: $e');
    }
  }
  
  void _selectCountdown(CountdownModel countdown) {
    setState(() {
      _selectedCountdown = countdown;
      _remainingTime = countdown.getRemainingTime();
      _isCountdownActive = countdown.isActive;
      
      if (_isCountdownActive) {
        _startCountdown();
      }
    });
  }
  
  void _addCountdown(CountdownModel countdown) {
    setState(() {
      _countdowns.add(countdown);
      _selectedCountdown = countdown;
      _remainingTime = countdown.getRemainingTime();
      _showAddForm = false;
    });
    
    _saveCountdowns();
  }
  
  void _deleteCountdown(CountdownModel countdown) {
    setState(() {
      _countdowns.removeWhere((c) => c.id == countdown.id);
      
      if (_selectedCountdown?.id == countdown.id) {
        _selectedCountdown = _countdowns.isNotEmpty ? _countdowns.first : null;
        _remainingTime = _selectedCountdown?.getRemainingTime() ?? Duration.zero;
        _isCountdownActive = false;
      }
    });
    
    _saveCountdowns();
  }
  
  void _startCountdown() {
    if (_selectedCountdown == null) return;
    
    _countdownTimer?.cancel();
    
    setState(() {
      _isCountdownActive = true;
      
      // Model'i de güncelle
      if (_selectedCountdown != null) {
        final index = _countdowns.indexWhere((c) => c.id == _selectedCountdown!.id);
        if (index >= 0) {
          _countdowns[index] = _selectedCountdown!.copyWith(isActive: true);
          _saveCountdowns();
        }
      }
    });
    
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_selectedCountdown == null) {
        timer.cancel();
        return;
      }
      
      final now = DateTime.now();
      
      if (_selectedCountdown!.targetDateTime.isBefore(now)) {
        setState(() {
          _remainingTime = Duration.zero;
          _isCountdownActive = false;
          
          // Tamamlandı olarak işaretle
          final index = _countdowns.indexWhere((c) => c.id == _selectedCountdown!.id);
          if (index >= 0) {
            _countdowns[index] = _selectedCountdown!.copyWith(
              isActive: false,
              isCompleted: true,
            );
            _selectedCountdown = _countdowns[index];
            _saveCountdowns();
          }
        });
        
        timer.cancel();
        _showCompletionDialog();
      } else {
        setState(() {
          _remainingTime = _selectedCountdown!.targetDateTime.difference(now);
        });
      }
    });
  }
  
  void _stopCountdown() {
    _countdownTimer?.cancel();
    
    setState(() {
      _isCountdownActive = false;
      
      // Model'i de güncelle
      if (_selectedCountdown != null) {
        final index = _countdowns.indexWhere((c) => c.id == _selectedCountdown!.id);
        if (index >= 0) {
          _countdowns[index] = _selectedCountdown!.copyWith(isActive: false);
          _selectedCountdown = _countdowns[index];
          _saveCountdowns();
        }
      }
    });
  }
  
  void _showCompletionDialog() {
    if (_selectedCountdown == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 10),
            Text('Geri Sayım Tamamlandı!'),
          ],
        ),
        content: Text(
          _selectedCountdown!.eventName.isNotEmpty 
            ? '"${_selectedCountdown!.eventName}" zamanı geldi!' 
            : 'Hedef zamanına ulaşıldı!',
        ),
        actions: [
          TextButton(
            child: Text('Tamam'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  
  void _toggleAddForm() {
    setState(() {
      _showAddForm = !_showAddForm;
    });
    
    if (_showAddForm) {
      _eventController.clear();
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  
  Future<void> _createNewCountdown() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final DateTime targetDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
      
    if (_eventController.text.trim().isEmpty) {
      // Etkinlik adı boşsa kullanıcıdan iste
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Etkinlik Adı'),
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(
              hintText: 'Örn: Doğum Günü, Tatil, Toplantı...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                final newCountdown = CountdownModel(
                  eventName: _eventController.text.trim(),
                  targetDateTime: targetDateTime,
                );
                
                _addCountdown(newCountdown);
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      );
    } else {
      // Etkinlik adı zaten varsa direkt ekle
      final newCountdown = CountdownModel(
        eventName: _eventController.text.trim(),
        targetDateTime: targetDateTime,
      );
      
      _addCountdown(newCountdown);
    }
  }
  
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inDays} gün ${twoDigits(duration.inHours.remainder(24))} saat $twoDigitMinutes dakika $twoDigitSeconds saniye';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geri Sayım Uygulaması'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                _showAddForm ? Icons.close : Icons.add,
                key: ValueKey<bool>(_showAddForm),
              ),
            ),
            onPressed: _toggleAddForm,
            tooltip: _showAddForm ? 'İptal' : 'Yeni Geri Sayım',
          ),
        ],
      ),
      body: Column(
        children: [
          // Yeni geri sayım ekleme formu
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: _showAddForm 
                ? _buildAddForm() 
                : SizedBox.shrink(),
          ),
          
          // Aktif geri sayım gösterimi
          if (_selectedCountdown != null && !_showAddForm)
            _buildCurrentCountdown(),
          
          // Tüm geri sayımlar listesi
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Geri Sayımlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CountdownList(
                      countdowns: _countdowns,
                      onCountdownSelected: _selectCountdown,
                      onCountdownDeleted: _deleteCountdown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddForm() {
    return SizeTransition(
      sizeFactor: _animation,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yeni Geri Sayım Ekle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  labelText: 'Etkinlik Adı',
                  hintText: 'Örn: Doğum Günü, Tatil, Toplantı...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today),
                  label: Text('Tarih ve Saati Seç'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _createNewCountdown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentCountdown() {
    if (_selectedCountdown == null) return SizedBox.shrink();
    
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedCountdown!.eventName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Kalan Süre:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatDuration(_remainingTime),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isCountdownActive ? Icons.pause : Icons.play_arrow),
                  label: Text(_isCountdownActive ? 'Durdur' : 'Başlat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCountdownActive ? Colors.orange : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isCountdownActive 
                      ? _stopCountdown 
                      : _startCountdown,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}