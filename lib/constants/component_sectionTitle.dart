import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';

import '../screens/explorescreen/explorescreen.dart';
import '../screens/homescreen/homescreen.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showViewAllLabel;
  final bool showViewAll;
  final VoidCallback? onMoreTapRoute;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle, // Removed redundant = null
    this.showViewAllLabel = false,
    this.showViewAll = false,
    this.onMoreTapRoute,
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

              if (showViewAllLabel || showViewAll)
                GestureDetector(
                  onTap: onMoreTapRoute,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showViewAllLabel)
                        Text("More", style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (showViewAll)
                        SizedBox(
                          height: AppSizes.sizeMedium,
                          width: AppSizes.sizeMedium,
                          child: const Icon(Icons.chevron_right, color: AppColors.colPrimary, size: AppSizes.sizeMedium),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          if (subtitleWidget != null) subtitleWidget,
          const SizedBox(height: AppSizes.sizeXSmall),
        ],
      ),
    );
  }
}