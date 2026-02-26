import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignTokens.dart';
import 'package:pankh/widgets/widQuizHelper.dart';

import 'package:pankh/constants/appDesignSystem.dart';
import '../../widgets/wid_uihelper.dart';

class BinocsSpotterScreen extends StatefulWidget {
  const BinocsSpotterScreen({super.key});

  @override
  State<BinocsSpotterScreen> createState() => _BinocsSpotterScreenState();
}

class _BinocsSpotterScreenState extends State<BinocsSpotterScreen> {
  final TransformationController _transformController = TransformationController();

  // Game Configuration
  final double apertureRadius = 200.0;
  final Offset correctLocation = const Offset(400, 300); // was 800, 560
  final String correctBirdName = "SHIKRA";

  // State
  int _secondsLeft = 120;
  double _sliderValue = 0.0; // 0 (Max blur) to 20 (Clear)
  Offset? _spotlightPos;
  Timer? _timer;
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _transformController.value = Matrix4.identity()..scale(1.5);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0 && !_gameEnded) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        // Handle timeout logic here
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _transformController.dispose();
    super.dispose();
  }

  // Focus value inside binocs: 20 is max blur, 0 is clear.
  // We invert the slider (0-20) so sliding right increases clarity.
  double get _internalBlur => (10.0 - _sliderValue).clamp(0.0, 20.0);

  void _updateInteraction(dynamic details) {
    if (_gameEnded) return;
    setState(() {
      _spotlightPos = details.localFocalPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. SCROLLABLE FOREST
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformController,
              boundaryMargin: EdgeInsets.zero,
              onInteractionUpdate: (details) => _updateInteraction(details),
              child: Image.asset("assets/images/shikra.jpg", fit: BoxFit.cover),
            ),
          ),

          // 2. BLUR LAYERS
          // If no tap yet, blur the whole screen. If tapped, show the binocular hole.
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // Layer A: Environment Blur (Always 10% outside the circle, or 10% everywhere if no tap)
                  Positioned.fill(
                    child: ClipPath(
                      clipper: _spotlightPos == null ? null : InvertedBinocularClipper(_spotlightPos!, apertureRadius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                  ),

                  // Layer B: Binocular Lens Blur (Variable focus inside the circle)
                  if (_spotlightPos != null)
                    Positioned.fill(
                      child: ClipPath(
                        clipper: CircleClipper(_spotlightPos!, apertureRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: _internalBlur, sigmaY: _internalBlur),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 3. UI OVERLAY
          SafeArea(
            child: Column(
              children: [
                _buildTopTimer(),
                const Spacer(),
                if (_spotlightPos == null) _buildInstructionText(),
                _buildControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTimer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Time before bird flies: ",
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          // WidQuizHelper.infoChip(
          //   WidQuizHelper.formatTime(Duration(seconds: _secondsLeft)),
          //   color: _secondsLeft < 10 ? Colors.red : Colors.black45,
          // ),
        ],
      ),
    );
  }

  Widget _buildInstructionText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
      child: const Text(
        "Tap to pick your binocular.\nSpot the bird before it flies away!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      child: Column(
        children: [
          const Text("FOCUS BINOCULARS", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2)),
          Slider(
            value: _sliderValue,
            min: 0, max: 20,
            activeColor: AppColors.colOnTertiary,
            onChanged: (val) => setState(() => _sliderValue = val),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, // Matches slider width
            height: 55,
            child: ElevatedButton(
              onPressed: _spotlightPos == null ? null : _showBirdSelectionModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("CONFIRM SIGHTING", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showBirdSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => _BirdSearchModal(
        onSelect: (selectedName) => _validateWin(selectedName),
      ),
    );
  }

  void _validateWin(String name) {
    if (_spotlightPos == null) return;

    // 1. Get the current zoom scale from the controller matrix
    // Matrix4 element at [0] is the scale factor
    final double currentZoom = _transformController.value.getMaxScaleOnAxis();

    // 2. Convert tap to scene coordinates
    final Offset scenePos = _transformController.toScene(_spotlightPos!);
    final double distance = (scenePos - correctLocation).distance;

    // 3. Define Margin of Error
    // Base radius is 150. We add a 'buffer' that shrinks as you zoom in
    // to keep the difficulty consistent, or grows to be more forgiving.
    const double baseMarginOfError = 40.0;
    double dynamicWinningRadius = apertureRadius + (baseMarginOfError / currentZoom);

    // 4. Print for Debugging
    print("Current Zoom: ${currentZoom.toStringAsFixed(2)}x");
    print("Distance to Bird: ${distance.toStringAsFixed(2)}");
    print("Allowed Radius (with margin): ${dynamicWinningRadius.toStringAsFixed(2)}");

    bool isCorrectSpot = distance <= dynamicWinningRadius;
    bool isCorrectName = name.toUpperCase() == correctBirdName;
    if (isCorrectSpot && isCorrectName) {
      setState(() => _gameEnded = true);
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("BIRD SPOTTED! YOU WIN!")));

      // SUCCESS DIALOG
      // WidDialog.customDialog(
      //   context,
      //   "TARGET ACQUIRED!",
      //   Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       const Icon(Icons.auto_awesome, color: Colors.white, size: 50),
      //       const SizedBox(height: 15),
      //       UiHelper.customText(
      //         text: "Excellent eye! You spotted the $correctBirdName.",
      //         color: Colors.white,
      //         textAlign: TextAlign.center,
      //         fontSize: AppFontSizes.fontSizeBody,
      //       ),
      //     ],
      //   ),
      //   [
      //     DialogPill(label: "Collect XP", action: "collect_reward"),
      //   ],
      //   canClose: false,
      // ).then((action) {
      //   if (action == "collect_reward") Navigator.pop(context);
      // });

    } else {
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not quite right. Keep looking!")));
      // FAILURE DIALOG
      // WidDialog.customDialog(
      //   context,
      //   "NOT QUITE...",
      //   Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       const Icon(Icons.search_off, color: Colors.white, size: 50),
      //       const SizedBox(height: 15),
      //       UiHelper.customText(
      //         text: !isCorrectSpot
      //             ? "The bird isn't in your viewfinder."
      //             : "Bird spotted, but it's not ${name}",
      //         color: Colors.white,
      //         textAlign: TextAlign.center,
      //         fontSize: AppFontSizes.fontSizeBody,
      //       ),
      //     ],
      //   ),
      //   [
      //     DialogPill(label: "Try Again", action: "retry"),
      //   ],
      //   canClose: true,
      // );

    }
  }
}

// Bird Search Modal Component
class _BirdSearchModal extends StatefulWidget {
  final Function(String) onSelect;
  const _BirdSearchModal({required this.onSelect});

  @override
  State<_BirdSearchModal> createState() => _BirdSearchModalState();
}

class _BirdSearchModalState extends State<_BirdSearchModal> {
  String _query = "";
  final List<String> _birdList = ["SHIKRA", "ASIAN OPENBILL", "ASHY DRONGO", "INDIAN PEAFOWL", "GREAT HORNBILL"];

  @override
  Widget build(BuildContext context) {
    final filtered = _birdList.where((b) => b.contains(_query.toUpperCase())).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter bird name...",
                prefixIcon: const Icon(Icons.search, color: AppColors.colPrimary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(filtered[i], style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelect(filtered[i]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvertedBinocularClipper extends CustomClipper<Path> {
  final Offset pos;
  final double radius;
  InvertedBinocularClipper(this.pos, this.radius);
  @override
  Path getClip(Size size) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: pos, radius: radius));
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CircleClipper extends CustomClipper<Path> {
  final Offset pos;
  final double radius;
  CircleClipper(this.pos, this.radius);
  @override
  Path getClip(Size size) => Path()..addOval(Rect.fromCircle(center: pos, radius: radius));
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}