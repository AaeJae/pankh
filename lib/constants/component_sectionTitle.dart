import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showViewAllLabel;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle, // Removed redundant = null
    this.showViewAllLabel = false,
    this.showViewAll = false,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the subtitle widget once to keep build method clean
    final Widget? subtitleWidget = subtitle != null
        ? Text(
      subtitle!,
      style: AppTypography.body.copyWith(
        color: AppColors.colPrimary.withOpacity(0.7),
        fontSize: 12,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Performance: don't take extra vertical space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              // Expanded ensures the title doesn't push the icon off-screen
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.subtitle2.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              if (showViewAllLabel)
                Text(
                  "More",
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (showViewAll)
              // Constraints help with hit-testing and memory
                SizedBox(
                  height: AppSizes.sizeMedium, // Standardize tap area
                  width: AppSizes.sizeMedium,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onViewAllTap,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.colPrimary,
                      size: AppSizes.sizeMedium,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitleWidget != null) subtitleWidget,
          //Divider(thickness: 0.5, color: AppColors.colPrimary.withAlpha(AppAlpha.alphaLow)),

          const SizedBox(height: AppSizes.sizeXSmall),

        ],
      ),
    );
  }
}