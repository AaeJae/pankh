import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import 'wid_uihelper.dart';

class WidPullMenu extends StatelessWidget {
  final String title;
  final String challengeTitle;
  final String challengeSubtitle;
  final String challengeLabel; // e.g., "DAY 2 OF 7"
  final double progressValue; // 0.0 to 1.0
  final List<Map<String, dynamic>> challengeDots;
  final String blitzTitle;
  final IconData blitzIcon;
  final VoidCallback onBlitzTap;

  const WidPullMenu({
    super.key,
    this.title = "Daily Practice",
    this.challengeTitle = "Color Palette",
    this.challengeSubtitle = "Spot specific colors today.",
    this.challengeLabel = "WEEKLY CHALLENGE",
    this.progressValue = 0.4,
    required this.challengeDots,
    this.blitzTitle = "Play \n BLITZ QUIZ",
    this.blitzIcon = Icons.bolt,
    required this.onBlitzTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic bottom padding for system bars
    final double bottomSafePadding = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.23,
      minChildSize: 0.23,
      maxChildSize: 0.75,
      snap: true,
      builder: (context, scrollController) {
        return AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            double expandFactor = 0.0;
            if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
              expandFactor = (scrollController.offset / scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 0), // side margin
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: ListView(
                controller: scrollController,
                // Adaptive padding: ensures content clears the sticky bot menu
                padding: EdgeInsets.fromLTRB(20, 4, 20, 100 + bottomSafePadding),
                children: [
                  _buildHandle(),
                  UiHelper.customText(text: title, fontSize: 14, fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildTransformingBox(expandFactor)),
                      const SizedBox(width: 12),
                      Expanded(flex: 3, child: _buildBlitzButton()),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        width: 45, height: 5,
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTransformingBox(double factor) {
    double height = lerpDouble(65, 250, factor)!;
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(20,5, 20, 5),
      decoration: BoxDecoration(
        color: AppColors.colPrimary.withOpacity(0.03 + (factor * 0.07)),
        border: Border.all(color: AppColors.colPrimary.withOpacity(0.2), width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: factor < 0.25 ? _buildPeekContent() : _buildExpandedContent(factor),
    );
  }

  Widget _buildPeekContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UiHelper.customText(text: challengeLabel, fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.colPrimary),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildMiniDot(challengeDots[0]['color'], challengeDots[0]['isDone']),
            _buildMiniDot(challengeDots[1]['color'], challengeDots[1]['isDone']),
            const SizedBox(width: 6),
            UiHelper.customText(text: challengeTitle, fontSize: 13, fontWeight: FontWeight.bold),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedContent(double factor) {
    return Opacity(
      opacity: ((factor - 0.25) / 0.75).clamp(0.0, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiHelper.customText(text: "GOAL FOR TODAY", fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.colPrimary),
          const SizedBox(height: 8),
          UiHelper.customText(text: challengeTitle, fontSize: 18, fontWeight: FontWeight.bold),
          const SizedBox(height: 4),
          UiHelper.customText(text: challengeSubtitle, fontSize: 12, color: Colors.black54),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: challengeDots.map((dot) => _buildLargeDot(dot['color'], dot['label'], dot['isDone'])).toList(),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progressValue, minHeight: 6, backgroundColor: Colors.black12, color: AppColors.colPrimary),
        ],
      ),
    );
  }

  Widget _buildBlitzButton() {
    return GestureDetector(
      onTap: onBlitzTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(color: AppColors.colPrimary, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(blitzIcon, color: Colors.amber, size: 20),
            UiHelper.customText(text: blitzTitle, fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDot(Color color, bool checked) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 14, height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: checked ? const Icon(Icons.check, size: 9, color: Colors.white) : null,
    );
  }

  Widget _buildLargeDot(Color color, String label, bool checked) {
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: checked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
        ),
        const SizedBox(height: 4),
        UiHelper.customText(text: label, fontSize: 8, color: Colors.black45),
      ],
    );
  }
}