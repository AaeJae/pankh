import 'package:flutter/material.dart';
import 'uihelper.dart'; // Ensure correct path
import 'package:pankh/domain/constants/appColors.dart';

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
    return MediaQuery.removePadding(
        context: context,
        removeBottom: true, // This forces the widget to ignore the system's bottom gap
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [

          // 1. THE FLOATING PURPLE MENU BAR
          Positioned(
            bottom: 0, // Lifted up to show the tree graphics beneath it
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.colPurpleSecondary,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                  const SizedBox(width: 60), // Gap for Blitz
                  _buildNavIcon("iconGroup.png", "Adda", 2),
                  _buildNavIcon("iconBuy.png", "Buy", 3),
                ],
              ),
            ),
          ),

          // 2. THE TREE GRAPHICS (Layered ON TOP, flush to the screen edge)
          Positioned(
            bottom: -25, // This sits perfectly on the bottom edge
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: UiHelper.CustomImage(
                img: "imgBotGraphics.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          // 3. THE BLITZ BUTTON (Centered on the floating bar)
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                // This will print "Blitz Tapped: 4" in your VS Code / Android Studio console

                onItemTapped(4);
                debugPrint("Blitz Tapped: 4");
              },
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      UiHelper.CustomIcon(img: "iconMenuCenter.png", height: 85, width: 85),
                      UiHelper.CustomIcon(img: "iconBlitz.png", height: 35, width: 35),
                    ],
                  ),
                  UiHelper.CustomText(text: "BLITZ", color: AppColors.colBlack, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "KantumruyPro")
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
              color: isSelected ? AppColors.colPurple : Colors.white,
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

