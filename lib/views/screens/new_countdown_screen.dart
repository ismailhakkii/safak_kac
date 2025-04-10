import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/countdown_model.dart';
import '../../controllers/countdown_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';
import '../../utils/date_utils.dart';
import '../widgets/theme_selector.dart';
import '../widgets/custom_widgets.dart';

class NewCountdownScreen extends StatefulWidget {
  final String? countdownId;

  const NewCountdownScreen({
    Key? key,
    this.countdownId,
  }) : super(key: key);

  @override
  _NewCountdownScreenState createState() => _NewCountdownScreenState();
}

class _NewCountdownScreenState extends State<NewCountdownScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  DateTime? _selectedDateTime;
  String _selectedThemeColor = 'purple';
  bool _isEditMode = false;
  CountdownModel? _existingCountdown;
  
  // Form doğrulama
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    // Eğer düzenleme modundaysa, mevcut geri sayımı yükle
    if (widget.countdownId != null) {
      _isEditMode = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingCountdown();
      });
    }
  }
  
  @override
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }
  
  Future<void> _loadExistingCountdown() async {
    final countdownController = Provider.of<CountdownController>(context, listen: false);
    
    // ID'ye göre geri sayımı bul
    final countdown = countdownController.countdowns.firstWhere(
      (c) => c.id == widget.countdownId,
      orElse: () => null as CountdownModel,
    );
    
    if (countdown != null) {
      setState(() {
        _existingCountdown = countdown;
        _eventNameController.text = countdown.eventName;
        _selectedDateTime = countdown.targetDateTime;
        _selectedThemeColor = countdown.themeColor;
      });
    }
  }
  
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null 
          ? TimeOfDay.fromDateTime(_selectedDateTime!) 
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final DateTime now = DateTime.now();
    final DateTime selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Geçmiş tarih kontrolü
    if (selected.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Geçmiş bir tarih seçilemez. Lütfen gelecek bir tarih seçin.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _selectedDateTime = selected;
    });
  }
  
  void _saveCountdown() {
    if (_formKey.currentState?.validate() ?? false) {
      final countdownController = Provider.of<CountdownController>(context, listen: false);
      final navigationController = Provider.of<NavigationController>(context, listen: false);
      
      if (_isEditMode && _existingCountdown != null) {
        // Mevcut geri sayımı güncelle
        final updatedCountdown = _existingCountdown!.copyWith(
          eventName: _eventNameController.text.trim(),
          targetDateTime: _selectedDateTime!,
          themeColor: _selectedThemeColor,
        );
        
        countdownController.updateCountdown(updatedCountdown);
      } else {
        // Yeni geri sayım oluştur
        final newCountdown = CountdownModel(
          eventName: _eventNameController.text.trim(),
          targetDateTime: _selectedDateTime!,
          themeColor: _selectedThemeColor,
        );
        
        countdownController.addCountdown(newCountdown);
      }
      
      // Ana ekrana dön
      navigationController.navigateTo(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    
    return Scaffold(
      body: CustomBackgroundContainer(
        backgroundImage: themeController.getBackgroundImage(),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedAppBar(
                title: _isEditMode ? 'Geri Sayımı Düzenle' : AppConstants.createNewCountdown,
                onBackPressed: () {
                  final navigationController = Provider.of<NavigationController>(context, listen: false);
                  navigationController.navigateTo(AppRoute.home);
                },
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEventNameField(),
                        SizedBox(height: AppConstants.paddingLarge),
                        _buildDateTimeSelector(),
                        SizedBox(height: AppConstants.paddingLarge),
                        _buildThemeColorSelector(),
                        SizedBox(height: AppConstants.paddingLarge * 2),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEventNameField() {
    return FadeInDown(
      duration: AppConstants.defaultAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.eventNameLabel,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppConstants.paddingSmall),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                hintText: AppConstants.eventNameHint,
                prefixIcon: Icon(Icons.event),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen bir etkinlik adı girin';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateTimeSelector() {
    return FadeInDown(
      delay: Duration(milliseconds: 100),
      duration: AppConstants.defaultAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.targetDateLabel,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppConstants.paddingSmall),
          GestureDetector(
            onTap: _selectDateTime,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Text(
                      _selectedDateTime != null
                          ? DateTimeUtils.formatDateTime(_selectedDateTime!)
                          : AppConstants.noDateSelected,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: _selectedDateTime != null
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: AppConstants.iconSizeSmall,
                  ),
                ],
              ),
            ),
          ),
          if (_selectedDateTime == null)
            Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.paddingMedium,
                top: AppConstants.paddingSmall,
              ),
              child: Text(
                'Lütfen bir tarih ve saat seçin',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildThemeColorSelector() {
    return FadeInDown(
      delay: Duration(milliseconds: 200),
      duration: AppConstants.defaultAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Renk Seçimi',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppConstants.paddingMedium),
          Center(
            child: ColorSelector(
              colors: [
                Color(0xFF7E57C2), // purple
                Color(0xFF2196F3), // blue
                Color(0xFF4CAF50), // green
                Color(0xFFFF9800), // orange
                Color(0xFFF44336), // red
                Color(0xFF009688), // teal
              ],
              selectedColor: _getColorFromTheme(_selectedThemeColor),
              onColorSelected: (color) {
                setState(() {
                  _selectedThemeColor = _getThemeFromColor(color);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorFromTheme(String themeId) {
    switch (themeId) {
      case 'blue':
        return Color(0xFF2196F3);
      case 'green':
        return Color(0xFF4CAF50);
      case 'orange':
        return Color(0xFFFF9800);
      case 'red':
        return Color(0xFFF44336);
      case 'teal':
        return Color(0xFF009688);
      case 'purple':
      default:
        return Color(0xFF7E57C2);
    }
  }
  
  String _getThemeFromColor(Color color) {
    if (color == Color(0xFF2196F3)) return 'blue';
    if (color == Color(0xFF4CAF50)) return 'green';
    if (color == Color(0xFFFF9800)) return 'orange';
    if (color == Color(0xFFF44336)) return 'red';
    if (color == Color(0xFF009688)) return 'teal';
    return 'purple';
  }
  
  Widget _buildSaveButton() {
    return FadeInUp(
      delay: Duration(milliseconds: 300),
      duration: AppConstants.defaultAnimationDuration,
      child: Center(
        child: CountdownButton(
          icon: Icons.save,
          label: 'Kaydet',
          onPressed: () {
            // Tarih seçilmemiş ise hata göster
            if (_selectedDateTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lütfen bir tarih ve saat seçin'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            
            // Kaydet
            _saveCountdown();
          },
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          isFullWidth: true,
        ),
      ),
    );
  }
}