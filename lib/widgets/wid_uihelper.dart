import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_tokens.dart';


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


  static customText({
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

  static Widget buildSectionHeaderWithPills(String title, List<String> filterPills, {String? currentFilter, Function(String)? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiHelper.customText(
            text: title,
            fontSize: AppFontSizes.fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: AppColors.colPrimary,
          ),
          if (filterPills.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filterPills.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = filterPills[index];
                  final isSelected = label == currentFilter;
                  // First pill is unlocked, others are "locked" for this skeleton
                  final bool isPillLocked = index > 0;

                  return GestureDetector(
                    onTap: () => onTap?.call(label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.colPrimary.withValues(alpha:0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.colPrimary, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          if (isPillLocked)
                            Icon(Icons.lock, size: 12, color: isSelected ? AppColors.colPrimary : Colors.grey),
                          if (isPillLocked) const SizedBox(width: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.colPrimary : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  static Widget buildHorizontalCardCarousel({required String type, required int count, required int lockedAfterIndex}) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        itemBuilder: (context, index) {
          return UiHelper.buildCard(
            width: 150,
            title: "$type ${index + 1}",
            subtitle: "Level ${index + 1}",
            isLocked: index > lockedAfterIndex,
          );
        },
      ),
    );
  }

  static Widget buildCard({
    required double width,
    required String title,
    required String subtitle,
    bool isFeatured = false,
    bool isLocked = false,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.colSecondary, // Fallback color
        image: DecorationImage(
          image: NetworkImage("https://picsum.photos/seed/${title.hashCode}/400/300"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay for Text Readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha:0.8)],
              ),
            ),
          ),

          // TOP LEFT: FEATURED BADGE
          if (isFeatured)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.colOnTertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("FEATURED", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),

          // TOP RIGHT: XP BADGE
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("+50 XP", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),

          // BOTTOM TEXT
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),

          // LOCKED OVERLAY
          if (isLocked)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.lock_outline, color: Colors.white, size: 36),
              ),
            ),
        ],
      ),
    );
  }




}



