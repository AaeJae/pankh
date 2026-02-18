import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import '../../../widgets/wid_uihelper.dart';
import '../../../widgets/wid_header.dart';
import '../../../widgets/wid_footermenu.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_thirdpartydata.dart';
import '../../widgets/wid_locationpicker.dart';
import '../../widgets/wid_pullMenu.dart';
import '../../widgets/wid_quizhelper.dart';
import '../../widgets/wid_section.dart';
import '../profilescreen/profilescreen.dart';
import '../quizscreen/quizscreen.dart';
import '../buyscreen/buyscreen.dart';
import '../explorescreen/explorescreen.dart';
import '../groupscreen/groupscreen.dart';
import '../../services/ser_bird.dart';

class HomeScreen extends StatefulWidget {
  final List<ModBird>? carouselBirds;
  const HomeScreen({super.key, this.carouselBirds});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<ModBird> _currentBirds = [];
  String _currentSelectedCity = "Thane";

  @override
  void initState() {
    super.initState();
    _currentBirds = widget.carouselBirds ?? SerBird.getBirds(limitRows: 10);
  }
  Future<void> startBlitzQuiz() async {
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: null,
      body: Stack(
        children: [
          // 1. PAGE CONTENT (Full Screen)
          Positioned.fill(
            child: _getSelectedPage(),
          ),

          // 2. THE STICKY BAR
          Positioned(left: 0, right: 0, bottom:0,
            child: Column(
              children: [
                SizedBox(
                  child: WidBotMenu(selectedIndex: selectedIndex, onItemTapped: _onItemTapped,
                  ),
                ),
                ColoredBox(
                  color: AppColors.colPrimary,
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                    width: double.infinity,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => selectedIndex = index);
  }
  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0: return _buildHomeContent();
      case 1: return const ExploreScreen();
      case 2: return const GroupScreen();
      case 3: return const BuyScreen();
      case 4: return const ProfileScreen();
      default: return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              const WidHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 180), // Padding for pill + pull-up peek
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _LocationTag(
                        locationName: _currentSelectedCity,
                        onTap: () {
                          WidLocationPicker.showLocationBottomModal(context, (name, lat, lng) async {
                            setState(() { _currentSelectedCity = name; });
                            try {
                              final newBirds = await ThirdPartyDataService.ebirdNearbyBirds(lati: lat, lngi: lng);
                              setState(() { _currentBirds = newBirds; });
                            } catch (e) {}
                          });
                        },
                      ),

                      WidSection(
                        isMagnified: true,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 0.8,
                        cardHeight: 190,
                        cardWidth: 350,
                        cardData: _mapBirdsToCards(_currentBirds),
                      ),
                      const SizedBox(height: 30),
                      WidSection(
                        title: "WHAT'S CHIRPING",
                        defaultFilter: "EVENTS",
                        cardHeight: 190,
                        cardWidth: 160,
                        pills: [
                          {'label': "EVENTS", 'isLocked': false},
                          {'label': "QUIZZES", 'isLocked': false},
                          {'label': "QUESTS", 'isLocked': false},
                        ],
                        cardData: [
                          ChildCard(title: "Bird Week 2026", subtitle: "Help local count", image: "https://picsum.photos/seed/bird1/200/300", parentPill: "EVENTS", onTap: () {}),
                          ChildCard(title: "Bird Week 2026", subtitle: "Help local count", image: "https://picsum.photos/seed/bird5/200/300", parentPill: "EVENTS", onTap: () {}),
                          ChildCard(title: "Bird Week 2026", subtitle: "Help local count", image: "https://picsum.photos/seed/bird3/200/300", parentPill: "EVENTS", onTap: () {}),
                          ChildCard(title: "Bird Week 2026", subtitle: "Help local count", image: "https://picsum.photos/seed/bird4/200/300", parentPill: "EVENTS", onTap: () {}),

                          ChildCard(title: "Birdemon!", subtitle: "15 Questions", image: "https://picsum.photos/seed/bird3/200/300", parentPill: "QUIZZES", topRightBadge: "+50XP", onTap: () {}),
                          ChildCard(title: "Birdemon!", subtitle: "15 Questions", image: "https://picsum.photos/seed/bird4/200/300", parentPill: "QUIZZES", topRightBadge: "+50XP", onTap: () {}),
                          ChildCard(title: "Birdemon!", subtitle: "15 Questions", image: "https://picsum.photos/seed/bird5/200/300", parentPill: "QUIZZES", topRightBadge: "+50XP", onTap: () {}),
                          ChildCard(title: "Birdemon!", subtitle: "15 Questions", image: "https://picsum.photos/seed/bird8/200/300", parentPill: "QUESTS", topRightBadge: "+50XP", onTap: () {}),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiHelper.customText(text: "WEEKLY ACTIVITIES", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.colPrimary),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    height: 90,
                                    padding: const EdgeInsets.fromLTRB(20,5, 20, 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.colPrimary.withOpacity(0.07),
                                      //border: Border.all(color: AppColors.colPrimary.withOpacity(0.2), width: 1.5),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        UiHelper.customText(text: "Breakfast Cafe", fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.colPrimary),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const SizedBox(width: 6),
                                            UiHelper.customText(text: "Breakfast Cafe", fontSize: 13, fontWeight: FontWeight.bold),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: startBlitzQuiz, // Use the callback passed into your widget
                                    child: Container(
                                      height: 90,
                                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.colPrimary,
                                        borderRadius: BorderRadius.circular(24),
                                        // Adding a slight shadow makes the tappable area more obvious
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.colPrimary.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.bolt, color: Colors.amber, size: 20),
                                          UiHelper.customText(
                                              text: "Play \n BLITZ QUIZ",
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              textAlign: TextAlign.center
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height:70),

                            // Text("Happie Birrrding", style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.grey, height: 1)),
                            // Text("!", style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: AppColors.colOnTertiary, height: 1)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Happie Birrrding',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      height:1,
                                      fontSize: 72,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "!", // Your dynamic user name
                                    style: TextStyle(
                                      color: AppColors.colOnTertiary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 72,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height:5),
                            Text("Made with ♥️ for Bharat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.colPrimary)),
                            const SizedBox(height:50),

                          ],

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // PULL-UP MENU LAYER
        // WidPullMenu(
        //   onBlitzTap: startBlitzQuiz,
        //   challengeTitle: "Habitat Hunter",
        //   challengeSubtitle: "Find 3 different nesting sites.",
        //   challengeDots: [
        //     {'color': Colors.brown, 'label': 'Done', 'isDone': true},
        //     {'color': Colors.green, 'label': 'Found', 'isDone': true},
        //     {'color': Colors.blue, 'label': 'Next', 'isDone': false},
        //     {'color': Colors.orange, 'label': 'Next', 'isDone': false},
        //     {'color': Colors.grey, 'label': 'Next', 'isDone': false},
        //   ],
        // )
      ],
    );
  }


  List<ChildCard> _mapBirdsToCards(List<ModBird> birds) {
    return birds.map((bird) => ChildCard(
      title: bird.birdName,
      subtitle: bird.hindiNames.isNotEmpty ? bird.hindiNames[0] : '',
      image: bird.featuredImage.imageURL,
      parentPill: "Nearby",
      onTap: () {},
    )).toList();
  }
}

class _LocationTag extends StatelessWidget {
  final VoidCallback onTap;
  final String locationName;
  const _LocationTag({required this.onTap, required this.locationName});

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: onTap,
      child: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

        child: Row(

          children: [

            const SizedBox(height: 40),

            Expanded(
              child: Row(
                children: [
                  UiHelper.customText(text: "BIRDS NEARBY: ", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.colPrimary),
                  const Icon(Icons.location_on_rounded, color: AppColors.colPrimary, size: 20),
                  UiHelper.customText(text: locationName, fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.colPrimary),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.colPrimary),
          ],
        ),
      ),
    );
  }
}