import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/constants/appTokens.dart';
import '../../../widgets/widBotMenu.dart';
import '../../../widgets/widHeader.dart';
import 'package:pankh/screens/quizscreen/quizscreen.dart';
import '../buyscreen/buyScreen.dart';
import '../explorescreen/exploreScreen.dart';
import '../groupscreen/groupScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int? expandedIndex;

  void onItemTapped(int index) {
     setState(() {selectedIndex = index;});
  }

  void goToHome() {
    setState(() {
      selectedIndex = 0; // Set index back to Home
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the pages for the tabs
    final List<Widget> pages = [
      _buildHomeContent(),           // Index 0
      const Center(child: ExploreScreen()), // Index 1
      const Center(child: GroupScreen()),  // Index 2
      const Center(child: BuyScreen()),     // Index 3
      Center(child: QuizScreen(onQuit: goToHome)), // Index 4

    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const WidHeader(),

      // The body now switches based on selectedIndex
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: WidBotMenu(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),

      // Remove this or leave it null
      floatingActionButton: null,
    );
  }

  // --- REFACTORED HOME CONTENT (The Carousel Logic) ---
  Widget _buildHomeContent() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLocationTag(),
                const SizedBox(height: 20),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                    height: 500,
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    onPageChanged: (index, reason) {
                      setState(() => expandedIndex = null);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    bool isExpanded = expandedIndex == index;
                    String img = ["sparrow.jpg", "minivet.jpg", "roller.jpg"][index];

                    return _buildBirdCard(index, img, isExpanded);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 100), // Adjusted for WidBotMenu height
      ],
    );
  }

  // Helper for the Carousel Card to keep code clean
  Widget _buildBirdCard(int index, String img, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              UiHelper.CustomImage(img: img, height: 500, width: double.infinity, fit: BoxFit.cover),

              // Bird Title
              Positioned(
                bottom: 40,
                left: 25,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isExpanded ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(text: "Red-vented Bulbul", color: AppColors.colWhite, fontSize: 24, fontFamily: "DM Serif Display"),
                      UiHelper.CustomText(text: "बुलबुल", color: AppColors.colWhite, fontSize: 20, fontFamily: "Samkaran"),
                    ],
                  ),
                ),
              ),

              // Info Panel
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                bottom: isExpanded ? 0 : -350,
                left: 0,
                right: 0,
                child: Container(
                  height: 350,
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                  decoration: BoxDecoration(
                    color: AppColors.colPurpleSecondary.withOpacity(0.75),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(text: "Red-vented Bulbul", color: AppColors.colPurple, fontSize: 24, fontFamily: "DM Serif Display"),
                      const SizedBox(height: 5),
                      const Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            "In Indian lore, the red-vented bulbul symbolizes love...",
                            style: TextStyle(fontSize: 14, color: AppColors.colBlack),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Chevron Toggle
              Positioned(
                bottom: isExpanded ? 315 : 25,
                right: 25,
                child: GestureDetector(
                  onTap: () => setState(() => expandedIndex = isExpanded ? null : index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.colPurpleSecondary, shape: BoxShape.circle),
                    child: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: AppColors.colPurple, size: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.colPurpleSecondary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UiHelper.CustomIcon(img: "iconNavPin.png", height: 48, width: 48),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiHelper.CustomText(text: "Latest chirpers seen at", color: AppColors.colBlack, fontSize: 14, fontFamily: "KantumruyPro"),
              UiHelper.CustomText(text: "Thane, Maharashtra", color: AppColors.colBlack, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "KantumruyPro"),
            ],
          ),
        ],
      ),
    );
  }
}