import 'package:flutter/material.dart';

import 'designtokens.dart';

// Assuming your design tokens are in this file or imported
// import 'package:pankh/constants/designtokens.dart';

class AutocompleteOption {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final dynamic value;

  AutocompleteOption({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
  });
}

class AppAutocomplete extends StatefulWidget {
  final String? label;
  final String hintText;
  final List<AutocompleteOption> options;
  final Function(AutocompleteOption?) onSelected;
  final bool isRequired;
  final IconData? prefixIcon;
  final String? initialValue;

  const AppAutocomplete({
    super.key,
    this.label,
    required this.hintText,
    required this.options,
    required this.onSelected,
    this.isRequired = false,
    this.prefixIcon,
    this.initialValue,
  });

  @override
  State<AppAutocomplete> createState() => _AppAutocompleteState();
}

class _AppAutocompleteState extends State<AppAutocomplete> {
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    if (widget.initialValue != null) {
      _searchController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<AutocompleteOption>(
      validator: (value) {
        if (widget.isRequired && _searchController.text.trim().isEmpty) {
          return "Selection required";
        }
        return null;
      },
      builder: (FormFieldState<AutocompleteOption> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label Style
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacingSmall, left: 4),
                child: Text(
                  widget.label!,
                  style: AppTypography.caption.copyWith(
                    color: state.hasError ? AppColors.colError : AppColors.colSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            SearchAnchor(
              searchController: _searchController,
              isFullScreen: false, // Prevents full-screen takeover on mobile
              viewConstraints: const BoxConstraints(maxHeight: 300),
              viewSurfaceTintColor: AppColors.colWhite,
              viewBackgroundColor: AppColors.colWhite,
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  hintText: widget.hintText,
                  hintStyle: WidgetStatePropertyAll(
                    AppTypography.body.copyWith(color: AppColors.colOnDisabled),
                  ),
                  textStyle: const WidgetStatePropertyAll(AppTypography.body),
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: const WidgetStatePropertyAll(AppColors.colWhite),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: AppSpacing.spacingMedium),
                  ),
                  // Border styling based on Focus and Error
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
                    side: BorderSide(
                      color: state.hasError
                          ? AppColors.colError
                          : (controller.isOpen ? AppColors.colPrimary : AppColors.colDisabled),
                      width: 2,
                    ),
                  )),
                  leading: Icon(
                    widget.prefixIcon ?? Icons.search,
                    color: state.hasError ? AppColors.colError : AppColors.colSecondary,
                    size: AppIconSizes.sizeMedium,
                  ),
                  trailing: [
                    IconButton(
                      icon: Icon(
                        controller.isOpen ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.colSecondary,
                      ),
                      onPressed: () => controller.openView(),
                    ),
                  ],
                  onTap: () => controller.openView(),
                  onChanged: (val) {
                    controller.openView();
                    state.didChange(null); // Reset validation state while typing
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                final String query = controller.text.toLowerCase();
                final filtered = widget.options
                    .where((opt) => opt.title.toLowerCase().contains(query))
                    .toList();

                if (filtered.isEmpty) {
                  return [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.spacingMedium),
                      child: Text("No results found", style: AppTypography.caption),
                    )
                  ];
                }

                return filtered.map((option) {
                  return ListTile(
                    leading: option.icon != null
                        ? Icon(option.icon, color: AppColors.colSecondary, size: 20)
                        : null,
                    title: Text(option.title, style: AppTypography.bodyBold),
                    subtitle: option.subtitle != null
                        ? Text(option.subtitle!, style: AppTypography.caption.copyWith(color: AppColors.colOnDisabled))
                        : null,
                    hoverColor: AppColors.colQuaternary.withOpacity(0.5),
                    onTap: () {
                      setState(() {
                        controller.closeView(option.title);
                        state.didChange(option);
                        widget.onSelected(option);
                      });
                    },
                  );
                });
              },
            ),

            // Error Message Style
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.spacingXSmall, left: 4),
                child: Text(
                  state.errorText!,
                  style: AppTypography.caption.copyWith(color: AppColors.colError),
                ),
              ),
          ],
        );
      },
    );
  }
}