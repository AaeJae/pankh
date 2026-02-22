import 'package:flutter/material.dart';
import 'package:pankh/constants/designtokens.dart';
import 'package:pankh/constants/component_button.dart';

import 'component_autocomplete.dart';
import 'component_dialog.dart';
import 'component_modalBottomSheet.dart';
import 'component_progress.dart';
import 'component_skeleton.dart';
import 'component_slider.dart';
import 'component_tabContainer.dart'; // Ensure this matches your file path

class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});


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
        padding: const EdgeInsets.all(AppSpacing.screenEdge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Typography Scale"),
            _buildTypeScale(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Color Palette & Contrast"),
            _buildColorPalette(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Shadows & Elevation"),
            _buildShadowTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Button Gallery"),
            _buildButtonGallery(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Autocomplete"),
            _buildAutocompleteTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Bottom Sheet Modal"),
            _buildModalBottomSheetTest(context),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Dialog"),
            _buildDialogTest(context),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Progress"),
            _buildProgressTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Skeleton"),
            _buildSkeletonTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("Slider"),
            _buildSliderTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),

            _sectionTitle("TabContainer"),
            _buildTabTest(),
            const SizedBox(height: AppSpacing.spacingXXLarge),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacingMedium),
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
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Red Whiskered Bulbul T2", style: AppTypography.title2),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Habitats and Diet Subtitle1", style: AppTypography.subtitle1),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Scientific Classification Sub2", style: AppTypography.subtitle2),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Body Regular: Highlighting bird species in their natural habitat.", style: AppTypography.body),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Body Bold: Essential for highlighting key details.", style: AppTypography.bodyBold),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("Caption: Source Wikipedia 2026", style: AppTypography.caption),
        const SizedBox(height: AppSpacing.spacingSmall),
        Text("www.pankh-birds.com", style: AppTypography.link),
      ],
    );
  }

  Widget _buildColorPalette() {
    return Wrap(
      spacing: AppSpacing.spacingMedium,
      runSpacing: AppSpacing.spacingMedium,
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
            borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
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
        borderRadius: BorderRadius.circular(AppRadii.radiusSmall),
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
    return AppButton(
      label: "Show Alert Dialog",
      onPressed: () {
        AppDialog.show(
          context,
          title: "Verify Identity",
          isClosable: true,
          // Subtitle as a widget for rich content
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please login to save your bird sighting. By continuing, you agree to our Please login to save your bird sighting. By continuing, you agree to ourPlease login to save your bird sighting. By continuing, you agree to ourPlease login to save your bird sighting. By continuing, you agree to ourPlease login to save your bird sighting. By continuing, you agree to our",
                style: AppTypography.body,
              ),
              InkWell(
                onTap: () {},
                child: Text("Privacy Policy",
                    style: AppTypography.link.copyWith(color: AppColors.colPrimary)
                ),
              ),
              const SizedBox(height: AppSpacing.spacingMedium),
              const Icon(Icons.security, color: AppColors.colSecondary)
            ],
          ),
          items: [
            AppButton(
              label: "Next time",
              variant: AppButtonVariant.flat,
              size: AppButtonSize.small,
              onPressed: () => Navigator.pop(context),
            ),
            AppButton(
              label: "Login",
              size: AppButtonSize.small,
              onPressed: () => print("Logging in..."),
            ),
          ],
        );
      },
    );
  }
  Widget _buildProgressTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Matches your image exactly (Monthly expenses)
        const AppProgress(
          value: 0.4,
          labelLeft: "40% attempted",
          labelRight: "3/10 correct",
        ),
        const SizedBox(height: AppSpacing.spacingLarge),

        const AppProgress(
          value: 0.75,
          color: AppColors.colPrimary,
        ),
        const SizedBox(height: AppSpacing.spacingLarge),

        // 3. Thick variant for "Health" or "Stats"
        const AppProgress(
          value: 0.9,
          labelLeft: "Sighting Accuracy",
          color: AppColors.colSuccess,
          thickness: AppSpacing.spacingSmall,
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
            const SizedBox(width: AppSpacing.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSkeleton(width: 150, height: 16), // Title
                  const SizedBox(height: AppSpacing.spacingXSmall),
                  const AppSkeleton(width: double.infinity, height: 12), // Subtitle
                  const SizedBox(height: AppSpacing.spacingXSmall),
                  const AppSkeleton(width: 100, height: 12), // Third line
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.spacingLarge),

        // Simulating a Card Skeleton
        const AppSkeleton(
          width: double.infinity,
          height: 150,
          borderRadius: AppRadii.radiusMedium,
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

            const SizedBox(height: AppSpacing.spacingXXLarge),

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
  Widget _buildTabTest() {
    return AppTabs(
      items: [
        AppTabItem(
          label: "Photos",
          icon: Icons.image_outlined,
          content: const Center(child: Text("Your Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird GalleryYour Bird FINALLY", style: AppTypography.body)),
        ),
        AppTabItem(
          label: "Music",
          content: const Center(child: Text("Bird Songs and Calls", style: AppTypography.body)),
        ),
        AppTabItem(
          label: "Draw",
          content: const Center(child: Text("Bird Songs and Calls", style: AppTypography.body)),
        ),
        AppTabItem(
          label: "Bird",
          content: const Center(child: Text("Bird Songs and Calls", style: AppTypography.body)),
        ),
        AppTabItem(
          label: "Test",
          content: const Center(child: Text("Bird Songs and Calls", style: AppTypography.body)),
        ),
        AppTabItem(
          label: "Videos",
          isLocked: true, // Demonstrating the locked state
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, color: AppColors.colDisabled, size: 40),
              const SizedBox(height: 8),
              Text("Pro Membership Required", style: AppTypography.subtitle2.copyWith(color: AppColors.colDisabled)),
            ],
          ),
        ),
      ],
    );
  }
}