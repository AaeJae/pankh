import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/widgets/wid_dialog.dart';
import 'package:pankh/widgets/wid_uihelper.dart';

class SizeMattersScreen extends StatefulWidget {
  const SizeMattersScreen({super.key});

  @override
  State<SizeMattersScreen> createState() => _SizeMattersScreenState();
}

class _SizeMattersScreenState extends State<SizeMattersScreen> {
  // CONFIGURATION
  // A Red-vented Bulbul is ~20cm, a Phone is ~16cm.
  // So the Bulbul should be ~1.25x the height of the phone.
  final double targetScale = 1.25;
  final double tolerance = 0.15; // 15% margin of error

  // STATE
  double _currentScale = 0.5; // Initial tiny bird
  bool _gameEnded = false;

  void _checkSize() {
    final double difference = (_currentScale - targetScale).abs();
    final bool isCorrect = difference <= tolerance;

    if (isCorrect) {
      setState(() => _gameEnded = true);
      WidDialog.customDialog(
        context,
        "PERFECT SIZE!",
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.straighten, color: Colors.white, size: 50),
            const SizedBox(height: 15),
            UiHelper.customText(
              text: "Spot on! A Bulbul is indeed about 20cm long, slightly larger than a standard smartphone.",
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        [DialogPill(label: "Next Level", action: "next")],
        canClose: false,
      );
    } else {
      WidDialog.customDialog(
        context,
        "NOT QUITE...",
        UiHelper.customText(
          text: _currentScale < targetScale
              ? "A bit too small! Try making the bird a little larger."
              : "Too big! That's more like a hawk size.",
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        [DialogPill(label: "Adjust Size", action: "retry")],
        canClose: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: UiHelper.customText(text: "Size Matters", fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          UiHelper.customText(
            text: "Scale the Bulbul to its real-life size\nrelative to the phone!",
            textAlign: TextAlign.center,
            fontSize: AppFontSizes.fontSizeBody,
          ),

          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // REFERENCE OBJECT (Mobile Phone)
                  UiHelper.customImage(
                    img: "mobilePhone.png",
                    height: 250,
                    fit: BoxFit.contain,
                  ),

                  // ADJUSTABLE BIRD
                  Transform.scale(
                    scale: _currentScale,
                    child: UiHelper.customSvg(
                      img: "svgBulbul.svg",
                      height: 250, // Base height matches phone for 1.0 scale
                      color: AppColors.colPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CONTROLS
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 50),
      decoration: BoxDecoration(
        color: AppColors.colPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          UiHelper.customText(
            text: "SLIDE TO RESIZE",
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          Slider(
            value: _currentScale,
            min: 0.3,
            max: 2.5,
            activeColor: AppColors.colOnTertiary,
            inactiveColor: Colors.white24,
            onChanged: _gameEnded ? null : (val) => setState(() => _currentScale = val),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _gameEnded ? null : _checkSize,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: UiHelper.customText(
                text: "CONFIRM SIZE",
                color: AppColors.colPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }1
}