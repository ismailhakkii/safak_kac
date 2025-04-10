import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/countdown_model.dart';
import '../../utils/date_utils.dart';
import '../../utils/constants.dart';
import 'countdown_timer.dart';

class CountdownCard extends StatelessWidget {
  final CountdownModel countdown;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isCompact;
  final bool showControls;
  final bool showDetailButtons;
  final int animationDelay;

  const CountdownCard({
    Key? key,
    required this.countdown,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isCompact = false,
    this.showControls = true,
    this.showDetailButtons = true,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: animationDelay),
      duration: AppConstants.defaultAnimationDuration,
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'countdown-${countdown.id}',
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(context),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: EdgeInsets.all(
                      isCompact ? AppConstants.paddingSmall : AppConstants.paddingMedium,
                    ),
                    child: isCompact 
                        ? _buildCompactCard(context) 
                        : _buildDetailedCard(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    // Tema rengine göre gradient oluştur
    final themeColor = _getThemeColor(context);
    
    // Tamamlandıysa daha soluk renkler kullan
    if (countdown.isCompleted) {
      return [
        themeColor.withOpacity(0.6),
        themeColor.withOpacity(0.3),
      ];
    }
    
    return [
      themeColor,
      themeColor.withOpacity(0.6),
    ];
  }

  Color _getThemeColor(BuildContext context) {
    // Countdown'ın kendi teması varsa kullan
    switch (countdown.themeColor) {
      case 'blue':
        return const Color(0xFF2196F3);
      case 'green':
        return const Color(0xFF4CAF50);
      case 'orange':
        return const Color(0xFFFF9800);
      case 'red':
        return const Color(0xFFF44336);
      case 'teal':
        return const Color(0xFF009688);
      case 'purple':
      default:
        return const Color(0xFF7E57C2);
    }
  }

  Widget _buildCompactCard(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countdown.eventName,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                DateTimeUtils.getRelativeDateString(countdown.targetDateTime),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        CountdownTimer(
          countdown: countdown,
          showControls: false,
          isAnimated: false,
          isCompact: true,
        ),
        if (showDetailButtons) ...[
          SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white, size: 20),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailedCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.event,
              color: Colors.white,
              size: AppConstants.iconSizeMedium,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                countdown.eventName,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showDetailButtons) ...[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: onEdit,
                tooltip: AppConstants.edit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: onDelete,
                tooltip: AppConstants.delete,
              ),
            ],
          ],
        ),
        Divider(color: Colors.white.withOpacity(0.3)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.9),
                size: AppConstants.iconSizeSmall,
              ),
              SizedBox(width: 8),
              Text(
                DateTimeUtils.formatDateTime(countdown.targetDateTime),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        CountdownTimer(
          countdown: countdown,
          showControls: showControls,
          isAnimated: true,
          isCompact: false,
        ),
      ],
    );
  }
}