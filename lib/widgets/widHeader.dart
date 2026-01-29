import 'package:flutter/material.dart';
import '../widgets/uihelper.dart'; // Ensure correct path to your helper
import 'package:pankh/constants/appTokens.dart';

class WidHeader extends StatelessWidget implements PreferredSizeWidget {
  const WidHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Bird Graphics
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: UiHelper.CustomImage(
                img: "imgHeaderBirds.png",
                height: 120,
                width: double.infinity,
              ),
            ),
          ),

          // Profile, Greeting, and Notification Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile pic with Crown
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    UiHelper.CustomImage(img: "2.0x/imgProfilePic.png", height: 60, width: 60),
                    Positioned(
                      top: -20,
                      left: 12,
                      child: UiHelper.CustomIcon(img: "iconCrown.png", height: 30, width: 30),
                    ),
                  ],
                ),
                const SizedBox(width: 10),

                // Greeting + 3 Coin Indicators
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(
                        text: "Hello, Anupama!",
                        color: AppColors.colWhite,
                        fontSize: AppFontSizes.fontSizeTitleBig,
                        fontWeight: FontWeight.normal,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Row(
                              children: [
                                UiHelper.CustomIcon(img: "2.0x/iconXP.png", height: 20, width: 20),
                                const SizedBox(width: 3),
                                UiHelper.CustomText(
                                  text: "2000",
                                  color: AppColors.colWhite,
                                  fontSize: AppFontSizes.fontSizeCaption,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppFonts.fontFamilyCaption,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Action Icons
                Row(
                  children: [
                    UiHelper.CustomIcon(img: "iconNotifBell.png", height: 24, width: 24),
                    const SizedBox(width: 10),
                    UiHelper.CustomIcon(img: "iconSettings.png", height: 24, width: 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}