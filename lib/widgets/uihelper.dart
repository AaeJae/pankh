import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../domain/constants/appColors.dart';

class UiHelper {
  static Widget CustomImage({
    required String img,
    double? height,
    double? width,
    BoxFit? fit,
    Color? overlayColor = AppColors.colWhite,
    double? opacity = 1.0, // Default to fully opaque
  }) {
    final double effectiveOpacity = opacity ?? 1.0;
    final Color effectiveColor = overlayColor ?? Colors.white;

    return Image.asset(
      "assets/images/$img",
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      // Only apply the color/blend if the image is meant to be translucent
      color: effectiveOpacity < 1.0
          ? effectiveColor.withOpacity(1.0 - effectiveOpacity)
          : null,
      colorBlendMode: effectiveOpacity < 1.0 ? BlendMode.lighten : null,
    );
  }

  static CustomIcon({
    required String img,
    double? height,
    double? width,
    BoxFit? fit,
    Color? overlayColor,
    double? opacity,
  }) {
    final double effectiveOpacity = opacity ?? 1.0;
    final Color effectiveColor = overlayColor ?? Colors.white;

    return Image.asset(
      "assets/icons/$img",
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      // Applies the tint if opacity is less than 1.0
      color: effectiveOpacity < 1.0
          ? effectiveColor.withOpacity(1.0 - effectiveOpacity)
          : null,
      colorBlendMode: effectiveOpacity < 1.0 ? BlendMode.lighten : null,
    );
  }

  static CustomSvg({
    required String img,
    double? height,
    double? width,
    BoxFit? fit,
    Color? color,
  }) {
    return SvgPicture.asset(
      "assets/svg/$img",
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain, // Contain is usually safer for SVGs
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }


  static CustomText({
    required String text,
    required Color color,
    required double fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    TextAlign? textAlign,
  }) {
    return Text(text,
      textAlign: textAlign?? TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: fontFamily ?? "DM Serif Display",
      ),
    );
  }
}
