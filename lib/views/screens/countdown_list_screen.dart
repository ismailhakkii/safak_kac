import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../controllers/countdown_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';
import '../widgets/countdown_card.dart';
import '../widgets/custom_widgets.dart';

// Filtreleme tipleri - Enum sınıfı dışarı çıkarıldı
enum FilterType {
  all,
  active,
  completed,
}

class CountdownListScreen extends StatefulWidget {
  const CountdownListScreen({Key? key}) : super(key: key);

  @override
  _CountdownListScreenState createState() => _CountdownListScreenState();
}

class _CountdownListScreenState extends State<CountdownListScreen> {
  FilterType _currentFilter = FilterType.all;
  
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final countdownController = Provider.of<CountdownController>(context);
    
    return Scaffold(
      body: CustomBackgroundContainer(
        backgroundImage: themeController.getBackgroundImage(),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedAppBar(
                title: AppConstants.myCountdowns,
                showBackButton: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final navigationController = Provider.of<NavigationController>(context, listen: false);
                      navigationController.navigateTo(AppRoute.newCountdown);
                    },
                    tooltip: AppConstants.createNewCountdown,
                  ),
                ],
              ),
              _buildFilterTabs(),
              Expanded(
                child: _buildCountdownList(countdownController),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilterTabs() {
    return Container(
      margin: EdgeInsets.all(AppConstants.paddingMedium),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Row(
        children: [
          _buildFilterTab(FilterType.all, 'Tümü'),
          _buildFilterTab(FilterType.active, 'Aktif'),
          _buildFilterTab(FilterType.completed, 'Tamamlanan'),
        ],
      ),
    );
  }
  
  Widget _buildFilterTab(FilterType type, String title) {
    final isSelected = _currentFilter == type;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentFilter = type;
          });
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCountdownList(CountdownController controller) {
    // Filtreye göre geri sayımları filtrele
    final filteredCountdowns = _filterCountdowns(controller);
    
    if (filteredCountdowns.isEmpty) {
      return EmptyStateWidget(
        message: _getEmptyMessage(),
        icon: Icons.hourglass_empty,
        actionLabel: _currentFilter == FilterType.all ? AppConstants.createNewCountdown : null,
        onActionPressed: _currentFilter == FilterType.all ? () {
          final navigationController = Provider.of<NavigationController>(context, listen: false);
          navigationController.navigateTo(AppRoute.newCountdown);
        } : null,
      );
    }
    
    return AnimationLimiter(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: filteredCountdowns.length,
        itemBuilder: (context, index) {
          final countdown = filteredCountdowns[index];
          
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: Duration(milliseconds: 50),
            child: SlideAnimation(
              horizontalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                  child: CountdownCard(
                    countdown: countdown,
                    onTap: () {
                      controller.setCurrentCountdown(countdown);
                      final navigationController = Provider.of<NavigationController>(context, listen: false);
                      navigationController.navigateTo(
                        AppRoute.countdown,
                        params: {'countdownId': countdown.id},
                      );
                    },
                    onEdit: () {
                      final navigationController = Provider.of<NavigationController>(context, listen: false);
                      navigationController.navigateTo(
                        AppRoute.newCountdown,
                        params: {'countdownId': countdown.id},
                      );
                    },
                    onDelete: () => _showDeleteDialog(countdown.id, countdown.eventName),
                    isCompact: false,
                    showControls: false,
                    showDetailButtons: true,
                    animationDelay: 100 * index,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  List<dynamic> _filterCountdowns(CountdownController controller) {
    switch (_currentFilter) {
      case FilterType.active:
        return controller.countdowns.where((c) => !c.isCompleted).toList();
      case FilterType.completed:
        return controller.countdowns.where((c) => c.isCompleted).toList();
      case FilterType.all:
      default:
        return controller.countdowns;
    }
  }
  
  String _getEmptyMessage() {
    switch (_currentFilter) {
      case FilterType.active:
        return 'Aktif geri sayım bulunamadı';
      case FilterType.completed:
        return 'Tamamlanmış geri sayım bulunamadı';
      case FilterType.all:
      default:
        return AppConstants.noCountdowns;
    }
  }
  
  void _showDeleteDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Geri Sayımı Sil"),
        content: Text("'$name' geri sayımını silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final countdownController = Provider.of<CountdownController>(context, listen: false);
              countdownController.deleteCountdown(id);
            },
            child: Text("Sil"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}