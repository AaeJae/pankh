// ============================================================================
// QUEST MAP REDESIGN - CODE SNIPPETS
// Transform from 3D perspective to top-down isometric forest view
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import '../../constants/appDesignTokens.dart';
import '../../widgets/wid_uihelper.dart';
import 'quest_map_modular_assets.dart';

// ============================================================================
// SNIPPET 1: Main Screen with Top-Down Isometric View
// ============================================================================

class QuestSpatialMapScreen extends StatefulWidget {
  const QuestSpatialMapScreen({super.key});

  @override
  State<QuestSpatialMapScreen> createState() => _QuestSpatialMapScreenState();
}

class _QuestSpatialMapScreenState extends State<QuestSpatialMapScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // Path points - defines the winding path through the forest
  // Extended path for longer scrollable journey
  final List<Offset> _pathPoints = [
    // const Offset(0.5, 0.0),   // Start at horizon
    // const Offset(0.3, 0.15),  // Curve left
    // const Offset(0.6, 0.25),  // Swing right
    // const Offset(0.4, 0.35),  // Back left
    // const Offset(0.7, 0.45),  // Right again
    // const Offset(0.3, 0.55),  // Left
    // const Offset(0.6, 0.65),  // Right
    // const Offset(0.4, 0.75),  // Left
    // const Offset(0.5, 0.85),  // Center
    // const Offset(0.3, 0.95),  // Final curve

    const Offset(0.3, 0.95),  // Final curve
    const Offset(0.5, 0.85),  // Center
    const Offset(0.4, 0.75),  // Left
    const Offset(0.6, 0.65),  // Right
    const Offset(0.3, 0.55),  // Left
    const Offset(0.7, 0.45),  // Right again
    const Offset(0.6, 0.25),  // Swing right
    const Offset(0.3, 0.15),  // Curve left
    const Offset(0.5, 0.0),   // Start at horizon


  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  // Get position along the path for a given progress (0.0 to 1.0)
  Offset _getPathPosition(double progress, Size size, double skyHeight) {
    progress = progress.clamp(0.0, 1.0);
    final segmentIndex = (progress * (_pathPoints.length - 1)).floor();
    final nextIndex = (segmentIndex + 1).clamp(0, _pathPoints.length - 1);
    final segmentProgress = (progress * (_pathPoints.length - 1)) - segmentIndex;

    final p1 = _pathPoints[segmentIndex];
    final p2 = _pathPoints[nextIndex];

    // Smooth curve using bezier-like interpolation
    final x = p1.dx + (p2.dx - p1.dx) * segmentProgress;
    final y = p1.dy + (p2.dy - p1.dy) * segmentProgress;

    // Map to ground area only (below sky)
    final groundHeight = size.height - skyHeight;
    return Offset(x * size.width, skyHeight + (y * groundHeight));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double skyHeight = size.height * 0.2; // 20% for sky
    const double virtualScrollHeight = 25000.0; // Much longer scroll

    return Scaffold(
      backgroundColor: const Color(0xFF4A7C4E), // Forest floor green
      body: Stack(
        children: [
          // Sky area (fixed at top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: skyHeight,
            child: _buildSky(size, skyHeight),
          ),

          // Ground area with gradient
          Positioned(
            top: skyHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6B9B6E),
                    const Color(0xFF407345),
                  ],
                ),
              ),
            ),
          ),

          // Forest and path layers (clipped below horizon)
          Positioned.fill(
            top: skyHeight,
            child: ClipRect(
              child: Stack(
                children: [
                  ..._buildForestLayers(size, -50),
                  _buildPath(size, skyHeight),
                  ..._buildMilestones(size, skyHeight),
                ],
              ),
            ),
          ),

          // Scroll container
          SingleChildScrollView(
            controller: _scrollController,
            child: const SizedBox(
              height: virtualScrollHeight,
              width: double.infinity,
            ),
          ),

          // Top decorations
          _buildTopDecorations(size),

          // Back button
          const Positioned(
            top: 50,
            left: 20,
            child: BackButton(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Build forest layers with depth
  List<Widget> _buildForestLayers(Size size, double skyHeight) {
    final random = math.Random(42);
    final widgets = <Widget>[];
    print("size width: and size height: ${size.width}, ${size.height}");
    // Generate trees across the entire map (tripled to 240)
    for (int i = 0; i < 200; i++) {
      // Random position
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;

      // Check if too close to path - if so, skip or reposition
      bool tooCloseToPath = false;
      for (double progress = 0; progress <= 1.0; progress += 0.05) {
        final pathPos = _getPathPosition(progress, size, skyHeight);
        //print(skyHeight);
        final distance = (Offset(x, y) - pathPos).distance;

        if (distance < 100) { // Clearance radius
          tooCloseToPath = true;
          break;
        }
      }

      if (tooCloseToPath) continue;

      // Scale based on Y position (creates depth) with more variation
      double depthScale = 0.4 + (y / size.height) * 0.9;

      // Add random size variation (0.5x to 1.5x)
      double sizeVariation = 0.5 + random.nextDouble() * 1.0;
      double finalScale = depthScale * sizeVariation;

      // Random opacity variation (0.6 to 1.0)
      double opacity = 0.3 + random.nextDouble() * 0.4;

      // Random flip
      bool flipHorizontal = random.nextBool();

      widgets.add(
        Positioned(
          left: x - 30,
          top: y - 100,
          child: Opacity(
            opacity: opacity,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..scale(flipHorizontal ? -finalScale : finalScale, finalScale),
              child: MapAssetFactory.buildTree(
                seed: i,
                depth: y / size.height,
                scaleFactor: 0.9,
              ),
            ),
          ),
        ),
      );
    }

    // Add bushes/shrubs closer to path
    for (int i = 0; i < 30; i++) {
      double progress = random.nextDouble();
      final pathPos = _getPathPosition(progress, size, skyHeight);

      // Offset from path
      double offsetDist = 90 + random.nextDouble() * 50;
      double angle = random.nextDouble() * 2 * math.pi;

      double x = pathPos.dx + math.cos(angle) * offsetDist;
      double y = pathPos.dy + math.sin(angle) * offsetDist;

      widgets.add(
        Positioned(
          left: x - 20,
          top: y - 20,
          child: Opacity(
            opacity: 0.7,
            child: Container(
              width: 40,
              height: 30,
              child: UiHelper.customSvg(img: "/bushes/svgMapBush_1.svg"),

            ),
          ),
        ),
      );
    }

    return widgets;
  }

  // Build the winding path
  Widget _buildPath(Size size, double skyHeight) {
    return CustomPaint(
      size: size,
      painter: IsometricPathPainter(_pathPoints, size, skyHeight),
    );
  }

  // Build milestone nodes along the path (reduced density)
  List<Widget> _buildMilestones(Size size, double skyHeight) {
    final widgets = <Widget>[];

    // Reduced from 15 to 7 milestones for less density
    for (int i = 0; i < 7; i++) {
      final progress = i / 6.0; // 7 milestones from 0 to 1
      final pos = _getPathPosition(progress, size, skyHeight);

      final bool isCurrentPosition = i == 0; // Example: milestone 3 is current

      widgets.add(
        Positioned(
          left: pos.dx - 30,
          top: pos.dy - 30,
          child: _MilestoneNode(
            index: i,
            isCurrent: isCurrentPosition,
            isCompleted: i < 0,
          ),
        ),
      );
    }

    return widgets;
  }

  // Build sky with parallax clouds
  Widget _buildSky(Size size, double skyHeight) {
    return Container(
      width: size.width,
      height: skyHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // Sky blue at top
            Color(0xFFA8D5E2), // Lighter blue at horizon
          ],
        ),
      ),
      child: Stack(
        children: [
          // Layer 1: Far clouds (slow parallax)
          ...List.generate(4, (i) {
            final cloudSpeed = 0.2; // Slow movement
            final baseX = i * 250.0;
            final yPos = 20.0 + (i * 15.0);

            return Positioned(
              top: yPos,
              left: (baseX + (_scrollOffset * cloudSpeed)) % (size.width + 200) - 100,
              child: Opacity(
                opacity: 0.6,
                child: Transform.scale(
                  scale: 0.8,
                  child: MapAssetFactory.buildCloud(seed: i),
                ),
              ),
            );
          }),

          // Layer 2: Near clouds (faster parallax)
          ...List.generate(3, (i) {
            final cloudSpeed = 0.7; // Faster movement
            final baseX = i * 300.0 + 150;
            final yPos = 40.0 + (i * 20.0);

            return Positioned(
              top: yPos,
              left: (baseX + (_scrollOffset * cloudSpeed)) % (size.width + 200) - 100,
              child: Opacity(
                opacity: 0.9,
                child: MapAssetFactory.buildCloud(seed: i + 4),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Top decorations (goal, clouds, etc)
  Widget _buildTopDecorations(Size size) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Goal/nest at top
          SvgPicture.asset(
            'assets/svg/nest_icon.svg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'BOSS CHALLENGE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5F3D),
                  ),
                ),
                Text(
                  'PERFECT SCORE REQUIRED!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF2D5F3D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// ============================================================================
// SNIPPET 2: Isometric Path Painter
// ============================================================================

class IsometricPathPainter extends CustomPainter {
  final List<Offset> pathPoints;
  final Size screenSize;
  final double skyHeight;

  IsometricPathPainter(this.pathPoints, this.screenSize, this.skyHeight);

  @override
  void paint(Canvas canvas, Size size) {
    // Create smooth path through ground area only
    final path = Path();
    final groundHeight = screenSize.height - skyHeight;
    //final groundHeight = screenSize.height;

    for (int i = 0; i < pathPoints.length; i++) {
      final point = Offset(
        pathPoints[i].dx * screenSize.width,
        skyHeight + (pathPoints[i].dy * groundHeight),
        //(pathPoints[i].dy * groundHeight),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        // Get previous point
        final prevPoint = Offset(
          pathPoints[i - 1].dx * screenSize.width,
          skyHeight + (pathPoints[i - 1].dy * groundHeight),
        );

        // Create smooth curve
        final controlPoint1 = Offset(
          prevPoint.dx + (point.dx - prevPoint.dx) * 0.5,
          prevPoint.dy,
        );
        final controlPoint2 = Offset(
          prevPoint.dx + (point.dx - prevPoint.dx) * 0.5,
          point.dy,
        );

        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          point.dx, point.dy,
        );
      }
    }

    // Draw subtle glow effect (outer)
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Draw inner glow
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Draw main thin white line
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// SNIPPET 3: Milestone Node Widget
// ============================================================================

class _MilestoneNode extends StatelessWidget {
  final int index;
  final bool isCurrent;
  final bool isCompleted;

  const _MilestoneNode({
    required this.index,
    required this.isCurrent,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return _buildCurrentNode();
    } else if (isCompleted) {
      return _buildCompletedNode();
    } else {
      return _buildLockedNode();
    }
  }

  Widget _buildCurrentNode() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing circle background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: MapAssetFactory.buildBird(seed: index),
          ),
        ),
        // "You are here" label
        Positioned(
          top: -35,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6B9B6E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'YOU ARE HERE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedNode() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colPrimary.withValues(alpha:0.2),
      ),
      child: Center(
        child: MapAssetFactory.buildBird(seed: index),
      ),
    );
  }

  Widget _buildLockedNode() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colPrimary.withValues(alpha:0.9),
      ),
      child: Center(
        child: MapAssetFactory.buildBird(seed: index),
      ),
    );
  }
}

// ============================================================================
// SNIPPET 4: Updated MapAssetFactory for Top-Down View
// ============================================================================

class MapAssetFactory {
  static const String _treeBase = 'assets/svg/trees/svgMapTree_1.svg';
  static const String _birdBase = 'assets/svg/birds/svgMapBird_';
  static const String _cloudBase = 'assets/svg/clouds/svgMapCloud_';

  static Widget buildTree({
    required int seed,
    required double depth,
    required double scaleFactor,
  }) {
    final random = math.Random(seed);

    // Vary tree color based on depth (further = lighter/more faded)
    final Color baseColor = Color.lerp(
      const Color(0xFF1B5E20),
      const Color(0xFF4A7C4E),
      depth,
    )!;

    return SvgPicture.asset(
      _treeBase,
      colorFilter: ColorFilter.mode(baseColor, BlendMode.modulate),
      width: 60 * scaleFactor,
    );
  }

  static Widget buildBird({required int seed}) {
    final int index = (seed % 4) + 1;
    return SvgPicture.asset(
      '$_birdBase$index.svg',
      width: 30,
      height: 30,
    );
  }

  static Widget buildCloud({required int seed}) {
    final int index = (seed % 6) + 1;
    return SvgPicture.asset(
      '$_cloudBase$index.svg',
      width: 80,
    );
  }
}

// ============================================================================
// USAGE NOTES:
// ============================================================================
// 1. Replace your existing QuestSpatialMapScreen with SNIPPET 1
// 2. Add the IsometricPathPainter from SNIPPET 2
// 3. The _MilestoneNode widget (SNIPPET 3) handles different node states
// 4. Update your MapAssetFactory with SNIPPET 4
// 5. Adjust _pathPoints array to match your desired path shape
// 6. Trail is now a subtle thin white line with glow effect
// 7. Tree count increased to 240 with random size, opacity, and flip variations
// 8. Sky area is 20% of screen height with parallax clouds
// 9. Path and trees are clipped at horizon (below sky)
// 10. Milestone density reduced to 7 nodes for longer scrollable journey
// 11. Virtual scroll height is 25,000 for extended scrolling
// 12. Clouds move with parallax effect (2 layers at different speeds)
// 13. Add nest/goal icon asset at 'assets/svg/nest_icon.svg'
// ============================================================================