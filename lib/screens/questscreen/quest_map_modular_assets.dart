import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class MapAssetFactory {
  static const String _treeBase = 'assets/svg/trees/svgMapTree_1.svg';
  static const String _birdBase = 'assets/svg/birds/svgMapBird_';
  static const String _cloudBase = 'assets/svg/clouds/svgMapCloud_';

  static Widget buildTree({
    required int seed,
    required double depth,
    required double scaleFactor
  }) {
    final random = math.Random(seed);
    final bool flip = random.nextBool();

    // Atmospheric color variation: further trees (lower depth) are lighter/bluer
    final Color tint = Color.lerp(
      const Color(0xFF1B5E20), // Rich forest green for close trees
      const Color(0xFFB3E5FC).withOpacity(0.6), // Misty blue for horizon trees
      (1.0 - depth).clamp(0.0, 1.0),
    )!;

    return Transform(
      alignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..scale(flip ? -scaleFactor : scaleFactor, scaleFactor),
      child: SvgPicture.asset(
        _treeBase,
        colorFilter: ColorFilter.mode(tint, BlendMode.modulate),
      ),
    );
  }

  static Widget buildBird({required int seed}) {
    final int index = (seed % 4) + 1;
    return SvgPicture.asset('$_birdBase$index.svg', width: 40);
  }

  static Widget buildCloud({required int seed}) {
    final int index = (seed % 6) + 1;
    return SvgPicture.asset('$_cloudBase$index.svg', width: 80);
  }
}