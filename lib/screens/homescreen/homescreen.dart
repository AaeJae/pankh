import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pankh/constants/app_tokens.dart';
import '../../../widgets/wid_uihelper.dart';
import '../../../widgets/wid_header.dart';
import '../../../widgets/wid_footermenu.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_thirdpartydata.dart';
import '../../widgets/wid_locationpicker.dart';
import '../../widgets/wid_quizhelper.dart';
import '../quizscreen/quizscreen.dart';
import '../buyscreen/buyscreen.dart';
import '../explorescreen/explorescreen.dart';
import '../groupscreen/groupscreen.dart';

class HomeScreen extends StatefulWidget {
  final List<ModBird> carouselBirds;
  const HomeScreen({super.key, required this.carouselBirds});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int? expandedIndex;

  String _currentSelectedCity = "India";

  /// Handles Navigation & Blitz Logic
  Future<void> onItemTapped(int index) async {
    if (index == 4) { // Blitz Logic
      final String? difficulty = await WidQuizHelper.showDifficultyPicker(context);
      if (difficulty != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              difficulty: difficulty,
              onQuit: () => Navigator.pop(context),
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ExploreScreen();
      case 2:
        return const GroupScreen();
      case 3:
        return const BuyScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidHeader(),
      body: _getSelectedPage(),
      bottomNavigationBar: WidBotMenu(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }

  // --- HOME TAB CONTENT ---

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _LocationTag(
            locationName: _currentSelectedCity,
            onTap: () {
              WidLocationPicker.show(context, (newLocation) {
                setState(() {
                  _currentSelectedCity = newLocation;
                });
                ThirdPartyDataService.ebirdNearbyBirds(newLocation);
              });
            },
          ),
          const SizedBox(height: 10),

          // 2. COMPACT CAROUSEL
          // RECTIFICATION: Height is 270 to accommodate the 250px card scaling up
          SizedBox(
            height: 270,
            child: CarouselSlider.builder(
              itemCount: widget.carouselBirds.length,
              itemBuilder: (context, index, realIndex) {
                return BirdCarouselCard(
                  bird: widget.carouselBirds[index],
                  isExpanded: expandedIndex == index,
                  onToggle: () => setState(() {
                    expandedIndex = (expandedIndex == index) ? null : index;
                  }),
                );
              },
              options: CarouselOptions(
                height: 250, // Card base height
                viewportFraction: 0.8, // RECTIFICATION: More horizontal room
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                enableInfiniteScroll: widget.carouselBirds.length > 1,
                autoPlay: expandedIndex == null,
                clipBehavior: Clip.none, // Allow scaling without clipping shadows
              ),
            ),
          ),

          const SizedBox(height: 10), // Adjusted spacing

          // 3. WHAT'S HOT SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: UiHelper.customText(
              text: "What's Hot",
              fontSize: AppFontSizes.fontSizeTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.colPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildHotCarousel(),

          const SizedBox(height: 30),
          _buildBlitzPromoCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHotCarousel() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          width: 120,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage("https://picsum.photos/seed/bird/200/300"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlitzPromoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => onItemTapped(4), // Triggers Blitz Logic
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.colSecondary, AppColors.colPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.colPrimary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 45),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiHelper.customText(
                      text: "Quick Blitz",
                      color: Colors.white,
                      fontSize: AppFontSizes.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                    UiHelper.customText(
                      text: "Test your bird IQ in 60s",
                      color: Colors.white70,
                      fontSize: AppFontSizes.fontSizeCaption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SUB-WIDGETS (Standalone Classes) ---

class BirdCarouselCard extends StatelessWidget {
  final ModBird bird;
  final bool isExpanded;
  final VoidCallback onToggle;

  const BirdCarouselCard({
    super.key,
    required this.bird,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Image
            UiHelper.customImage(
              img: bird.gitImageURL,
              fit: BoxFit.cover,
            ),

            // 2. Persistent Scrim
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),

            // 3. Collapsed Info
            Positioned(
              bottom: 25,
              left: 25, // Reduced slightly to give more internal room
              right: 15,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isExpanded ? 0 : 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UiHelper.customText(
                            text: bird.birdName,
                            color: Colors.white,
                            fontSize: AppFontSizes.fontSizeTitle,
                            fontWeight: FontWeight.bold,
                          ),
                          if (bird.hindiNames.isNotEmpty)
                            UiHelper.customText(
                              text: bird.hindiNames[0],
                              color: Colors.white70,
                              fontSize: AppFontSizes.fontSizeBody,

                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // RECTIFICATION: Use GestureDetector + Container instead of IconButton
                    // This removes all hidden Material padding that causes overflows
                    GestureDetector(
                      onTap: onToggle,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 20
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Expanded Panel
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              bottom: isExpanded ? 0 : -260,
              left: 0,
              right: 0,
              child: Container(
                height: 250,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.colPrimary.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: UiHelper.customText(
                            text: bird.birdName,
                            color: Colors.white,
                            fontSize: AppFontSizes.fontSizeSubtitle,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontFamilySubtitle,
                          ),
                        ),
                        GestureDetector(
                          onTap: onToggle,
                          child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: UiHelper.customText(
                          text: "${bird.folkStory}\n\n${bird.notableQuality}",
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: AppFonts.fontFamilyBody,
                          textAlign: TextAlign.justify,
                          overflow: isExpanded ? null : TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationTag extends StatelessWidget {
  final VoidCallback onTap; // Add this
  final String locationName; // Add this to make the text dynamic

  const _LocationTag({required this.onTap, required this.locationName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap, // Triggers your bottom sheet
        borderRadius: BorderRadius.circular(15), // Ensures the ripple matches the shape
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.colSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.colSecondary.withOpacity(0.2)), // Optional polish
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.colPrimary, size: 20),
              const SizedBox(width: 10),

              // 1. Wrap the Column in Expanded to constrain its width
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiHelper.customText(text: "Latest birds found at", fontSize: 10, color: Colors.grey),

                    // 2. The Text now knows it has a limit and will show the "..."
                    UiHelper.customText(
                      text: locationName,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colPrimary,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis, // Works now!
                      maxLines: 1, // Optional: ensures it stays on one line
                    ),
                  ],
                ),
              ),

              // The Spacer is actually redundant now that Expanded is used,
              // but you can keep it or remove it depending on your design.
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right, color: AppColors.colPrimary),
            ],
          ),
        ),
      ),
    );
  }

}