import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/constants/component_appCarousel.dart';

class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  final AppCard cardLocked = const AppCard(
    height: 180,
    title: "Sunbird",
    subtitle: "Cinnyris asiaticus",
    image: "assets/images/shikra.jpg", // Replace with your asset path
    topLeftBadge: "Common",
    isLocked: true,
    expandedText: "Shikra is a small sunbird. Like other sunbirds, they feed largely on nectar, although they will also take insects, especially when feeding young.",
  );
  final AppCard cardExpandable = const AppCard(
    height: 180,
    title: "Purple Sunbird",
    subtitle: "Cinnyris asiaticus",
    image: "assets/images/hummingBird.png", // Replace with your asset path
    topRightBadge: "Featured",
    topLeftBadge: "Common",
    expandedText: "The Purple Sunbird is a small sunbird. Like other sunbirds, they feed largely on nectar, although they will also take insects, especially when feeding young.",
  );
  final AppCard cardBadgeExpandable = const AppCard(
    height: 180,
    title: "Minivet",
    subtitle: "Mini Cinnyris asiaticus",
    image: "assets/images/minivet.jpg", // Replace with your asset path
    topRightBadge: "Featured",
    expandedText: "The Minivet is a small sunbird. Like other sunbirds, they feed largely on nectar, although they will also take insects, especially when feeding young.",
  );
  final AppCard cardBadgeNonExpand = const AppCard(
    height: 180,
    title: "Sparrow",
    subtitle: "Sparrowcus",
    image: "assets/images/sparrow.jpg", // Replace with your asset path
    topRightBadge: "Featured",
  );
  final AppCard cardText = const AppCard(
    height: 180,
    title: "Shikra",
    subtitle: "Shikra asiaticus",
  );
  final AppCard cardPlain = const AppCard(
    height: 180,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colBackground,
      appBar: AppBar(
        title: Text("PANKH LABS", style: AppTypography.logo.copyWith(fontSize: 24)),
        elevation: 0,
        backgroundColor: AppColors.colPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenEdge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Typography Scale"),
            _buildTypeScale(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Color Palette & Contrast"),
            _buildColorPalette(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Shadows & Elevation"),
            _buildShadowTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Button Gallery"),
            _buildButtonGallery(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Autocomplete"),
            _buildAutocompleteTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Bottom Sheet Modal"),
            _buildModalBottomSheetTest(context),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Dialog"),
            _buildDialogTest(context),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Progress"),
            _buildProgressTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Skeleton"),
            _buildSkeletonTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Slider"),
            _buildSliderTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("TabContainer"),
            //_buildTabTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Carousel Magnified"),
            _buildCarouselMagnifiedTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Carousel Horizontal"),
            _buildCarouselHorizontalTest(),
            const SizedBox(height: AppSizes.sizeXLarge),

            _sectionTitle("Carousel paginated"),
            _buildCarouselPaginatedTest(),
            const SizedBox(height: AppSizes.sizeXLarge),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),style: AppTypography.subtitle1),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildTypeScale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dwarf Kingfisher T1", style: AppTypography.title1),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Red Whiskered Bulbul T2", style: AppTypography.title2),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Habitats and Diet Subtitle1", style: AppTypography.subtitle1),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Scientific Classification Sub2", style: AppTypography.subtitle2),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Body Regular: Highlighting bird species in their natural habitat.", style: AppTypography.body),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Body Bold: Essential for highlighting key details.", style: AppTypography.bodyBold),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("Caption: Source Wikipedia 2026", style: AppTypography.caption),
        const SizedBox(height: AppSizes.sizeXSmall),
        Text("www.pankh-birds.com", style: AppTypography.link),
      ],
    );
  }

  Widget _buildColorPalette() {
    return Wrap(
      spacing: AppSizes.sizeSmall,
      runSpacing: AppSizes.sizeSmall,
      children: [
        _colorSquare(AppColors.colPrimary, AppColors.colOnPrimary, "Primary"),
        _colorSquare(AppColors.colSecondary, AppColors.colOnSecondary, "Secondary"),
        _colorSquare(AppColors.colTertiary, AppColors.colOnTertiary, "Tertiary"),
        _colorSquare(AppColors.colQuaternary, AppColors.colOnQuaternary, "Quaternary"),
        _colorSquare(AppColors.colSuccess, AppColors.colOnSuccess, "Success"),
        _colorSquare(AppColors.colError, AppColors.colWhite, "Error"),
        _colorSquare(AppColors.colDisabled, AppColors.colOnDisabled, "Disabled"),
      ],
    );
  }

  Widget _colorSquare(Color bgColor, Color fgColor, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.sizeXSmall),
            boxShadow: AppShadows.shadowSmall,
          ),
          child: Center(
            child: Text("Aa", style: AppTypography.bodyBold.copyWith(color: fgColor)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
  Widget _buildShadowTest() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shadowBox(AppShadows.shadowSmall, "SM"),
        _shadowBox(AppShadows.shadowMedium, "MD"),
        _shadowBox(AppShadows.shadowLarge, "LG"),
        _shadowBox(AppShadows.shadowGold, "GLOW"),
      ],
    );
  }

  Widget _shadowBox(List<BoxShadow> shadow, String label) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.colWhite,
        borderRadius: BorderRadius.circular(AppSizes.sizeXSmall),
        boxShadow: shadow,
      ),
      child: Center(child: Text(label, style: AppTypography.caption)),
    );
  }

  Widget _buildButtonGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("SIZES", style: AppTypography.subtitle2),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppButton(label: "Small", size: AppButtonSize.small, onPressed: () {}),
            const SizedBox(width: 8),
            AppButton(label: "Medium", size: AppButtonSize.medium, onPressed: () {}),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(label: "Large (Wide)", size: AppButtonSize.large, onPressed: () {}),
            ),
          ],
        ),

        const SizedBox(height: 32),
        const Text("ICON-ONLY & VARIANTS", style: AppTypography.subtitle2),
        const SizedBox(height: 16),
        Row(
          children: [
            AppButton(icon: Icons.add, isIconOnly: true, size: AppButtonSize.medium, onPressed: () {}),
            const SizedBox(width: 12),
            AppButton(icon: Icons.favorite_border, isIconOnly: true, variant: AppButtonVariant.flat, size: AppButtonSize.medium, onPressed: () {}),
            const SizedBox(width: 12),
            AppButton(icon: Icons.share_outlined, isIconOnly: true, variant: AppButtonVariant.ghost, size: AppButtonSize.medium, onPressed: () {}),
          ],
        ),

        const SizedBox(height: 32),
        const Text("STATES", style: AppTypography.subtitle2),
        const SizedBox(height: 16),
        AppButton(label: "Processing...", isLoading: true, onPressed: () {}),
        const SizedBox(height: 16),
        const AppButton(label: "Disabled State", onPressed: null),
      ],
    );
  }

  Widget _buildAutocompleteTest() {
    return Column(
      children: [
        // Scenario 1: Full Profile Autocomplete (NextUI Style)
        AppAutocomplete(
          label: "Assigned to",
          hintText: "Select a user",
          prefixIcon: Icons.person_search,
          isRequired: true,
          options: [
            AutocompleteOption(
                title: "Tony Reichert",
                subtitle: "tony.reichert@example.com",
                icon: Icons.face,
                value: 1
            ),
            AutocompleteOption(
                title: "Zoey Lang",
                subtitle: "zoey.lang@example.com",
                icon: Icons.face_retouching_natural,
                value: 2
            ),
            AutocompleteOption(
                title: "Jane Fisher",
                subtitle: "jane.fisher@example.com",
                icon: Icons.face_unlock_sharp,
                value: 3
            ),
          ],
          onSelected: (opt) => print("Selected: ${opt?.title}"),
        ),

        const SizedBox(height: 24),

        // Scenario 2: Simple Minimal Autocomplete
        AppAutocomplete(
          hintText: "Search an animal",
          options: [
            AutocompleteOption(title: "Lion", value: "lion"),
            AutocompleteOption(title: "Tiger", value: "tiger"),
            AutocompleteOption(title: "Leopard", value: "leopard"),
          ],
          onSelected: (opt) => print("Selected: ${opt?.title}"),
        ),
      ],
    );
  }

  Widget _buildModalBottomSheetTest(BuildContext context) {
    return Column(
      children: [
        // Variant 1: Default List
        AppButton(
          label: "Default List Modal",
          onPressed: () {
            AppSheet.show(
              context,
              title: "Sighting Actions",
              subtitle: "Manage your current bird observation",
              variant: AppSheetVariant.defaultList,
              items: [
                AppSheet.buildListItem(
                  icon: Icons.camera_alt,
                  text: "Attach Photo",
                  onTap: () => print("Photo tapped"),
                ),
                AppSheet.buildListItem(
                  icon: Icons.mic,
                  text: "Attach Voice",
                  onTap: () => print("Voice tapped"),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // Variant 2: Tabbed Content
        AppButton(
          label: "Tabbed Info Modal",
          variant: AppButtonVariant.flat,
          onPressed: () {
            AppSheet.show(
              context,
              title: "Bird Profile",
              subtitle: "Detailed classification",
              variant: AppSheetVariant.tabbed,
              tabs: ["Diet", "Order", "Family"],
              items: [
                AppSheet.buildTabContent(["Insects", "Berries", "Small Seeds","Insectsss", "Berriesss", "Small Seedsss","Insessscts", "Besrries", "Small Seedss","Insects", "Berries", "Small Seeds"]),
                AppSheet.buildTabContent(["Passeriformes", "Coraciiformes"]),
                AppSheet.buildTabContent(["Muscicapidae", "Turdididae"]),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDialogTest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dialog", style: AppTypography.subtitle1),
        const SizedBox(height: AppSizes.sizeSmall),

        // Trigger button for the Dialog
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colPrimary,
              foregroundColor: AppColors.colOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeSmall),
              ),
            ),
            onPressed: () {
              AppDialog.show(
                context,
                title: "Confirm Action",
                isClosable: true,
                subtitle: Text(
                  "Are you sure you want to proceed with this bird sighting entry? This action cannot be undone.",
                  style: AppTypography.body,
                ),
                items: [
                  // Using your AppButton component (assuming standard design)
                  AppButton(
                    label: "Cancel",
                    variant: AppButtonVariant.flat, // Or outline based on your system
                  ),
                  AppButton(
                    label: "Confirm",
                    variant: AppButtonVariant.solid,
                  ),
                ],
              );
            },
            child: Text("Show AppDialog", style: AppTypography.controls),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //1. Matches your image exactly (Monthly expenses)
        const AppProgress(
          value: 0.4,
          labelLeft: "40% attempted",
          labelRight: "3/10 correct",
        ),
        const SizedBox(height: AppSizes.sizeMedium),

        const AppProgress(
          value: 0.75,
          color: AppColors.colPrimary,
        ),
        const SizedBox(height: AppSizes.sizeMedium),

        // 3. Thick variant for "Health" or "Stats"
        const AppProgress(
          value: 0.9,
          labelLeft: "Sighting Accuracy",
          color: AppColors.colSuccess,
          thickness: AppSizes.sizeXSmall,
        ),
      ],
    );
  }
  Widget _buildSkeletonTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to top
          children: [
            AppSkeleton.circle(size: 48),
            const SizedBox(width: AppSizes.sizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSkeleton(width: 150, height: 16), // Title
                  const SizedBox(height: AppSizes.sizeXXSmall),
                  const AppSkeleton(width: double.infinity, height: 12), // Subtitle
                  const SizedBox(height: AppSizes.sizeXXSmall),
                  const AppSkeleton(width: 100, height: 12), // Third line
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.sizeMedium),

        // Simulating a Card Skeleton
        const AppSkeleton(
          width: double.infinity,
          height: 150,
          borderRadius: AppSizes.sizeLarge,
        ),
      ],
    );
  }

  Widget _buildSliderTest() {
    double _selectedYear = 2015.0;
    RangeValues _yearRange = const RangeValues(2012.0, 2018.0);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Single Slider Snapping to Years
            AppSlider(
              label: "Sighting Year",
              value: _selectedYear,
              min: 2010,
              max: 2020,
              divisions: 10, // Snaps to exactly 10 intervals
              onChanged: (val) {
                setState(() => _selectedYear = val);
              },
            ),

            const SizedBox(height: AppSizes.sizeXLarge),

            // Range Slider Snapping to Years
            AppRangeSlider(
              label: "Year Range Filter",
              values: _yearRange,
              min: 2010,
              max: 2020,
              divisions: 10,
              onChanged: (vals) {
                setState(() => _yearRange = vals);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselMagnifiedTest() {
    final List<AppCard> birdCards = [
      cardLocked,
      cardExpandable,
      cardBadgeExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
      cardBadgeExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
    ];
    return AppCarousel(
      height: 160,
      cardWidth: 300,
      cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaLow),
      viewportFraction: 0.75,
      enlargeCenterPage: true,
      autoplay: true,
      scrollType: AppScrollType.infinite,
      cards: birdCards,
    );
  }

  Widget _buildCarouselHorizontalTest() {
    final List<AppCard> birdCards = [
      cardLocked,
      cardExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
      cardBadgeExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
    ];
    return AppCarousel(
      height: 150,
      cardWidth: 300,
      cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
      cards: birdCards,
    );
  }
  Widget _buildCarouselPaginatedTest() {
    final List<AppCard> birdCards = [
      cardLocked,
      cardExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
      cardBadgeExpandable,
      cardBadgeNonExpand,
      cardText,
      cardPlain,
    ];
    return AppCarousel(
      height: 80,
      isPaginated: true,
      cardWidth: 300,
      cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
      cards: birdCards,
    );
  }

}