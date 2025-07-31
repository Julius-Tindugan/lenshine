import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width >= 600 && media.size.width < 1024;
    final isDesktop = media.size.width >= 1024;
    final horizontalMargin = isDesktop ? 120.0 : isTablet ? 40.0 : 24.0;
    final verticalMargin = isDesktop ? 24.0 : isTablet ? 16.0 : 8.0;
    final navHeight = isDesktop ? 76.0 : isTablet ? 68.0 : 60.0;
    final iconSize = isDesktop ? 32.0 : isTablet ? 28.0 : 24.0;
    final textScale = math.min(1.0, media.textScaleFactor);
    final labelFontSize = isDesktop ? 15.0 : isTablet ? 13.0 : 11.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
      height: navHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, "Home", 0, iconSize, labelFontSize, textScale, isDesktop, isTablet),
          _buildNavItem(Icons.map_outlined, "Map", 1, iconSize, labelFontSize, textScale, isDesktop, isTablet),
          _buildNavItem(Icons.chat_bubble_outline, "Chat", 2, iconSize, labelFontSize, textScale, isDesktop, isTablet),
          _buildNavItem(Icons.person_outline, "Profile", 3, iconSize, labelFontSize, textScale, isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, double iconSize, double labelFontSize, double textScale, bool isDesktop, bool isTablet) {
    final isSelected = selectedIndex == index;
    final minTapSize = 48.0;
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        selected: isSelected,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onItemSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(vertical: isDesktop ? 4 : 1),
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.1),
                        width: 1,
                      ),
                    )
                  : null,
              constraints: BoxConstraints(minHeight: minTapSize, minWidth: minTapSize),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isSelected ? (isDesktop ? 40 : 32) : 0,
                        height: isSelected ? (isDesktop ? 40 : 32) : 0,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black.withOpacity(0.13) : Colors.transparent,
                          borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                        ),
                      ),
                      Icon(
                        icon,
                        color: isSelected ? Colors.black : Colors.black.withOpacity(0.6),
                        size: iconSize,
                        semanticLabel: label,
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: labelFontSize * textScale,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.black.withOpacity(0.6),
                    ),
                  ),
                  if (isSelected)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.only(top: isDesktop ? 3 : 1),
                      height: isDesktop ? 4 : 2,
                      width: isDesktop ? 28 : 20,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
                      ),
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