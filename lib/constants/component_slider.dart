import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions; // Added for snapping
  final String? label;
  final bool showCurrentValue;
  final ValueChanged<double> onChanged;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions, // Pass this for discrete steps
    this.label,
    this.showCurrentValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.colTertiary,
        inactiveTrackColor: AppColors.colDisabled.withAlpha(26),
        thumbColor: AppColors.colPrimary,
        // Customizing the tick marks (dots)
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
        activeTickMarkColor: AppColors.colTertiary,
        inactiveTickMarkColor: AppColors.colDisabled.withAlpha(50),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10.0,
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
              if (showCurrentValue)
                Text(
                  // Using round() for discrete sliders, or toStringAsFixed(2) for continuous
                    divisions != null ? value.round().toString() : value.toStringAsFixed(2),
                    style: AppTypography.bodyBold
                ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions, // This enables the snapping
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