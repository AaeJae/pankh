import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/widgets/widDialog.dart';
import '../screens/profilescreen/profilescreen.dart';
import '../models/mod_user.dart';
import '../services/ser_user.dart';


class WidHeader extends StatelessWidget implements PreferredSizeWidget {
  const WidHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // // Background Bird Graphics - Performance: Isolated for painting efficiency
          // const Align(
          //   alignment: Alignment.centerRight,
          //   child: RepaintBoundary(
          //     child: Opacity(
          //       opacity: 0.7,
          //       child: Image(
          //         image: AssetImage("assets/images/imgHeaderBirds.png"),
          //         height: 35,
          //       ),
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.sizeXSmall,
                right: AppSizes.sizeXSmall,
                top: AppSizes.sizeXXSmall,
                bottom: AppSizes.sizeXSmall
            ),
            child: Row(
              children: [
                const _ProfileAvatar(), // Extracted to const widget for rebuild optimization
                const SizedBox(width: AppSizes.sizeXSmall),
                Expanded(
                  child: StreamBuilder<ModUser>(
                    stream: SerUser.userStream,
                    builder: (context, snapshot) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${SerUser.displayName}!",
                            style: AppTypography.subtitle1
                          ),
                          const _CurrencyRow(), // Extracted for performance
                        ],
                      );
                    },
                  ),
                ),
                const _ActionIcons(), // Extracted for performance
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (SerUser.isGuest) {
          await WidDialog.showDialogLogin(context);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen())
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: AppSizes.sizeMedium,
            backgroundColor: AppColors.colTertiary, // Applied Design Token
            child: CircleAvatar(
              radius: AppSizes.sizeMedium - AppSizes.sizeXXSmall,
              backgroundColor: AppColors.colSecondary,
              backgroundImage: AssetImage("assets/images/2.0x/imgProfilePic.png"),
            ),
          ),
          // Positioned(
          //   top: -4,
          //   left: 16,
          //   child: Icon(
          //     Icons.auto_awesome,
          //     color: SerUser.isGuest ? AppColors.colDisabled : AppColors.colTertiary,
          //     size: 14,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow();

  @override
  Widget build(BuildContext context) {
    // Stat items defined with Design Tokens
    final items = [
      {"icon": Icons.electric_bolt_sharp, "value": SerUser.currentXP},
      {"icon": Icons.local_fire_department_sharp, "value": SerUser.currentStreak},
      {"icon": Icons.volunteer_activism_sharp, "value": SerUser.currentKarma},
    ];

    return Row(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(right: AppSizes.sizeXXSmall),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeXSmall, vertical:1),
          decoration: BoxDecoration(
            color: AppColors.colSecondary,
            borderRadius: BorderRadius.circular(AppSizes.sizeCircular),
          ),
          child: Row(
            children: [
              Icon(
                item["icon"] as IconData,
                color: AppColors.colOnSecondary,
                size: AppSizes.sizeSmall - AppSizes.sizeXXXSmall,
              ),
              const SizedBox(width: AppSizes.sizeXXSmall),
              Text(
                "${item["value"]}",
                style: AppTypography.label.copyWith(
                  color: AppColors.colOnSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ActionIcons extends StatelessWidget {
  const _ActionIcons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
            Icons.notifications_none_rounded,
            size: AppSizes.sizeMedium,
            color: AppColors.colPrimary
        ),
        const SizedBox(width: AppSizes.sizeXSmall),
        const Icon(
            Icons.settings_outlined,
            size: AppSizes.sizeMedium,
            color: AppColors.colPrimary
        ),
      ],
    );
  }
}