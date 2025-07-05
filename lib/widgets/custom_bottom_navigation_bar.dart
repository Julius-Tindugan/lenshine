import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.map, 1),
          _buildNavItem(Icons.chat_bubble, 2),
          _buildNavItem(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    // Corrected the deprecated `withOpacity` call
    final color = selectedIndex == index ? Colors.black : Colors.black.withAlpha(153); // 0.6 opacity
    return IconButton(
      onPressed: () => onItemSelected(index),
      icon: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}