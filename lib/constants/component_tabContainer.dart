import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';

class AppTabItem {
  final String label;
  final IconData? icon;
  final bool isLocked;
  final Widget content;

  AppTabItem({
    required this.label,
    required this.content,
    this.icon,
    this.isLocked = false,
  });
}

class AppTabs extends StatelessWidget {
  final List<AppTabItem> items;
  final bool isScrollable;

  const AppTabs({
    super.key,
    required this.items,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    const double maxCardHeight = 400.0; // Define your max height here

    return DefaultTabController(
      length: items.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The Tab Bar Container (Misty Track)
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacingSmall),
            decoration: BoxDecoration(
              color: AppColors.colDisabled.withAlpha(AppAlpha.alphaLow), // Misty Background
              borderRadius: BorderRadius.circular(AppRadii.radiusMedium),
            ),
            child: TabBar(
              isScrollable: isScrollable,
              tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
              splashBorderRadius: BorderRadius.circular(AppRadii.radiusMedium),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: EdgeInsets.all(0),
              // The White "Pill" Selector from your image
              indicator: BoxDecoration(
                color: AppColors.colSecondary,
                borderRadius: BorderRadius.circular(AppRadii.radiusMedium),
                boxShadow: AppShadows.shadowSmall,
              ),
              labelColor: AppColors.colOnSecondary,
              unselectedLabelColor: AppColors.colDisabled,
              labelStyle: AppTypography.bodyBold,
              unselectedLabelStyle: AppTypography.body,
              tabs: items.map((item) => _buildTab(item)).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.spacingSmall),

          // The Content Card
          // The Content Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.colWhite,
              borderRadius: BorderRadius.circular(AppRadii.radiusMedium),
              boxShadow: AppShadows.shadowSmall,
              border: Border.all(color: AppColors.colDisabled.withAlpha(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.radiusMedium),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 120, // Minimum height for the card
                  maxHeight: 350, // Maximum height before scrolling kicks in
                ),
                child: TabBarView(
                  children: items.map((item) {
                    // Each tab content is wrapped in a scroll view
                    return SingleChildScrollView(
                      // Use AlwaysScrollable so the user feels the boundary
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.spacingMedium),
                      child: item.content,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(AppTabItem item) {
    return Tab(
      height: 40,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 80,  // Minimum width for the pill
          maxWidth: 150, // Maximum width before truncating
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isLocked)
                const Icon(Icons.lock_outline, size: 16)
              else if (item.icon != null)
                Icon(item.icon, size: 18),

              if (item.icon != null || item.isLocked)
                const SizedBox(width: 8),

              // The Flexible widget is crucial here to allow ellipsis to work
              Flexible(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Adds the "..."
                  style: const TextStyle(inherit: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}