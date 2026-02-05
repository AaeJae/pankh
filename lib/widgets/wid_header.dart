import 'package:flutter/material.dart';
import 'package:pankh/widgets/wid_dialog.dart';
import '../models/mod_user.dart';
import '../screens/profilescreen/profilescreen.dart';
import '../services/ser_user.dart';
import '../widgets/wid_uihelper.dart';
import 'package:pankh/constants/app_tokens.dart';

class WidHeader extends StatelessWidget implements PreferredSizeWidget {
  const WidHeader({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    // Wrap in SafeArea to handle the notch/status bar automatically
    return SafeArea(
      child: Container(
        // Removing the Stack if the bird graphic is causing overflow issues,
        // or keeping it but ensuring it doesn't push the container height.
        child: Stack(
          alignment: Alignment.center, // Keep items vertically centered
          children: [
            // Background Bird Graphics
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: 0.7, // Lowered slightly so text pops more
                child: UiHelper.customImage(
                  img: "imgHeaderBirds.png",
                  height: 40, // Reduced from 50
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),

            Padding(
              // 2. REDUCED VERTICAL PADDING: Changed 8 to 4
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildProfileAvatar(context),

                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<ModUser>(
                      stream: SerUser.userStream,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min, // 3. IMPORTANT: Shrink-wrap the column
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiHelper.customText(
                              text: "Hello, ${SerUser.displayName}!",
                              color: AppColors.colPrimary,
                              fontFamily: AppFonts.fontFamilyTitle,
                              fontSize: AppFontSizes.fontSizeTitle, // Reduced from TitleBig
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 4), // Reduced from 6
                            _buildCurrencyRow(),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildActionIcons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (SerUser.isGuest) {
          await WidDialog.showLoginDialog(context);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 26, // Reduced from 30
            backgroundColor: AppColors.colOnTertiary,
            child: CircleAvatar(
              radius: 23, // Reduced from 26
              backgroundColor: AppColors.colSecondary,
              child: const Image(
                image: AssetImage("assets/images/2.0x/imgProfilePic.png"),
              ),
            ),
          ),
          Positioned(
            top: -6, // Adjusted for smaller radius
            left: 18,
            child: Icon(
              Icons.auto_awesome,
              color: SerUser.isGuest ? Colors.grey.shade400 : AppColors.colOnTertiary,
              size: 16, // Reduced from 20
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCurrencyRow() {
    final items = [
      {
        "icon": Icons.electric_bolt_sharp,
        "value": SerUser.currentXP,
        "color": AppColors.colTertiary,
        "label": "XP"
      },
      {
        "icon": Icons.local_fire_department_sharp,
        "value": SerUser.currentStreak,
        "color": AppColors.colTertiary,
        "label": "Streak"
      },
      {
        "icon": Icons.volunteer_activism_sharp,
        "value": SerUser.currentKarma,
        "color": AppColors.colTertiary,
        "label": "Karma"
      },
    ];

    return Row(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.colSecondary.withValues(alpha:0.8),
            borderRadius: BorderRadius.circular(12), // Slightly more modern radius
            border: Border.all(color: (item["color"] as Color).withValues(alpha:0.2), width: 1),
          ),
          child: Row(
            children: [
              // Icon with a subtle shadow to make it glow
              Icon(
                item["icon"] as IconData,
                color: item["color"] as Color,
                size: 16,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: (item["color"] as Color).withValues(alpha:0.5),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              UiHelper.customText(
                text: "${item["value"]}",
                color: AppColors.colOnPrimary,
                fontSize: AppFontSizes.fontSizeCaption,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        Icon(Icons.notifications_none_rounded, size: 30 , color: AppColors.colPrimary.withValues(alpha:0.8)),
        const SizedBox(width: 12),
        Icon(Icons.settings_outlined, size: 30, color: AppColors.colPrimary.withValues(alpha:0.8)),
      ],
    );
  }
}