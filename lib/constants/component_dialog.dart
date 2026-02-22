import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';
import 'package:pankh/constants/component_button.dart';

class AppDialog {
  static Future<void> show(
      BuildContext context, {
        required String title,
        required Widget subtitle,
        bool isClosable = true,
        required List<AppButton> items,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: isClosable,
      builder: (context) => _AppModalDialog(
        title: title,
        subtitle: subtitle,
        isClosable: isClosable,
        items: items,
      ),
    );
  }
}

class _AppModalDialog extends StatelessWidget {
  final String title;
  final Widget subtitle;
  final bool isClosable;
  final List<AppButton> items;

  const _AppModalDialog({
    required this.title,
    required this.subtitle,
    required this.isClosable,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.colWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.radiusMedium),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wraps content height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title, style: AppTypography.subtitle1),
                ),
                if (isClosable)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.colDisabled),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingMedium),

            // Subtitle area (Supports text, links, images)
            subtitle,

            const SizedBox(height: AppSpacing.spacingXXLarge),

            // Action Buttons
            // We use Wrap to handle cases where buttons might overflow horizontally
            Wrap(
              spacing: AppSpacing.spacingSmall,
              runSpacing: AppSpacing.spacingSmall,
              alignment: WrapAlignment.end,
              children: items,
            ),
          ],
        ),
      ),
    );
  }
}