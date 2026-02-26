import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignTokens.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool showCurrentValue;
  final ValueChanged<double> onChanged;
  final List<String>? customLabels;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.showCurrentValue = true,
    this.customLabels,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTextMode = customLabels != null && customLabels!.isNotEmpty;
    final int? effectiveDivisions = isTextMode ? customLabels!.length - 1 : divisions;

    String getDisplayValue() {
      if (isTextMode) {
        // Ensure index is within bounds
        int index = ((value - min) / (max - min) * (customLabels!.length - 1)).round();
        index = index.clamp(0, customLabels!.length - 1);
        return customLabels![index];
      }
      return divisions != null ? value.round().toString() : value.toStringAsFixed(2);
    }

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.colTertiary,
        inactiveTrackColor: AppColors.colOnPrimary,
        thumbColor: AppColors.colPrimary,
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: AppSizes.sizeXXXSmall),
        activeTickMarkColor: AppColors.colTertiary,
        inactiveTickMarkColor: AppColors.colDisabled.withAlpha(AppAlpha.alphaHigh),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: AppSizes.sizeXSmall, elevation: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!, style: AppTypography.body),
              if (showCurrentValue)
                Text(
                    getDisplayValue(), // Updated to show text label instead of number
                    style: AppTypography.bodyBold
                ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: effectiveDivisions, // Updated from divisions to effectiveDivisions
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isTextMode ? customLabels!.first : min.round().toString(),
                  style: AppTypography.caption),
              Text(isTextMode ? customLabels!.last : max.round().toString(),
                  style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class AppRangeSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions; // Added for snapping (e.g., years)
  final String? label;
  final bool showCurrentValues;
  final ValueChanged<RangeValues> onChanged;


  const AppRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.showCurrentValues = true,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.colTertiary,
        inactiveTrackColor: AppColors.colDisabled.withAlpha(26),
        thumbColor: AppColors.colPrimary,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!, style: AppTypography.body),
              if (showCurrentValues)
                Text(
                  "${values.start.round()} - ${values.end.round()}", // round() for clean years
                  style: AppTypography.bodyBold,
                ),
            ],
          ),
          RangeSlider(
            values: values,
            min: min,
            max: max,
            divisions: divisions, // Snapping points
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.round().toString(), style: AppTypography.caption),
              Text(max.round().toString(), style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}