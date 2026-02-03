import 'package:flutter/material.dart';
import '../widgets/uihelper.dart'; // Ensure correct path to your helper
import 'package:pankh/constants/appTokens.dart';

class WidHeader extends StatelessWidget implements PreferredSizeWidget {
  const WidHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: [
            // Background Bird Graphics
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: 0.85,
                child: UiHelper.CustomImage(
                  img: "imgHeaderBirds.png",
                  height: 90,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildProfileAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiHelper.CustomText(
                          text: "Hello, Anupama!",
                          color: AppColors.colPrimary,
                          fontFamily: AppFonts.fontFamilyTitle,
                          fontSize: AppFontSizes.fontSizeTitleBig,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 6),
                        _buildCurrencyRow(),
                      ],
                    ),
                  ),
                  _buildActionIcons(),
                ],
              ),
            ),
          ],
        ),

    );
  }

  // Use a softer Gold (Ember Gold) for the crown and coins
  Widget _buildProfileAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.colOnTertiary, // Ember Gold border
          child: CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage("assets/images/2.0x/imgProfilePic.png"),
          ),
        ),
        Positioned(
          top: -10,
          left: 20,
          child: Icon(Icons.auto_awesome, color: AppColors.colOnTertiary, size: 20),
        ),
      ],
    );
  }

  Widget _buildCurrencyRow() {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.colSecondary.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.colOnTertiary, size: 15),
              const SizedBox(width: 4),
              UiHelper.CustomText(text:"2000", color: AppColors.colOnPrimary, fontSize: AppFontSizes.fontSizeCaption, fontFamily: AppFonts.fontFamilyCaption, fontWeight: FontWeight.w500),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        Icon(Icons.notifications_none_rounded, size: 30 , color: AppColors.colPrimary.withOpacity(0.8)),
        const SizedBox(width: 12),
        Icon(Icons.settings_outlined, size: 30, color: AppColors.colPrimary.withOpacity(0.8)),
      ],
    );
  }
}