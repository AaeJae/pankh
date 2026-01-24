import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/domain/constants/appColors.dart';
import '../../../widgets/widbotmenu.dart';
import '../../../widgets/widheader.dart';
import '../quizscreen/soundquizscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // 0 = Home selected by default
  int? expandedIndex;
  void onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SoundQuizScreen()),
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      //// HEADER INSTANCE
      appBar: const WidHeader(),
      //// end HEADER INSTANCE

      // BOTTOM MENU INSTANCE
      floatingActionButton: WidBotMenu(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped, // Pass the function reference directly
      ),
      //// end BOTTOM MENU INSTANCE


      //// BODY
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLocationTag(),
                  const SizedBox(height: 20),
                  CarouselSlider.builder(
                    itemCount: 3, // Sparrow, Minivet, Roller
                    options: CarouselOptions(
                      height: 500,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,

                      // AUTOPLAY SETTINGS
                      autoPlay: true, // Enables the automatic sliding
                      autoPlayInterval: const Duration(seconds: 3), // How long each card stays
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true, // Stops sliding when user is interacting

                      onPageChanged: (index, reason) {
                        // Reset overlay when swiping to a new bird
                        setState(() => expandedIndex = null);
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      bool isExpanded = expandedIndex == index;
                      String img = ["sparrow.jpg", "minivet.jpg", "roller.jpg"][index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect( // CRITICAL: This clips the chevron/panel to the card
                            borderRadius: BorderRadius.circular(50),
                            child: Stack(
                              children: [
                                // 1. MAIN BIRD IMAGE
                                UiHelper.CustomImage(
                                  img: img,
                                  height: 500,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),

                                // 2. NEW: STATIC TITLE (Bottom-Left)
                                // This will hide when the overlay is open
                                Positioned(
                                  bottom: 40,
                                  left: 25,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isExpanded ? 0 : 1, // Hides when the overlay slides up
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UiHelper.CustomText(text: "Red-vented Bulbul", color: AppColors.colWhite, fontSize: 24, fontWeight: FontWeight.normal, fontFamily: "DM Serif Display"),
                                        UiHelper.CustomText(text: "बुलबुल", color: AppColors.colWhite, fontSize: 20,  fontFamily: "Samkaran"),

                                      ],
                                    ),
                                  ),
                                ),

                                // 3. SLIDING INFO PANEL
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  bottom: isExpanded ? 0 : -350, // Slides up from out of view
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
                                        UiHelper.CustomText(text: "Red-vented Bulbul", color: AppColors.colPurple, fontSize: 24, fontWeight: FontWeight.normal, fontFamily: "DM Serif Display"),
                                        UiHelper.CustomText(text: "बुलबुल", color: AppColors.colPurple, fontSize: 20,  fontFamily: "Samkaran"),

                                        const SizedBox(height: 5),
                                        const Expanded(
                                          child: SingleChildScrollView(
                                            child: Text(
                                              "In Indian lore, the red-vented bulbul is believed to symbolize love, passion, and good fortune, often appearing in folk tales as a messenger of heartfelt emotions. In some traditions, its presence near homes is seen as a sign of upcoming positive change or spiritual protection, especially during seasonal transitions",
                                              style: TextStyle(fontSize: 14, color: AppColors.colBlack),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),

                                // 3. THE CHEVRON (Moves with the panel)
                                Positioned(
                                  bottom: isExpanded ? 315 : 25, // Pins to the top of the panel when open
                                  right: 25,
                                  child: GestureDetector(
                                    onTap: () => setState(() => expandedIndex = isExpanded ? null : index),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.colPurpleSecondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                        color: AppColors.colPurple,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),

                                // 4. TOP SPEAKER ICON (Static)
                                Positioned(
                                  top: 25,
                                  right: 25,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: AppColors.colPurpleSecondary, shape: BoxShape.circle),
                                    child: const Icon(Icons.volume_up, color: AppColors.colPurple, size: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 170),
        ],
      ),

    );
  }

  Widget _buildLocationTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        // Uses the secondary purple color with low opacity for the pill background
        color: AppColors.colPurpleSecondary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrinks the container to fit the content
        children: [
          // Red location marker icon
          UiHelper.CustomIcon(img: "iconNavPin.png", height: 48, width: 48),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiHelper.CustomText(text: "Latest chirpers seen at", color: AppColors.colBlack, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "KantumruyPro"),
              // The location name using your custom text helper
              UiHelper.CustomText(text: "Thane, Maharashtra", color: AppColors.colBlack, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "KantumruyPro"),
            ],
          ),
        ],
      ),
    );
  }


}
