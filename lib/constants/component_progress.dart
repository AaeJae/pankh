import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignTokens.dart';

class AppProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String? labelLeft;
  final String? labelRight;
  final Color? color;
  final double thickness;

  const AppProgress({
    super.key,
    required this.value,
    this.labelLeft,
    this.labelRight,
    this.color,
    this.thickness = AppSizes.sizeXXSmall, // Default per your request
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label Row (Only renders if at least one label is provided)
        if (labelLeft != null || labelRight != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (labelLeft != null)
                Text(labelLeft!, style: AppTypography.subtitle2.copyWith(color: AppColors.colOnPrimary)),
              if (labelRight != null)
                Text(labelRight!, style: AppTypography.subtitle2.copyWith(color: AppColors.colOnPrimary)),
            ],
          ),
          const SizedBox(height: AppSizes.sizeSmall),
        ],

        // The Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.sizeCircular), // High rounding for pill shape
          child: LinearProgressIndicator(
            value: value,
            minHeight: thickness,
            backgroundColor: AppColors.colDisabled.withAlpha(AppAlpha.alphaLow), // Misty background
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.colTertiary, // Default to Sun Golden per your image
            ),
          ),
        ),
      ],
    );
  }
}