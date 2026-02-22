import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';

class AppSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCircle;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadii.radiusSmall,
    this.isCircle = false,
  });

  factory AppSkeleton.circle({required double size}) =>
      AppSkeleton(width: size, height: size, isCircle: true);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow, // Slightly slower for elegance
    )..repeat();

    // Use a Curve to make the movement smoother (slow start/end)
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
// Inside _AppSkeletonState
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            // We map the 0.0 -> 1.0 animation value to a wider range
            // to ensure the shimmer starts and ends completely off-screen.
            final double t = _animation.value;

            return LinearGradient(
              begin: const Alignment(-2.0, -0.5), // Started further left
              end: const Alignment(2.0, 0.5),    // Ends further right
              colors: [
                AppColors.colDisabled.withAlpha(AppAlpha.alphaMedium), // Base
                AppColors.colDisabled.withAlpha(AppAlpha.alphaHigh), // Highlight
                AppColors.colDisabled.withAlpha(AppAlpha.alphaMedium), // Base
              ],
              stops: [
                t - 0.4, // Leading edge
                t,       // Peak highlight
                t + 0.4, // Trailing edge
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.colDisabled,
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: widget.isCircle ? null : BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}