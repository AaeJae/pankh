import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';

enum AppScrollType { horizontal, infinite }
// enlargeCenter -> autoplay -> both sides peek
// isPaginated -> 3 dots beneath -> one card at a time only
// scrollType: infinite -> infinite scroll of child items
// default -> horizontal manual scroll with next card peek

class AppCarousel extends StatefulWidget {
  final List<AppCard> cards;
  final double height;
  final bool isPaginated;
  final bool autoplay;
  final bool enlargeCenterPage;
  final double viewportFraction;
  final AppScrollType scrollType;

  final double? cardHeight;
  final double? cardWidth;
  final Color? cardOverlay;

  const AppCarousel({
    super.key,
    required this.cards,
    required this.height,
    this.isPaginated = false,
    this.autoplay = false,
    this.enlargeCenterPage = false,
    this.viewportFraction = 1.0,
    this.scrollType = AppScrollType.horizontal,
    this.cardWidth,
    this.cardHeight,
    this.cardOverlay,
  });

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late PageController _pageController;
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    // Infinite logic only applies if using PageView (paginated/enlarge)
    int initialPage = widget.scrollType == AppScrollType.infinite ? 500 : 0;
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: initialPage,
    );

    if (widget.autoplay) _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(AppDurations.durationXXSlow, (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: AppDurations.durationXSlow,
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {

          // Calculate width: 85% for peek, 100% for pagination
          final double effectiveWidth = widget.isPaginated
              ? constraints.maxWidth
              : (widget.cardWidth != null ? widget.cardWidth! * 0.85 : constraints.maxWidth * 0.85);

          final double effectiveHeight = widget.cardHeight ?? widget.height;

          //debugPrint("cardheight: ${widget.cardHeight}; height: ${widget.height}");

          // --- VARIANT 1: Plain Horizontal (ListView) ---
          if (!widget.isPaginated && !widget.enlargeCenterPage) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero, // Start flush at the left edge
              itemCount: widget.cards.length,
              // ListView uses separatorBuilder
              separatorBuilder: (context, index) => const SizedBox(width: AppSizes.sizeXSmall),
              itemBuilder: (context, index) => _buildCardItem(index, effectiveWidth, effectiveHeight),
            );
          }

          // VARIANT 2: Paginated or Enlarge (PageView)
          return PageView.builder(
            controller: _pageController,
            itemCount: widget.scrollType == AppScrollType.infinite ? 1000 : widget.cards.length,
            itemBuilder: (context, index) {
              final int realIndex = index % widget.cards.length;

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (widget.enlargeCenterPage && _pageController.position.haveDimensions) {
                    double pageOffset = (_pageController.page! - index).abs();
                    scale = (1 - (pageOffset * 0.15)).clamp(0.8, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: _buildCardItem(realIndex, effectiveWidth, effectiveHeight),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCardItem(int index, double width, double height) {
    final card = widget.cards[index];
    //debugPrint("cardheight: ${widget.cardHeight}; height: ${widget.height}");

    return SizedBox(
      width: width,
      child: AppCard(
        title: card.title,
        subtitle: card.subtitle,
        image: card.image,
        expandedText: card.expandedText,
        isLocked: card.isLocked,
        topLeftBadge: card.topLeftBadge,
        topRightBadge: card.topRightBadge,
        onTap: card.onTap,
        height: height,
        width: width,
        overlayColor: widget.cardOverlay ?? card.overlayColor,
      ),
    );
  }
}