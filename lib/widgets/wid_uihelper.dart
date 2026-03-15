import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/appTokens.dart';


class UiHelper {
  static Widget customImage({
    required String img,
    double? height,
    double? width,
    BoxFit? fit,
    Color? overlayColor,
    double? opacity = 1.0,
  }) {
    final bool isNetwork = img.startsWith("http");
    final String path = isNetwork ? img : "assets/images/$img";

    // Use a ColorFilter for opacity/tinting instead of color/blendMode
    // This is more performant and predictable in Flutter
    Widget imageWidget = isNetwork
      ? Image.network(
        path,
        height: height,
        width: width,
        // ADD THESE TWO LINES
        cacheWidth: width != null ? (width * 2).toInt() : null,
        cacheHeight: height != null ? (height * 2).toInt() : null,
        fit: fit ?? BoxFit.cover,
        // Loading placeholder to prevent "popping"
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: height,
            width: width,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, color: Colors.white54),
      )
      : Image.asset(
        path,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );

    // Apply Opacity/Tinting only if needed
    if (opacity != null && opacity < 1.0) {
      return Opacity(
        opacity: opacity,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  static customIcon({
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
          ? effectiveColor.withValues(alpha:1.0 - effectiveOpacity)
          : null,
      colorBlendMode: effectiveOpacity < 1.0 ? BlendMode.lighten : null,
    );
  }

  static customSvg({
    required String img,
    double? height,
    double? width,
    BoxFit? fit,
    Color? color,
    double? opacity, // 1. Add this parameter
  }) {
    Widget svg = SvgPicture.asset(
      "assets/svg/$img",
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );

    // 2. Wrap with Opacity if needed
    if (opacity != null) {
      return Opacity(
        opacity: opacity,
        child: svg,
      );
    }
    return svg;
  }


  static Widget customText({
    required String text,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.start,
    TextOverflow? overflow = TextOverflow.ellipsis, // Default to ellipsis
    int? maxLines, // Added parameter
    String? fontFamily,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines, // Pass it here
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }



  ///////////////////
  // ACHIEVEMENT BADGE BUILDER
  //////////////////
  static Widget badgeBuilder(String name, IconData icon, {bool isUnlocked = false}) {
    return Padding(
      padding: const EdgeInsets.only(left:15, right: 15),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked ? AppColors.colPrimary.withValues(alpha:0.7) : Colors.grey[100],
            ),
            child: Icon(
              icon,
              color: isUnlocked ? AppColors.colOnTertiary : Colors.grey[400],
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          customText(
            text: name,
            fontSize: AppFontSizes.fontSizeBody,
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
            color: isUnlocked ? AppColors.colPrimary : Colors.grey,
          ),
        ],
      ),
    );
  }


  ///////////////////
  // STAT CARD BUILDER
  //////////////////
  static Widget statCardBuilder(String label, String value, IconData icon, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha:0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.colPrimary, size: 24),
            ),
            const SizedBox(height: 8),
            UiHelper.customText(
              text: value,
              fontSize: AppFontSizes.fontSizeTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.colPrimary,
            ),
            UiHelper.customText(
              text: label,
              fontSize: AppFontSizes.fontSizeCaption,
              color: AppColors.colPrimary.withValues(alpha:0.6),
            ),
          ],
        ),
      ),
    );
  }




}



