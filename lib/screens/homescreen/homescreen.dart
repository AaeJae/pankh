import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/constants/appTokens.dart';
import '../../../widgets/widBotMenu.dart';
import '../../../widgets/widHeader.dart';
import 'package:pankh/screens/quizscreen/quizscreen.dart';
import '../../models/modBird.dart';
import '../../widgets/widQuizHelper.dart';
import '../buyscreen/buyScreen.dart';
import '../explorescreen/exploreScreen.dart';
import '../groupscreen/groupScreen.dart';

class HomeScreen extends StatefulWidget {
  final List<modBird> carouselBirds; // Add this
  const HomeScreen({super.key, required this.carouselBirds});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int? expandedIndex;
  late List<modBird> carouselBirds;

  /// Handles Navigation Logic
  Future<void> onItemTapped(int index) async {
    if (index == 4) { // The 'Blitz' / Quiz Button
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
      return; // Don't change selectedIndex for a full-screen overlay
    }

    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    carouselBirds = widget.carouselBirds;
  }

  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return _buildHomeContent(); // Your main carousel view
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
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: const WidHeader(),

      // IndexedStack keeps states alive (e.g. scroll positions) when switching tabs
      body: _getSelectedPage(),

      bottomNavigationBar: WidBotMenu(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }


  // --- HOME TAB CONTENT ---


  Widget _buildHomeContent() {
    return Column(
      children: [
        // 1. Move the location tag here if you only want it on the Home tab
        const SizedBox(height: 10),
        const _LocationTag(),

        // 2. The Carousel
        Expanded(
          child: Center(
            child: CarouselSlider.builder(
              itemCount: widget.carouselBirds.length,
              itemBuilder: (context, index, realIndex) {
                return BirdCarouselCard(
                  bird: widget.carouselBirds[index],
                  isExpanded: expandedIndex == index,
                  onToggle: () => setState(() => expandedIndex = (expandedIndex == index) ? null : index),
                );
              },
              options: CarouselOptions(
                aspectRatio: 0.8,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: widget.carouselBirds.length > 1,
                clipBehavior: Clip.none,

                // --- AUTOPLAY RECTIFICATION ---
                autoPlay: expandedIndex == null, // Only scroll if no card is expanded
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
              ),
            ),
          ),
        ),

        // 3. Spacing for the bottom tree graphics
        const SizedBox(height: 150),
      ],
    );
  }
}
// --- SUB-WIDGETS (Optimized for Performance) ---

/// Isolated Card Widget to prevent heavy UI repaints
class BirdCarouselCard extends StatelessWidget {
  final modBird bird;
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. BACKGROUND IMAGE
              UiHelper.CustomImage(
                img: bird.gitImageURL,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // 2. BLACK BOTTOM GRADIENT
              if (!isExpanded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

              // 3. TEXT & UI ELEMENTS
              Positioned(
                bottom: 30,
                left: 25,
                right: 25,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isExpanded ? 0 : 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiHelper.CustomText(
                              text: bird.birdName,
                              color: AppColors.colOnPrimary,
                              fontSize: AppFontSizes.fontSizeTitleBig,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.fontFamilyTitle,
                            ),
                            UiHelper.CustomText(
                              text: bird.hindiName.isNotEmpty ? bird.hindiName[0] : "",
                              color: AppColors.colOnPrimary.withOpacity(0.9),
                              fontSize: AppFontSizes.fontSizeBody,
                              fontFamily: AppFonts.fontFamilyDevnagari,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggle,
                        child: CircleAvatar(
                          backgroundColor: AppColors.colOnPrimary.withOpacity(0.4),
                          radius: 22,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.colOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. EXPANDING INFO PANEL
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: isExpanded ? 0 : -350,
                left: 0,
                right: 0,
                child: Container(
                  height: 250,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppColors.colPrimary.withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header within panel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UiHelper.CustomText(
                              text: bird.birdName,
                              color: AppColors.colOnPrimary,
                              fontSize: AppFontSizes.fontSizeTitleBig,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppFonts.fontFamilyTitle,
                          ),
                          IconButton(
                            onPressed: onToggle,
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.colOnPrimary),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: UiHelper.CustomText(
                              text: bird.folkStory + "\n\n" + bird.notableQuality,
                              color: AppColors.colOnPrimary,
                              fontSize: AppFontSizes.fontSizeBody,
                              fontFamily: AppFonts.fontFamilyBody,

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ], // Closing Stack
          ), // Closing ClipRRect
        ), // Closing Container
      ), // Closing RepaintBoundary
    );
  }
}

/// Static Location Tag extracted to prevent unnecessary rebuilds
class _LocationTag extends StatelessWidget {
  const _LocationTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.colSecondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UiHelper.CustomIcon(img: "iconNavPin.png", height: 40, width: 40),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Latest chirpers seen at", style: TextStyle(fontSize: 12, color: AppColors.colBlack)),
              Text("Thane, Maharashtra", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.colBlack)),
            ],
          ),
        ],
      ),
    );
  }
}