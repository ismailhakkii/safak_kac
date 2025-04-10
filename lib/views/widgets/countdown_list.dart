import 'package:flutter/material.dart';
import '../../models/countdown_model.dart';

class CountdownList extends StatelessWidget {
  final List<CountdownModel> countdowns;
  final Function(CountdownModel) onCountdownSelected;
  final Function(CountdownModel) onCountdownDeleted;

  const CountdownList({
    Key? key,
    required this.countdowns,
    required this.onCountdownSelected,
    required this.onCountdownDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (countdowns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Henüz geri sayım eklenmemiş',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: countdowns.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final countdown = countdowns[index];
        final remainingTime = countdown.getRemainingTime();
        final isCompleted = countdown.isCompleted || remainingTime.inSeconds <= 0;
        
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          color: isCompleted 
              ? Colors.grey[200] 
              : Theme.of(context).cardTheme.color,
          child: ListTile(
            leading: _buildLeadingIcon(context, countdown, isCompleted),
            title: Text(
              countdown.eventName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.grey : null,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              _formatRemainingTime(remainingTime, isCompleted),
              style: TextStyle(
                color: isCompleted ? Colors.grey : Colors.grey[700],
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              onPressed: () => _confirmDelete(context, countdown),
            ),
            onTap: () => onCountdownSelected(countdown),
          ),
        );
      },
    );
  }
  
  Widget _buildLeadingIcon(BuildContext context, CountdownModel countdown, bool isCompleted) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted 
            ? Colors.grey 
            : _getColorFromTheme(context, countdown.themeColor),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.timer,
        color: Colors.white,
        size: 20,
      ),
    );
  }
  
  Color _getColorFromTheme(BuildContext context, String themeColor) {
    switch (themeColor) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'purple':
      default:
        return Theme.of(context).primaryColor;
    }
  }
  
  String _formatRemainingTime(Duration duration, bool isCompleted) {
    if (isCompleted) {
      return 'Tamamlandı';
    }
    
    if (duration.inDays > 0) {
      return '${duration.inDays} gün ${duration.inHours.remainder(24)} saat kaldı';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} saat ${duration.inMinutes.remainder(60)} dakika kaldı';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} dakika ${duration.inSeconds.remainder(60)} saniye kaldı';
    } else {
      return '${duration.inSeconds} saniye kaldı';
    }
  }

  void _confirmDelete(BuildContext context, CountdownModel countdown) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Geri Sayımı Sil'),
        content: Text('${countdown.eventName} geri sayımını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
              onCountdownDeleted(countdown);
            },
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }
}