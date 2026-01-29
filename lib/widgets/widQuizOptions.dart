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
    int crossAxisCount = (size == QuizOptionSize.small) ? 1 : 2;
    // Adjusted ratio to ensure buttons aren't too tall on small screens
    double aspectRatio = (size == QuizOptionSize.small) ? 5.5 : 1.1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 2, // Tighter spacing for elegance
        childAspectRatio: aspectRatio,
      ),
      itemCount: options.length > 4 ? 4 : options.length,
      itemBuilder: (context, index) {
        final item = options[index];
        final name = item['name'] ?? "";
        final img = item['image'] ?? "";

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onOptionSelected(name),
            child: size == QuizOptionSize.big
                ? _buildBigOption(name, img)
                : _buildSmallOption(name),
          ),
        );
      },
    );
  }

  // --- BIG STYLE: Premium Card Aesthetic ---
  Widget _buildBigOption(String name, String imgPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Bird Image background
            UiHelper.CustomImage(
              img: imgPath,
              fit: BoxFit.cover,
            ),
            // Darkening Gradient for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Label
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: UiHelper.CustomText(
                  text: name,
                  color: Colors.white,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                  fontFamily: "Laila", // Using Laila for the Bharat look
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SMALL STYLE: Elegant "Pill" Buttons ---
  Widget _buildSmallOption(String name) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Subtle purple gradient inspired by your screenshot
        gradient: LinearGradient(
          colors: [
            AppColors.colSecondary,
            AppColors.colSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.colSecondary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: UiHelper.CustomText(
        text: name,
        color: Colors.white,
        fontSize: 18,
        fontFamily: "Laila", // Consistent Bharat branding
        fontWeight: FontWeight.w200,
      ),
    );
  }
}