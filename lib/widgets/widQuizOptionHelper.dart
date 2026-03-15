import 'package:flutter/material.dart';
import '../../../widgets/wid_uihelper.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class WidQuizOptions extends StatelessWidget {
  final List<Map<String, String>> options;
  final String optionSize;
  final Function(String) onOptionSelected;

  const WidQuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    required this.optionSize,
  });

  @override
  Widget build(BuildContext context) {
    // If we have no options, return empty
    if (options.isEmpty) return const SizedBox.shrink();

    // Logic: If 'big' (audio mode), show 2x2 grid. If 'small', show 1x4 list.
    bool isSmall = optionSize == "small";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.screenEdge),
      child: isSmall ? _buildSmallList() : _buildBigGrid(),
    );

  }

  Widget _buildSmallList() {
    return Column(
      children: options.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sizeMedium),
          child: AppButton(
            label: item['name']!,
            variant: AppButtonVariant.flat,
            onPressed: () => onOptionSelected(item['name']!),
          ),
        );
      }).toList(),
    );
  }

  // Optimized for Audio Questions (2x2 Grid using Rows)
  Widget _buildBigGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildGridItem(0)),
            const SizedBox(width: 10),
            Expanded(child: _buildGridItem(1)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildGridItem(2)),
            const SizedBox(width: 10),
            Expanded(child: _buildGridItem(3)),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(int index) {
    if (index >= options.length) return const SizedBox.shrink();
    final item = options[index];
    return InkWell(
      onTap: () => onOptionSelected(item['name']!),
      child: _buildBigOption(item['name']!, item['image']!),
    );
  }


  // --- BIG STYLE: Premium Card Aesthetic ---
  Widget _buildBigOption(String name, String imgPath) {
    return Container(
      height: 120, // CRITICAL: Added fixed height for the Stack to expand into
      child: AppCard(
        subtitle: name,
        image: imgPath,

      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha:0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 4),
      //     )
      //   ],
      // ),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(30),
      //   child: Stack(
      //     fit: StackFit.expand,
      //     children: [
      //       // Bird Image background
      //       UiHelper.customImage(
      //         img: imgPath,
      //         fit: BoxFit.cover,
      //       ),
      //       // Darkening Gradient
      //       Container(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [
      //               Colors.black.withValues(alpha:0.1),
      //               Colors.black.withValues(alpha:0.7), // Slightly darker for legibility
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Label
      //       Align( // Using Align instead of Center for bottom-aligned modern look
      //         alignment: Alignment.bottomCenter,
      //         child: Padding(
      //           padding: const EdgeInsets.all(12.0),
      //           child: UiHelper.customText(
      //               text: name,
      //               textAlign: TextAlign.center,
      //               color: AppColors.colOnPrimary,
      //               fontSize: AppFontSizes.fontSizeSubtitle, // Use a fixed size if AppFontSizes is failing
      //               fontWeight: FontWeight.normal,
      //               fontFamily: AppTypography.fontSubtitle
      //           ),
      //         ),
      //       ),
      //     ],


    );
  }

  // --- SMALL STYLE: Elegant "Pill" Buttons ---
  Widget _buildSmallOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sizeXXXSmall), // Space between pills
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.sizeSmall),
        decoration: BoxDecoration(
          color: AppColors.colSecondary.withAlpha(AppAlpha.alphaHigh),
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge), // Keeps the "pill" shape
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
            child: UiHelper.customText(text: text, textAlign: TextAlign.center, color: AppColors.colOnPrimary, fontSize: AppFontSizes.fontSizeSubtitle)


        ),
      ),
    );
  }
}