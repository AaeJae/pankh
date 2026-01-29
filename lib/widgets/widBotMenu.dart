import 'package:flutter/material.dart';
import 'uihelper.dart'; // Ensure correct path
import 'package:pankh/constants/appTokens.dart';

class WidBotMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const WidBotMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  @override
  Widget build(BuildContext context) {
    // Determine screen width for consistency
    double screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Container(
        color: Colors.transparent,
        width: screenWidth, // Ensures the stack has a full-width reference point
        height: 150,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [

            // 1. THE TREE GRAPHICS (Layered at the bottom)
            // Balanced left/right to 0 to span the screen perfectly
            Positioned(
              child: IgnorePointer(
                child: UiHelper.CustomImage(
                  img: "imgBotGraphics.png",
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // 2. THE FLOATING MENU BAR
            Positioned(
              bottom: 30, // Adjusted slightly so it doesn't hit the very bottom
              left: 20,
              right: 20,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.colSecondary,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavIcon("iconHome.png", "Home", 0),
                    _buildNavIcon("iconQuiz.png", "Quizzes", 1),
                    const SizedBox(width: 60), // Space for the center Blitz button
                    _buildNavIcon("iconGroup.png", "Adda", 2),
                    _buildNavIcon("iconBuy.png", "Buy", 3),
                  ],
                ),
              ),
            ),

            // 3. THE BLITZ BUTTON
            // alignment: Alignment.bottomCenter in the Stack handles the X-axis
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () => onItemTapped(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,

                      children: [
                        UiHelper.CustomIcon(img: "iconMenuCenter.png", height: 85, width: 85),
                        UiHelper.CustomIcon(img: "iconBlitz.png", height: 35, width: 35),
                      ],
                    ),
                    UiHelper.CustomText(
                        text: "BLITZ",
                        color: AppColors.colTertiary,
                        fontSize: AppFontSizes.fontSizeBody,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontFamilyBody
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Helper to build individual nav items
  Widget _buildNavIcon(String iconPath, String label, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.colTertiary : Colors.white,
            ),
            child: UiHelper.CustomIcon(img: iconPath, height: 24, width: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

