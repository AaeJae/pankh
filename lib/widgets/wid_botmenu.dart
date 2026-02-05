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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.transparent,
      height: 150,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // 1. ISOLATED BACKGROUND GRAPHICS
          Positioned(
            bottom: 0,
            child: RepaintBoundary(
              child: IgnorePointer(
                child: UiHelper.customImage(
                  img: "imgBotGraphics.png",
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                  opacity: 0.7,
                ),
              ),
            ),
          ),

          // 2. THE GLASS MORPHIC BAR
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: AppColors.colSecondary.withValues(alpha:0.7), // Deep Matte Green
                borderRadius: BorderRadius.circular(40),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withValues(alpha:0.3),
                //     blurRadius: 25,
                //     offset: const Offset(0, 12),
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavIcon(Icons.home_filled, "Home", 0),
                  _buildNavIcon(Icons.auto_awesome_rounded, "Explore", 1),
                  const SizedBox(width: 70), // Center space
                  _buildNavIcon(Icons.forum_rounded, "Adda", 2),
                  _buildNavIcon(Icons.local_mall_rounded, "Shop", 3),
                ],
              ),
            ),
          ),

          // 3. THE MODERN BLITZ BUTTON
          Positioned(
            bottom: 40,
            child: GestureDetector(
              onTap: () => onItemTapped(4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Ambient Glow
                  Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colWhite.withValues(alpha:0.3),
                          blurRadius: 20,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                  ),

                  // The "Glass" Housing
                  Container(
                    height: 75,
                    width: 75,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.colSecondary, AppColors.colPrimary],
                      ),
                    ),
                  ),

                  // THE ICON: Minimalist Lightning
                  Icon(
                    Icons.bolt_rounded,
                    color: AppColors.colOnTertiary.withValues(alpha:0.3), // Sunset Gold
                    size: 65,
                    shadows: const [
                      Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
                    ],
                  ),
                  UiHelper.customText(text:"Play \n BLITZ",textAlign: TextAlign.center, color: AppColors.colOnPrimary, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilyCaption, fontWeight: FontWeight.normal,),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? const Color(0xFFFFB703) : Colors.white60,
          ),
          const SizedBox(height: 4),
          UiHelper.customText(text:label, color: AppColors.colOnPrimary, fontSize: AppFontSizes.fontSizeCaption, fontFamily: AppFonts.fontFamilyCaption, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,),
        ],
      ),
    );
  }
}

