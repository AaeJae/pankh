import 'package:flutter/material.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/domain/constants/appColors.dart';

enum QuizOptionSize { small, big }

class QuizOptions extends StatelessWidget {
  final List<Map<String, String>> options;
  final QuizOptionSize size;
  final Function(String) onOptionSelected;

  const QuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.size = QuizOptionSize.big, // Default to your 2x2 grid
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      // If small, maybe you want more columns or different scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: size == QuizOptionSize.big ? 1.0 : 2.5, // Slimmer for small
      ),
      padding: const EdgeInsets.all(20),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final item = options[index];
        return GestureDetector(
          onTap: () => onOptionSelected(item['name']!),
          child: size == QuizOptionSize.big
              ? _buildBigOption(item['name']!, item['image']!)
              : _buildSmallOption(item['name']!),
        );
      },
    );
  }

  // BIG STYLE: Image with 60% opacity overlay
  Widget _buildBigOption(String name, String imgPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: AssetImage(imgPath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.6),
            BlendMode.screen,
          ),
        ),
      ),
      child: Center(
        child: UiHelper.CustomText(
          text: name,
          color: AppColors.colPurple,
          fontSize: 18,
          textAlign: TextAlign.center,
          fontFamily: "KantumruyPro",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // SMALL STYLE: Just text on the svgStyledRect
  Widget _buildSmallOption(String name) {
    return Stack(
      alignment: Alignment.center,
      children: [
        UiHelper.CustomSvg(
          img: "svgStyledRect.svg",
          fit: BoxFit.fill,
        ),
        UiHelper.CustomText(
          text: name,
          color: Colors.white,
          fontSize: 16,
          fontFamily: "KantumruyPro",
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}