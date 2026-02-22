import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pankh/constants/designtokens.dart';

enum AppButtonVariant { solid, flat, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isIconOnly;

  const AppButton({
    super.key,
    this.label = "",
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.solid,
    this.size = AppButtonSize.large,
    this.isIconOnly = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getHeight() {
    switch (widget.size) {
      case AppButtonSize.small: return 32;
      case AppButtonSize.medium: return 44;
      case AppButtonSize.large: return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final bool isGhost = widget.variant == AppButtonVariant.ghost;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: _getHeight(),
        // Prevents infinity width errors in rows if not explicitly set to Large
        width: widget.isIconOnly
            ? _getHeight()
            : (widget.size == AppButtonSize.large ? double.infinity : null),
        decoration: _getBoxDecoration(isDisabled),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            onTapDown: (_) {
              if (!isDisabled) {
                _controller.forward();
                HapticFeedback.lightImpact();
              }
            },
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
            // Reverted to standard splash; disabled for ghost/disabled
            splashColor: (isDisabled || isGhost) ? Colors.transparent : AppColors.colWhite.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.isIconOnly ? 0 : AppSpacing.spacingMedium
              ),
              child: Center(
                child: _buildContent(isDisabled),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration(bool isDisabled) {
    if (isDisabled && widget.variant == AppButtonVariant.solid) {
      return BoxDecoration(
        color: AppColors.colDisabled, // Using your 0xFFBDBDBD token
        borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
      );
    }

    switch (widget.variant) {
      case AppButtonVariant.flat:
        return BoxDecoration(
          color: AppColors.colSecondary.withAlpha(AppAlpha.alphaLow),
          borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
          boxShadow: AppShadows.shadowSmall,
        );
      case AppButtonVariant.ghost:
        return const BoxDecoration();
      case AppButtonVariant.solid:
      default:
        return BoxDecoration(
          color: AppColors.colPrimary,
          borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
          boxShadow: AppShadows.shadowSmall,
        );
    }
  }

  Widget _buildContent(bool isDisabled) {
    // Determine foreground color
    // Now includes isLoading check to ensure "Processing" state uses colOnDisabled
    final Color fg = (isDisabled || widget.isLoading)
        ? AppColors.colOnDisabled
        : (widget.variant == AppButtonVariant.solid
        ? AppColors.colOnPrimary
        : AppColors.colPrimary);

    final double iconSize = widget.size == AppButtonSize.small ? 14 : 18;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show Loader if loading, else show Icon if provided
        if (widget.isLoading) ...[
          _buildLoader(fg),
          if (!widget.isIconOnly) const SizedBox(width: AppSpacing.spacingSmall),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: iconSize, color: fg),
          if (!widget.isIconOnly) const SizedBox(width: AppSpacing.spacingSmall),
        ],

        // Label
        if (!widget.isIconOnly)
          Text(
            widget.isLoading ? "Processing..." : widget.label,
            style: AppTypography.controls.copyWith(
              color: fg,
              fontSize: widget.size == AppButtonSize.small ? 12 : 14,
            ),
          ),
      ],
    );
  }

  Widget _buildLoader(Color loaderColor) {
    return SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
      ),
    );
  }
}