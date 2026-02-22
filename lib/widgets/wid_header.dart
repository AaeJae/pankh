import 'package:flutter/material.dart';
import 'package:pankh/widgets/wid_dialog.dart';
import '../models/mod_user.dart';
import '../screens/profilescreen/profilescreen.dart';
import '../services/ser_user.dart';
import '../widgets/wid_uihelper.dart';
import 'package:pankh/constants/designtokens.dart';

class WidHeader extends StatelessWidget implements PreferredSizeWidget {
  const WidHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    // 1. Get the height of the status bar/notch
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      // 2. Apply manual top padding instead of SafeArea
      padding: EdgeInsets.only(top: topPadding),
      color: Colors.transparent, // Or set a solid color if needed
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Bird Graphics
          Align(
            alignment: Alignment.centerRight,
            child: Opacity(
              opacity: 0.7,
              child: UiHelper.customImage(
                img: "imgHeaderBirds.png",
                height: 35,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 10),
            child: Row(
              children: [
                _buildProfileAvatar(context),
                const SizedBox(width: 12),
                Expanded(
                  child: StreamBuilder<ModUser>(
                    stream: SerUser.userStream,
                    builder: (context, snapshot) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UiHelper.customText(
                            text: "Hello, ${SerUser.displayName}!",
                            color: AppColors.colPrimary,
                            fontFamily: AppTypography.fontTitle,
                            fontSize: AppFontSizes.fontSizeTitle,
                            fontWeight: FontWeight.w600,
                          ),
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
            radius: 24,
            backgroundColor: AppColors.colOnTertiary,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: AppColors.colSecondary,
              child: const Image(
                image: AssetImage("assets/images/2.0x/imgProfilePic.png"),
              ),
            ),
          ),
          Positioned(
            top: -4,
            left: 16,
            child: Icon(
              Icons.auto_awesome,
              color: SerUser.isGuest ? Colors.grey.shade400 : AppColors.colOnTertiary,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyRow() {
    final items = [
      {"icon": Icons.electric_bolt_sharp, "value": SerUser.currentXP, "color": AppColors.colQuaternary},
      {"icon": Icons.local_fire_department_sharp, "value": SerUser.currentStreak, "color": AppColors.colQuaternary},
      {"icon": Icons.volunteer_activism_sharp, "value": SerUser.currentKarma, "color": AppColors.colQuaternary},
    ];

    return Row(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.colSecondary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: (item["color"] as Color).withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                item["icon"] as IconData,
                color: item["color"] as Color,
                size: 14,
              ),
              const SizedBox(width: 4),
              UiHelper.customText(
                text: "${item["value"]}",
                color: AppColors.colOnPrimary,
                fontSize: 10,
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
        Icon(Icons.notifications_none_rounded, size: 28, color: AppColors.colPrimary.withOpacity(0.8)),
        const SizedBox(width: 8),
        Icon(Icons.settings_outlined, size: 28, color: AppColors.colPrimary.withOpacity(0.8)),
      ],
    );
  }
}