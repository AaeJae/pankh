import 'package:flutter/material.dart';
import 'wid_uihelper.dart'; // Ensure correct path
import 'package:pankh/constants/app_tokens.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colPrimary.withValues(alpha:0.8),
      ),
      // 2. FIXED: Removed fixed height here. Let the Row + Padding + SafeArea
      // calculate the height naturally to avoid the 2.5px overflow.
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5), // Controlled breathing room
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Even spacing for 4 items
            children: [
              _buildNavIcon(Icons.home_filled, "Home", 0),
              _buildNavIcon(Icons.auto_awesome_rounded, "Explore", 1),
              _buildNavIcon(Icons.forum_rounded, "Adda", 2),
              _buildNavIcon(Icons.local_mall_rounded, "Shop", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Essential to prevent vertical overflow
        children: [
          Icon(
            icon,
            size: 25, // Slightly smaller to ensure fit
            color: isSelected ? AppColors.colOnTertiary : Colors.white60,
          ),
          const SizedBox(height: 4),
          UiHelper.customText(
            text: label,
            color: isSelected ? AppColors.colOnTertiary : Colors.white60,
            fontSize: AppFontSizes.fontSizeBody,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }
}