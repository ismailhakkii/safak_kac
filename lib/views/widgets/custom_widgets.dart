import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../utils/constants.dart';

class CustomBackgroundContainer extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final Color backgroundColor;
  final bool showGradient;

  const CustomBackgroundContainer({
    Key? key,
    required this.child,
    this.backgroundImage,
    this.backgroundColor = Colors.white,
    this.showGradient = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: backgroundImage != null
            ? DecorationImage(
                image: AssetImage(backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
        gradient: showGradient
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Theme.of(context).primaryColor.withOpacity(0.6),
                ],
              )
            : null,
        color: backgroundImage == null && !showGradient ? backgroundColor : null,
      ),
      child: child,
    );
  }
}

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final Color? backgroundColor;
  final Animation<double>? animationProgress;

  const AnimatedAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
    this.backgroundColor,
    this.animationProgress,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final progress = animationProgress?.value ?? 1.0;
    
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      centerTitle: true,
      title: FadeInDown(
        duration: AppConstants.defaultAnimationDuration,
        child: Text(title),
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : leading,
      actions: actions != null
          ? actions!.map((action) {
              final index = actions!.indexOf(action);
              return FadeInRight(
                delay: Duration(milliseconds: 100 * index),
                duration: AppConstants.defaultAnimationDuration,
                child: action,
              );
            }).toList()
          : null,
      titleSpacing: progress * 16.0,
      leadingWidth: 56.0 * progress,
    );
  }
}

class CountdownButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isFullWidth;
  final bool isOutlined;
  final bool showShadow;
  final double height;

  const CountdownButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isFullWidth = false,
    this.isOutlined = false,
    this.showShadow = true,
    this.height = AppConstants.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: showShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: (backgroundColor ?? Theme.of(context).primaryColor).withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            )
          : null,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: isOutlined
            ? OutlinedButton.styleFrom(
                foregroundColor: textColor ?? Theme.of(context).primaryColor,
                side: BorderSide(
                  color: backgroundColor ?? Theme.of(context).primaryColor,
                  width: 2,
                ),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
              ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon = Icons.hourglass_empty,
    this.onActionPressed,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              message,
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              SizedBox(height: AppConstants.paddingLarge),
              CountdownButton(
                icon: Icons.add,
                label: actionLabel!,
                onPressed: onActionPressed!,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const CustomSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: AppConstants.iconSizeMedium,
            ),
            SizedBox(width: AppConstants.paddingMedium),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _index;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _index = widget.index;
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      setState(() {
        _index = oldWidget.index;
      });
      _controller.reverse().then((_) {
        setState(() {
          _index = widget.index;
        });
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: IndexedStack(
            index: _index,
            children: widget.children,
          ),
        );
      },
    );
  }
}