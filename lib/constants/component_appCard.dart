import 'package:flutter/material.dart';
import 'appTokens.dart';

class AppCard extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final String? image;
  final String? topLeftBadge;
  final String? topRightBadge;
  final String? expandedText;
  final bool isLocked;
  final VoidCallback? onTap;
  final Widget? customBody;

  // Injected by AppCarousel
  final double? width;
  final double? height;
  final Color? overlayColor;
  final Function(bool isExpanded)? onExpandChanged;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.image,
    this.topLeftBadge,
    this.topRightBadge,
    this.expandedText,
    this.isLocked = false,
    this.onTap,
    this.customBody,

    this.width,
    this.height,
    this.overlayColor,
    this.onExpandChanged,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool isExpanded = false;
  void _toggleExpand(bool expand) {
    setState(() => isExpanded = expand);
    if (widget.onExpandChanged != null) {
      widget.onExpandChanged!(expand);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Check if we actually need the scrim
    final bool hasText = widget.title != null || widget.subtitle != null;
    final bool canExpand = widget.expandedText != null && widget.expandedText!.isNotEmpty;


    return GestureDetector(
      onTap: widget.isLocked ? null : widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.sizeMedium), // System Standard
          boxShadow: AppShadows.shadowSmall, //
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 1. BACKGROUND
            _buildBackground(),

            // 2. CUSTOM BODY (if provided)
            if (widget.customBody != null)
              Positioned.fill(child: widget.customBody!),

            // 3. PARENT OVERLAY (e.g. from AppCardList)
            if (widget.overlayColor != null)
              Positioned.fill(child: ColoredBox(color: widget.overlayColor!)),

            // 4. CONDITIONAL SCRIM (Only if text exists)
            if (hasText) _buildScrim(),

            // 5. TEXT CONTENT
            if (hasText) _buildMainContent(),

            // 6. BADGES & INTERACTIVES
            _buildBadges(),

            // 7. LOCK OVERLAY
            if (widget.isLocked) _buildLockOverlay(),

            // 8. EXPANDED PANEL
            if (canExpand) _buildExpandedPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (widget.image != null) {
      if (widget.image!.startsWith('http')) {
        return Image.network(
          widget.image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else if (widget.image!.startsWith('assets/')) {
        return Image.asset(
          widget.image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }

    // Default fallback using design tokens
    return Container(
      color: AppColors.colSecondary.withAlpha(AppAlpha.alphaHigh),
      //child: const Center(child: Icon(Icons.image, color: AppColors.colSecondary)),
    );
  }

  Widget _buildScrim() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.colPrimary.withOpacity(0.7), // Using Deep Forest
            ],
            stops: const [0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      bottom: AppSizes.sizeSmall,
      left: AppSizes.sizeSmall,
      right: AppSizes.sizeSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: AppTypography.subtitle2.copyWith(color: AppColors.colOnPrimary), //
            ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: AppTypography.caption.copyWith(
                color: AppColors.colOnPrimary.withAlpha(AppAlpha.alphaHigh),
              ), //
            ),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Stack(
      children: [
        if (widget.topLeftBadge != null)
          Positioned(top: AppSizes.sizeXSmall, left: AppSizes.sizeXSmall, child: _badge(widget.topLeftBadge!)),
        if (widget.topRightBadge != null)
          Positioned(top: AppSizes.sizeXSmall, right: AppSizes.sizeXSmall, child: _badge(widget.topRightBadge!)),
        if (widget.expandedText != null)
          Positioned(bottom: AppSizes.sizeXXSmall,right: AppSizes.sizeXXSmall,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_up, color: AppColors.colOnPrimary),
              onPressed: () => setState(() => isExpanded = true),
            ),
          ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeXSmall, vertical: AppSizes.sizeXXSmall),
      decoration: BoxDecoration(
        color: AppColors.colTertiary, // Golden Sun
        borderRadius: BorderRadius.circular(AppSizes.sizeCircular),
      ),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          color: AppColors.colOnTertiary, // Deep Forest
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLockOverlay() {
    return Container(
      color: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
      child: const Center(
        child: Icon(Icons.lock_outline, color: AppColors.colOnPrimary, size: AppSizes.sizeLarge),
      ),
    );
  }

  Widget _buildExpandedPanel() {
    if (widget.expandedText == null || widget.expandedText!.isEmpty) {
      return const SizedBox.shrink();
    }
    final double cardHeight = widget.height ?? 200;
    final double hiddenOffset = cardHeight * 2;

    return AnimatedPositioned(
      duration: AppDurations.durationFast,
      curve: Curves.easeOutCubic,
      // When closed, we move it exactly to the bottom height.
      top: isExpanded ? 0 : (hiddenOffset),
      left: 0,
      right: 0,
      bottom: isExpanded ? 0 : -(hiddenOffset), // Push the bottom out as well

      child: Opacity(
        opacity: isExpanded ? 0.8 : 0.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeSmall, vertical: AppSizes.sizeXSmall),
          decoration: BoxDecoration(
            color: AppColors.colPrimary,
            borderRadius: BorderRadius.circular(AppSizes.sizeMedium),
          ),
          // FIX: Wrap the Column in a SingleChildScrollView or SizedOverflowBox
          // to prevent it from complaining about height during the animation.
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), // TODO should be scrollable

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Tell the column to be as small as possible
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title ?? "Details",
                        style: AppTypography.subtitle2.copyWith(color: AppColors.colOnPrimary),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.colOnPrimary, size: AppSizes.sizeSmall,),
                      onPressed: () => setState(() => isExpanded = false),
                    ),
                  ],
                ),
                //const Divider(color: AppColors.colSecondary),
                // Use a fixed height for the text area or wrap in a constrained box
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (cardHeight) - 80, // Subtract space used by Title/Divider
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.expandedText ?? "",
                      style: AppTypography.body.copyWith(color: AppColors.colOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}