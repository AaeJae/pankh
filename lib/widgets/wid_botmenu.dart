import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class WidBotMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const WidBotMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      height: 60.0,
      items: <Widget>[
        _buildIcon(Icons.home_filled, 0),             // Index 0: Home
        _buildIcon(Icons.auto_awesome_rounded, 1),   // Index 1: Explore
        _buildIcon(Icons.forum_rounded, 2),          // Index 2: Adda
        _buildIcon(Icons.local_mall_rounded, 3),     // Index 3: Shop
        _buildIcon(Icons.person, 4),                 // Index 4: Profile (NEW)
      ],
      color: AppColors.colPrimary,
      buttonBackgroundColor: AppColors.colTertiary,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: AppDurations.durationMedium,
      onTap: (index) {
        onItemTapped(index); // This will now send 0, 1, 2, 3, or 4
      },
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final bool isSelected = selectedIndex == index;
    return Icon(
      icon,
      size: AppSizes.sizeMedium,
      color: isSelected ? AppColors.colWhite : Colors.white60,
    );
  }
}