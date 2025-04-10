import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/theme_model.dart';
import '../../utils/constants.dart';

class ThemeSelector extends StatefulWidget {
  final List<ThemeModel> themes;
  final String selectedThemeId;
  final Function(String) onThemeSelected;

  const ThemeSelector({
    Key? key,
    required this.themes,
    required this.selectedThemeId,
    required this.onThemeSelected,
  }) : super(key: key);

  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.paddingMedium,
            bottom: AppConstants.paddingSmall,
          ),
          child: Text(
            AppConstants.selectTheme,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.themes.length,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            itemBuilder: (context, index) {
              final theme = widget.themes[index];
              final isSelected = theme.id == widget.selectedThemeId;
              
              return FadeInLeft(
                delay: Duration(milliseconds: 100 * index),
                child: GestureDetector(
                  onTap: () => widget.onThemeSelected(theme.id),
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
                    child: AnimatedContainer(
                      duration: AppConstants.defaultAnimationDuration,
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primaryColor : theme.primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.6),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                )
                              ]
                            : [],
                        border: isSelected
                            ? Border.all(
                                color: Colors.white,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: AppConstants.defaultAnimationDuration,
                            padding: EdgeInsets.all(isSelected ? 10 : 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.color_lens,
                              color: Colors.white,
                              size: isSelected ? 30 : 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            theme.name,
                            style: TextStyle(
                              fontSize: isSelected ? 16 : 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorSelector({
    Key? key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.paddingMedium,
      runSpacing: AppConstants.paddingMedium,
      children: colors
          .map((color) => _buildColorItem(context, color, color == selectedColor))
          .toList(),
    );
  }

  Widget _buildColorItem(BuildContext context, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: isSelected
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              )
            : null,
      ),
    );
  }
}