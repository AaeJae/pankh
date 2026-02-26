import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class AppTab {
  final String label;
  final IconData? icon;
  final bool isLocked;
  final List<dynamic> content;

  const AppTab({
    required this.label,
    required this.content,
    this.icon,
    this.isLocked = false,
  });
}

class AppTabContainer extends StatelessWidget {
  final List<AppTab> tabs;
  final bool isScrollable;
  final double? height;
  final double? width;

  const AppTabContainer({
    super.key,
    required this.tabs,
    this.isScrollable = true,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Cache the tab widgets to avoid mapping on every local rebuild
    final List<Widget> myTabs = tabs.map((item) => _buildTab(item)).toList();

    return DefaultTabController(
      length: tabs.length,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Tab Bar Container
            DecoratedBox(
              decoration: BoxDecoration(
              color: AppColors.colSecondary.withAlpha(AppAlpha.alphaLow),
              borderRadius: BorderRadius.circular(AppSizes.sizeLarge),
            ),
            child: TabBar(
              isScrollable: isScrollable,
              tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
              splashBorderRadius: BorderRadius.circular(AppSizes.sizeLarge),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: EdgeInsets.zero,
              indicator: BoxDecoration(
                color: AppColors.colSecondary,
                borderRadius: BorderRadius.circular(AppSizes.sizeLarge),
                boxShadow: AppShadows.shadowSmall,
              ),
              labelColor: AppColors.colOnSecondary,
              unselectedLabelColor: AppColors.colOnTertiary,
              labelStyle: AppTypography.bodyBold,
              unselectedLabelStyle: AppTypography.body,
              tabs: myTabs,
            ),
          ),

          // The Content Container
          SizedBox(
              height: height ?? 400,
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: tabs.map((item) => RepaintBoundary(
                  child: _buildTabContent(item),
                )).toList(),
              ),
          ),
          ],
        ),
      ),
    );
  }
  Widget _buildTab(AppTab item) {
    return Tab(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeSmall),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.isLocked || item.icon != null) ...[
              Icon(
                item.isLocked ? Icons.lock_outline : item.icon,
                size: item.isLocked ? 16 : 18,
              ),
              const SizedBox(width: AppSizes.sizeXSmall),
            ],
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTabContent(AppTab item) {
    return ListView.builder(
      // Added padding so the carousel doesn't touch the TabBar
      padding: const EdgeInsets.only(top: AppSizes.sizeSmall),
      itemCount: item.content.length,
      itemBuilder: (context, index) {
        final contentItem = item.content[index];
        if (contentItem is Widget) {
          return contentItem;
        }
        return const SizedBox.shrink();
      },
    );
  }
}