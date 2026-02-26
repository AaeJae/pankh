import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignTokens.dart';

enum AppSheetVariant { defaultList, tabbed }

class AppSheet {
  static Future<void> show(BuildContext context, {
    required String title,
    String? subtitle,
    bool isScrollControlled = true,
    AppSheetVariant variant = AppSheetVariant.defaultList,
    List<String>? tabs,
    required List<Widget> items,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      showDragHandle: true, // This enables the internal handle
      builder: (context) =>
          AppModalBottomSheet(
            title: title,
            subtitle: subtitle,
            variant: variant,
            tabs: tabs,
            items: items,
          ),
    );
  }

  // Helper for List Variant
  static Widget buildListItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.colSecondary),/**/
      title: Text(text, style: AppTypography.body),
      trailing: const Icon(
          Icons.chevron_right, size: 20, color: AppColors.colPrimary),
      onTap: onTap,
    );
  }

  // Helper for Tabbed Variant Content
  static Widget buildTabContent(List<String> data) {
    final ScrollController tabScrollController = ScrollController();

    return RawScrollbar(
      controller: tabScrollController,
      thumbColor: AppColors.colDisabled.withAlpha(AppAlpha.alphaMedium),
      thickness: AppSizes.sizeXXSmall,
      radius: const Radius.circular(AppSizes.sizeCircular),
      thumbVisibility: true,
      child: ListView.builder(
        controller: tabScrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sizeXSmall),
        itemBuilder: (context, index) =>
            ListTile(
              title: Text(data[index], style: AppTypography.body),
              dense: true,
            ),
      ),
    );
  }
}

class AppModalBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AppSheetVariant variant;
  final List<String>? tabs;
  final List<Widget> items;

  const AppModalBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.variant,
    this.tabs,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTabbed = variant == AppSheetVariant.tabbed && tabs != null;

    //MODAL TITLE AND SUBTITLE
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(AppSizes.sizeXSmall,AppSizes.sizeSmall, AppSizes.sizeXSmall, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.subtitle1),
              if (subtitle != null) ...[
                const SizedBox(height: AppSizes.sizeXXSmall),
                Text(subtitle!, style: AppTypography.caption),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sizeSmall),
        if (!isTabbed) ...items,
        if (isTabbed) _buildTabbedLayout(context),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.colWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.sizeLarge)),
      ),
      padding: EdgeInsets.fromLTRB(AppSizes.sizeXSmall,AppSizes.sizeMedium, AppSizes.sizeXSmall, AppSizes.sizeMedium),
      child: isTabbed ? content : SingleChildScrollView(child: content),
    );
  }

  Widget _buildTabbedLayout(BuildContext context) {
    return DefaultTabController(
      length: tabs!.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.colTertiary,
            labelColor: AppColors.colPrimary,
            unselectedLabelColor: AppColors.colOnDisabled,
            tabs: tabs!.map((t) => Tab(text: t.toUpperCase())).toList(),
          ),
          SizedBox(
            height: 250,
            child: TabBarView(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}