import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class AppDialog {
  static Future<T?> show<T>(
      BuildContext context, {
        required String title,
        required Widget subtitle,
        bool isClosable = true,
        required List<AppButton> items,
      }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isClosable,
      builder: (context) => _AppModalDialog<T>(
        title: title,
        subtitle: subtitle,
        isClosable: isClosable,
        items: items,
      ),
    );
  }
}

class _AppModalDialog<T> extends StatelessWidget {
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
      backgroundColor: AppColors.colSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.sizeMedium)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sizeSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: AppTypography.subtitle2.copyWith(fontWeight: FontWeight.bold))),
                if (isClosable)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.colPrimary, size: AppSizes.sizeSmall,),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sizeSmall),
            subtitle,
            if (items.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sizeMedium),
              Wrap(
                spacing: AppSizes.sizeXSmall,
                runSpacing: AppSizes.sizeXSmall,
                alignment: WrapAlignment.end,
                children: items,
              ),
            ],
          ],
        ),
      ),
    );
  }
}