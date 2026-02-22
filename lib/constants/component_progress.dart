import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';

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
    this.thickness = AppSpacing.spacingSmall, // Default per your request
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
                Text(labelLeft!, style: AppTypography.body),
              if (labelRight != null)
                Text(labelRight!, style: AppTypography.bodyBold),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingXSmall),
        ],

        // The Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.radiusXLarge), // High rounding for pill shape
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