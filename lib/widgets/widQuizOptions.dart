import 'package:flutter/material.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/constants/appTokens.dart';

enum QuizOptionSize { small, big }

class WidQuizOptions extends StatelessWidget {
  final List<Map<String, String>> options;
  final QuizOptionSize size;
  final Function(String) onOptionSelected;

  const WidQuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.size = QuizOptionSize.big,
  });

  @override
  Widget build(BuildContext context) {
    // 1x4 for small, 2x2 for big
    int crossAxisCount = (size == QuizOptionSize.small) ? 1 : 2;

    // Wide bars for small (e.g. 5:1 ratio), Squares for big (1:1 ratio)
    double aspectRatio = (size == QuizOptionSize.small) ? 5.0 : 1.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: aspectRatio,
      ),
      itemCount: 4, // no of options to be shown
      itemBuilder: (context, index) {
        final item = options[index];
        final name = item['name'] ?? "";
        final img = item['image'] ?? "";

        return GestureDetector(
          onTap: () => onOptionSelected(name),
          child: size == QuizOptionSize.big
              ? _buildBigOption(name, img)
              : _buildSmallOption(name),
        );
      },
    );
  }

  // BIG STYLE: Image background with text on top
  Widget _buildBigOption(String name, String imgPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        alignment: Alignment.center,
        children: [
          UiHelper.CustomImage(
            img: imgPath,
            opacity: 0.6,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          UiHelper.CustomText(
            text: name,
            color: AppColors.colPurple,
            fontSize: 18,
            textAlign: TextAlign.center,
            fontFamily: "KantumruyPro",
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  // SMALL STYLE: SVG background with text on top
  Widget _buildSmallOption(String name) {
    return Stack(
      alignment: Alignment.center,
      children: [
        UiHelper.CustomSvg(
          img: "svgStyledRect.svg",
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          opacity: 0.8,
        ),
        UiHelper.CustomText(
          text: name,
          color: AppColors.colBlack,
          fontSize:20,
          fontFamily: "KantumruyPro",
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
