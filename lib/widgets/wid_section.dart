import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // 🚀 Added package
import '../constants/designtokens.dart';
import 'wid_uihelper.dart';

class WidSection extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;
  final List<Map<String, dynamic>>? pills;
  final String? defaultFilter;
  final double? cardWidth;
  final double? cardHeight;
  final List<ChildCard>? cardData;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool? isMagnified;
  final bool? enlargeCenterPage;
  final double? viewportFraction;

  const WidSection({
    super.key,
    this.title,
    this.subtitle,
    this.showViewAll = false,
    this.onViewAllTap,
    this.pills,
    this.defaultFilter,
    this.cardWidth,
    this.cardHeight,
    this.cardData,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 2),
    this.isMagnified = false,
    this.enlargeCenterPage = false,
    this.viewportFraction = 0.75,
  });

  @override
  State<WidSection> createState() => _WidSectionState();
}

class _WidSectionState extends State<WidSection> {
  String? _activeFilter;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.defaultFilter;
  }

  @override
  Widget build(BuildContext context) {
    final List<ChildCard> items = (widget.cardData != null && _activeFilter != null)
        ? widget.cardData!.where((card) => card.parentPill == _activeFilter).toList()
        : widget.cardData ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (items.isNotEmpty && widget.cardHeight != null) ...[
          widget.isMagnified!
              ? _buildMagnifiedCarousel(items)
              : _buildStandardList(items),
        ],
      ],
    );
  }

  // --- 1. MAGNIFIED VIEW (Using Carousel Slider) ---
  Widget _buildMagnifiedCarousel(List<ChildCard> items) {
    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) => _buildCardItem(items[index], index),
      options: CarouselOptions(
        // 1. Height should match what you passed (e.g., 270) to allow for 250px + scaling
        height: widget.cardHeight,

        // 2. Center & Peeking logic
        viewportFraction: widget.viewportFraction ?? 0.75,
        enlargeCenterPage: widget.enlargeCenterPage ?? true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale, // Smoother magnification
        // 3. Movement logic
        autoPlay: widget.autoPlay && _expandedIndex == null,
        autoPlayInterval: widget.autoPlayInterval,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,

        // 4. Infinite scroll
        enableInfiniteScroll: items.length > 1,

        clipBehavior: Clip.none, // Prevents shadows from getting cut off
        onPageChanged: (index, reason) {
          if (_expandedIndex != null) setState(() => _expandedIndex = null);
        },
      ),
    );
  }

  // --- 2. STANDARD VIEW (Using ListView) ---
  Widget _buildStandardList(List<ChildCard> items) {
    return SizedBox(
      height: widget.cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildCardItem(items[index], index),
      ),
    );
  }

  // --- 3. UNIVERSAL CARD ITEM ---
  Widget _buildCardItem(ChildCard item, int index) {
    final bool isExpanded = _expandedIndex == index;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: item.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: widget.cardWidth ?? 250,
            decoration: const BoxDecoration(color: Colors.black),
            child: Stack(
              fit: StackFit.expand,
              children: [
                UiHelper.customImage(img: item.image, fit: BoxFit.cover),

                // Gradient Scrim
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                if (item.topLeftBadge != null)
                  Positioned(top: 10, left: 10, child: _badge(item.topLeftBadge!, AppColors.colOnTertiary)),

                // Bottom Info Panel
                Positioned(
                  bottom: 15, left: 15, right: 15,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isExpanded ? 0 : 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(item.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        if (widget.isMagnified!)
                          GestureDetector(
                            onTap: () => setState(() => _expandedIndex = index),
                            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                ),

                // Expanded Drawer (Only for Magnified mode)
                if (widget.isMagnified!)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    bottom: isExpanded ? 0 : -widget.cardHeight!,
                    left: 0, right: 0,
                    child: _buildExpandedPanel(item),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedPanel(ChildCard item) {
    return Container(
      height: widget.cardHeight! * 1,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colPrimary.withValues(alpha:0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => setState(() => _expandedIndex = null),
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: SingleChildScrollView(child: Text(item.expandedSubtitle ?? "" , style: const TextStyle(color: Colors.white, fontSize: 13)))),
        ],
      ),
    );
  }

  // --- SUB-COMPONENTS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.title != null)
                Text(widget.title!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.colPrimary)),
              if (widget.showViewAll)
                GestureDetector(onTap: widget.onViewAllTap, child: const Icon(Icons.chevron_right, color: AppColors.colPrimary, size: 28)),
            ],
          ),
          if (widget.subtitle != null)
            Text(widget.subtitle!, style: TextStyle(fontSize: 12, color: AppColors.colPrimary.withOpacity(0.7))),
          if (widget.pills != null) ...[const SizedBox(height: 6), _buildPillList()],
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildPillList() {
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.pills!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final pill = widget.pills![index];
          final String label = pill['label'] ?? '';
          final bool isSelected = label == _activeFilter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.colPrimary.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(label, style: TextStyle(color: isSelected ? AppColors.colPrimary : Colors.grey, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}



class ChildCard {
  final String title;
  final String subtitle;
  final String image;
  final String parentPill; // The link to the filter
  final String? topLeftBadge;
  final String? topRightBadge;
  final bool isLocked;
  final VoidCallback? onTap;
  final bool? doesExpand;
  final String? expandedTitle;
  final String? expandedSubtitle;

  ChildCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.parentPill,
    this.topLeftBadge,
    this.topRightBadge,
    this.isLocked = false,
    this.onTap,
    this.doesExpand = false,
    this.expandedTitle,
    this.expandedSubtitle,
  });
}


