import 'package:flutter/material.dart';
import '../constants/app_tokens.dart'; // Ensure correct path for AppColors/AppFontSizes
import 'wid_uihelper.dart';

class WidSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  // Optional Pill Configuration
  final List<Map<String, dynamic>>? pills;
  final String? defaultFilter;

  // Optional Carousel Configuration
  final double? cardWidth;
  final double? cardHeight;
  final List<ChildCard>? cardData; // Now uses the class

  const WidSection({
    super.key,
    required this.title,
    this.subtitle,
    this.showViewAll = false,
    this.onViewAllTap,
    this.pills,
    this.defaultFilter,
    this.cardWidth,
    this.cardHeight,
    this.cardData,
  });

  @override
  State<WidSection> createState() => _WidSectionState();
}

class _WidSectionState extends State<WidSection> {
  String? _activeFilter;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.defaultFilter;
  }

  @override
  Widget build(BuildContext context) {
    // Selection logic now uses dot notation: item.parentPill
    final List<ChildCard> filteredCards = (widget.cardData != null && _activeFilter != null)
        ? widget.cardData!.where((card) => card.parentPill == _activeFilter).toList()
        : widget.cardData ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (filteredCards.isNotEmpty && widget.cardHeight != null) ...[
          const SizedBox(height: 12),
          _buildCarousel(filteredCards),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiHelper.customText(
                text: widget.title,
                fontSize: AppFontSizes.fontSizeTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.colPrimary,
              ),
              if (widget.showViewAll)
                GestureDetector(
                  onTap: widget.onViewAllTap,
                  child: Icon(Icons.chevron_right, color: AppColors.colPrimary, size: 28),
                ),
            ],
          ),
          if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
            UiHelper.customText(
              text: widget.subtitle!,
              fontSize: AppFontSizes.fontSizeCaption,
              color: AppColors.colPrimary.withValues(alpha: 0.7),
            ),

          if (widget.pills != null && widget.pills!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildPillList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPillList() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.pills!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final pill = widget.pills![index];
          final String label = pill['label'] ?? '';
          final bool isSelected = label == _activeFilter;
          final bool isLocked = pill['isLocked'] ?? false;

          return GestureDetector(
            onTap: () => setState(() => _activeFilter = label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.colPrimary.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.colPrimary : AppColors.colPrimary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLocked)
                    Icon(Icons.lock, size: 12, color: isSelected ? AppColors.colPrimary : Colors.grey),
                  if (isLocked) const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? AppColors.colPrimary : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarousel(List<ChildCard> items) {
    return SizedBox(
      height: widget.cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              width: widget.cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Linear Gradient for Readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  if (item.isLocked)
                    const Center(child: Icon(Icons.lock_outline, color: Colors.white, size: 30)),

                  if (item.topLeftBadge != null)
                    _badge(item.topLeftBadge!, Alignment.topLeft, AppColors.colOnTertiary),
                  if (item.topRightBadge != null)
                    _badge(item.topRightBadge!, Alignment.topRight, AppColors.colOnTertiary),
                  Positioned(
                    bottom: 12, left: 12, right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(item.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _badge(String text, Alignment align, Color color) {
    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
      ),
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

  ChildCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.parentPill,
    this.topLeftBadge,
    this.topRightBadge,
    this.isLocked = false,
    this.onTap,
  });
}