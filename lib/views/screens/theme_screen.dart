import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';
import '../widgets/theme_selector.dart';
import '../widgets/custom_widgets.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    
    return Scaffold(
      body: CustomBackgroundContainer(
        backgroundImage: themeController.getBackgroundImage(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedAppBar(
                title: AppConstants.themeSettings,
                showBackButton: false,
              ),
              Expanded(
                child: AnimationLimiter(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildThemeCard(themeController),
                          SizedBox(height: AppConstants.paddingLarge),
                          _buildAppearanceSettings(themeController),
                          SizedBox(height: AppConstants.paddingLarge),
                          _buildAboutSection(),
                        ],
                      ),
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
  
  Widget _buildThemeCard(ThemeController themeController) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      child: SlideAnimation(
        horizontalOffset: 50,
        child: FadeInAnimation(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema Seçimi',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingMedium),
                  ThemeSelector(
                    themes: themeController.availableThemes,
                    selectedThemeId: themeController.activeTheme.id,
                    onThemeSelected: (themeId) {
                      themeController.changeTheme(themeId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppearanceSettings(ThemeController themeController) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      child: SlideAnimation(
        horizontalOffset: 50,
        child: FadeInAnimation(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Görünüm Ayarları',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingMedium),
                  CustomSwitch(
                    label: AppConstants.useSystemTheme,
                    value: themeController.useSystemTheme,
                    onChanged: (value) {
                      themeController.toggleUseSystemTheme(value);
                    },
                    icon: Icons.sync,
                  ),
                  SizedBox(height: AppConstants.paddingMedium),
                  CustomSwitch(
                    label: AppConstants.darkMode,
                    value: themeController.isDarkMode,
                    onChanged: (value) {
                      // Eğer sistem teması aktifse ve ValueChanged<bool> sorun çıkarıyorsa
                      if (!themeController.useSystemTheme) {
                        themeController.toggleDarkMode(value);
                      }
                    },
                    icon: Icons.dark_mode,
                  ),
                  if (themeController.useSystemTheme) ...[
                    SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Sistem teması kullanılırken karanlık mod manuel olarak değiştirilemez.',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAboutSection() {
    return AnimationConfiguration.staggeredList(
      position: 2,
      child: SlideAnimation(
        horizontalOffset: 50,
        child: FadeInAnimation(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uygulama Hakkında',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingMedium),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('Sürüm'),
                    subtitle: Text('1.0.0'),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.code,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('Geliştirici'),
                    subtitle: Text('Geri Sayım Uygulaması Ekibi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}