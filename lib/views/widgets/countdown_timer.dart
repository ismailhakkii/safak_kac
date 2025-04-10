import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/countdown_model.dart';
import '../../utils/date_utils.dart';
import '../../utils/constants.dart';

class CountdownTimer extends StatefulWidget {
  final CountdownModel countdown;
  final Function(bool isActive)? onStateChanged;
  final Function()? onCompleted;
  final bool showControls;
  final bool isAnimated;
  final bool isCompact;

  const CountdownTimer({
    Key? key,
    required this.countdown,
    this.onStateChanged,
    this.onCompleted,
    this.showControls = true,
    this.isAnimated = true,
    this.isCompact = false,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isActive = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.defaultAnimationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (widget.isAnimated) {
      _animationController.repeat(reverse: true);
    }
    
    _updateRemainingTime();
    
    if (widget.countdown.isActive) {
      _startTimer();
    }
  }
  
  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.countdown.isActive != widget.countdown.isActive) {
      if (widget.countdown.isActive) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
    
    if (oldWidget.countdown.targetDateTime != widget.countdown.targetDateTime) {
      _updateRemainingTime();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
  
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    setState(() {
      _isActive = true;
    });
    
    // İlk güncelleşmeyi hemen yap
    _updateRemainingTime();
    
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(true);
    }
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateRemainingTime();
        
        // Tamamlandı mı kontrol et
        if (_remainingTime.inSeconds <= 0) {
          _stopTimer();
          if (widget.onCompleted != null) {
            widget.onCompleted!();
          }
        }
      }
    });
  }
  
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    
    if (mounted) {
      setState(() {
        _isActive = false;
      });
      
      if (widget.onStateChanged != null) {
        widget.onStateChanged!(false);
      }
    }
  }
  
  void _updateRemainingTime() {
    if (mounted) {
      setState(() {
        _remainingTime = widget.countdown.getRemainingTime();
      });
    }
  }
  
  void _toggleTimer() {
    if (_isActive) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }
  
  double _calculateProgress() {
    if (widget.countdown.targetDateTime.isBefore(DateTime.now())) {
      return 1.0;
    }
    
    final totalDuration = widget.countdown.targetDateTime.difference(
      DateTime.now().subtract(_remainingTime)
    );
    
    if (totalDuration.inMilliseconds <= 0) {
      return 1.0;
    }
    
    final progress = 1.0 - (_remainingTime.inMilliseconds / totalDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCompact 
        ? _buildCompactTimer()
        : _buildFullTimer();
  }
  
  Widget _buildFullTimer() {
    return AnimatedContainer(
      duration: AppConstants.defaultAnimationDuration,
      padding: EdgeInsets.all(_isActive 
          ? AppConstants.paddingLarge 
          : AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppConstants.remainingTime,
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: AppConstants.paddingMedium),
          _buildDaysDisplay(),
          SizedBox(height: AppConstants.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerUnit(_remainingTime.inHours.remainder(24).toString().padLeft(2, '0'), AppConstants.hour),
              _buildTimerSeparator(),
              _buildTimerUnit(_remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0'), AppConstants.minute),
              _buildTimerSeparator(),
              _buildTimerUnit(_remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0'), AppConstants.second),
            ],
          ),
          if (_isActive)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: AppConstants.paddingLarge),
                  child: LinearProgressIndicator(
                    value: _calculateProgress(),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HSLColor.fromColor(Theme.of(context).colorScheme.secondary)
                          .withLightness(0.6 + 0.4 * _animation.value)
                          .toColor(),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          if (widget.showControls)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.paddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: AnimatedSwitcher(
                      duration: AppConstants.defaultAnimationDuration,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        _isActive ? Icons.pause : Icons.play_arrow,
                        key: ValueKey<bool>(_isActive),
                      ),
                    ),
                    label: Text(_isActive ? AppConstants.pause : AppConstants.start),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isActive 
                        ? Colors.orange 
                        : Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(150, AppConstants.buttonHeight),
                    ),
                    onPressed: _toggleTimer,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildCompactTimer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: Theme.of(context).primaryColor,
            size: AppConstants.iconSizeMedium,
          ),
          SizedBox(width: AppConstants.paddingSmall),
          Text(
            DateTimeUtils.formatDurationShort(_remainingTime),
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (widget.showControls) ...[
            SizedBox(width: AppConstants.paddingSmall),
            IconButton(
              icon: Icon(
                _isActive ? Icons.pause : Icons.play_arrow,
                color: _isActive ? Colors.orange : Colors.green,
              ),
              onPressed: _toggleTimer,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              iconSize: AppConstants.iconSizeMedium,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDaysDisplay() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Text(
            _remainingTime.inDays.toString(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            AppConstants.day,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerUnit(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}