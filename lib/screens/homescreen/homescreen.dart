import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/models/mod_quiz.dart';

import '../../../widgets/wid_header.dart';
import '../../../widgets/wid_botmenu.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_quiz.dart';
import '../../services/ser_thirdpartydata.dart';
import '../../widgets/widDialog.dart';
import '../../widgets/wid_locationpicker.dart';
import '../buyscreen/buyscreen.dart';
import '../explorescreen/explorescreen.dart';
import '../profilescreen/profilescreen.dart';
import '../groupscreen/groupscreen.dart';
import '../../services/ser_bird.dart';

class HomeScreen extends StatefulWidget {
  final List<ModBird>? carouselBirds;
  const HomeScreen(this.carouselBirds, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<ModBird> _currentBirds = [];
  List<ModQuiz>? _quizzesList = [];
  List<AppCard>? _quizAppCards = [];
  String _currentSelectedCity = "Thane";

  @override
  void initState() {
    super.initState();
    _currentBirds = widget.carouselBirds ?? SerBird.getBirds(limitRows: 10);
    _init();
  }
  void _init() async { // send to different screens
    _quizzesList = await SerQuiz.getQuizzes();
    if (_quizzesList != null && _quizzesList!.isNotEmpty) {
      _quizAppCards = _quizzesList!.map((quiz) {
        final titleIndex = Random().nextInt(quiz.quizNames?.length ?? 1);
        final subtitleIndex = Random().nextInt(quiz.quizDescriptions?.length ?? 1);
        final birdIndex = Random().nextInt(_currentBirds.isNotEmpty ? _currentBirds.length : 1);
        debugPrint("inside _init() birdIndex: ${birdIndex}, _currentBirds[birdIndex]: ${_currentBirds[birdIndex]}");

        return AppCard(
          title: quiz.quizNames?[titleIndex] ?? "Untitled Quiz",
          subtitle: quiz.quizDescriptions?[subtitleIndex] ?? "",
          image: _currentBirds.isNotEmpty ? _currentBirds[birdIndex].birdImages[0].imageURL : "", // fallback if no birds
          topRightBadge: ("+${quiz.xp}XP" ?? 0).toString(),
          onTap: () {WidDialog.showDifficultyPicker(context, quiz.quizNames?[titleIndex] ?? "Untitled Quiz", quiz.defaultTotalQuestions, quiz.defaultDurationMins, {'quizType': quiz.quizType});}
        );
      }).toList();
      debugPrint("inside _init() quizAppCards: ${_quizAppCards}");
      setState(() {});
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
          Positioned.fill(child: _getSelectedPage()),

          // 2. BOTTOM MENU
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                SizedBox(
                  child: WidBotMenu(
                    selectedIndex: selectedIndex,
                    onItemTapped: _onItemTapped,
                  ),
                ),
                ColoredBox(
                  color: AppColors.colPrimary,
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                    width: double.infinity,
                  ),
                ),
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
      case 0:
        return _buildHomeContent();
      case 1:
        return const ExploreScreen();
      case 2:
        return const GroupScreen();
      case 3:
        return const BuyScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [

              // 1. Header
              const WidHeader(),

              // 2. BODY
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.sizeSmall),

                      //////////// 1. LOCATION PICKER
                      InkWell(
                        onTap: () {
                          WidLocationPicker.showLocationBottomModal(context, (name,lat,lng,)
                          async {setState(() {_currentSelectedCity = name;});
                            try {
                              final newBirds =await ThirdPartyDataService.ebirdNearbyBirds(lati: lat,lngi: lng,);
                              setState(() {_currentBirds = newBirds;});
                            } catch (e) {}
                          });
                        },
                        child: AppSectionTitle(title: "LATEST SIGHTINGS NEAR: 🌏 $_currentSelectedCity",showViewAll: true,),
                      ),

                      ///////////// 2. BIRD CAROUSEL
                      AppCarousel(
                        height: 200,
                        cardWidth: 350,
                        cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaLow),
                        viewportFraction: 0.75,
                        enlargeCenterPage: true,
                        autoplay: true,
                        scrollType: AppScrollType.infinite,
                        cards: _mapBirdsToCards(_currentBirds),
                      ),
                      const SizedBox(height: AppSizes.sizeSmall),

                      /////////////// 3. QUIZZES, QUESTS, EVENTS
                      AppSectionTitle(
                        title: "WHAT'S CHIRPING",
                        subtitle: "Popular content this week",
                        showViewAllLabel: true,
                        showViewAll: true,
                        onMoreTapRoute: () => _onItemTapped(1),
                      ),

                      AppTabContainer(
                        isScrollable: false,
                        height: 230,
                        tabs: [
                          AppTab(label: "Quizzes",
                            content: [
                              AppCarousel(
                                height: 200,
                                cardWidth: 170,
                                cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
                                cards: _quizAppCards!,
                                // [
                                //   AppCard(title: "Sound Quiz", subtitle:"Do you have a good ear?",topLeftBadge:"+50XP", image: "https://picsum.photos/seed/bird9/200/300", ),
                                //   AppCard(title: "Image Quiz", subtitle:"Pehchan kaun!",topLeftBadge:"+150XP", image: "https://picsum.photos/seed/bird2/200/300", ),
                                //   AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                                // ],
                              ),
                            ],
                          ),
                          AppTab(label: "Quests",
                            content: [
                              AppCarousel(
                                height: 200,
                                cardWidth: 150,
                                cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
                                cards: [
                                  AppCard(title: "Beginners Quest", subtitle:"Get started with Birding",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird5/200/300", ),
                                  AppCard(title: "Hobbyist Quest", subtitle:"Level up",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird8/200/300", ),
                                  AppCard(title: "Expert Quest", subtitle:"God of birding",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird9/200/300", ),

                                ],
                              )
                            ],
                          ),
                          AppTab(label: "Events",
                            isLocked: true,
                            content: [
                              AppCarousel(
                                height: 200,
                                cardWidth: 150,
                                cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
                                cards: [
                                  AppCard(isLocked:true, title: "SGNP Events", subtitle:"Events at your local hotspot",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird7/200/300", ),
                                  AppCard(title: "Bird Week 2026", subtitle:"Participate!",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird1/200/300", ),
                                  AppCard(title: "Global Birdathon", subtitle:"Help the community",topLeftBadge:"+250XP" , image: "https://picsum.photos/seed/bird2/200/300",),

                                ],
                              )
                            ],
                          ),
                        ],
                      ),

                      /////////////// 4. WEEKLY ACTIVITIES
                      AppSectionTitle(
                        title: "WEEKLY ACTIVITIES",
                        showViewAllLabel: true,
                        showViewAll: true,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
                              itemCount: 2,
                              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sizeSmall),
                              itemBuilder: (context, index) {
                                final double cardWidth = MediaQuery.of(context).size.width - (AppSizes.screenEdge * 2);

                                if (index == 0) {
                                  return AppCard(
                                    title: "Play Blitz Quiz ‍⚡",
                                    subtitle: "Test your speed!",
                                    height: 80,
                                    width: cardWidth,
                                    image: "assets/images/cardBg1.webp",
                                    overlayColor: AppColors.colPrimary.withAlpha(AppAlpha.alphaHigh),
                                    onTap: () {WidDialog.showDifficultyPicker(context, "Blitz Quiz", 10, 2, {'isStandalone': false});}
                                  );
                                } else {
                                  return AppCard(
                                    title: "Weekly Streak",
                                    subtitle: "5 Days Running!",
                                    height: 80,
                                    width: cardWidth,
                                    isLocked: true,
                                    onTap: () {},
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.sizeSmall),

                      /////////// 5. FOOTER GREETING
                      Container(
                        padding: EdgeInsets.all(AppSizes.screenEdge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.sizeXLarge),
                            const SizedBox(height: AppSizes.sizeXLarge),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Happy \nBirrrding',
                                    style: AppTypography.title1.copyWith(
                                      color: AppColors.colOnDisabled,
                                      fontWeight: FontWeight.bold,
                                      height: 0.9,
                                      fontSize: 72,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "!", // Your dynamic user name
                                    style: AppTypography.title1.copyWith(
                                      color: AppColors.colPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 72,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSizes.sizeXSmall),
                            Text(
                              "Made with ♥️ for Bharat",
                              style: AppTypography.subtitle2,
                            ),
                            const SizedBox(height: AppSizes.sizeXLarge),
                            const SizedBox(height: AppSizes.sizeXLarge),
                            const SizedBox(height: AppSizes.sizeXLarge),
                            const SizedBox(height: AppSizes.sizeXLarge),
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

  List<AppCard> _mapBirdsToCards(List<ModBird> birds) {
    return birds.map((bird) => AppCard(
      title: bird.birdName,
      subtitle: bird.hindiNames.isNotEmpty ? bird.hindiNames[0] : '',
      image: bird.featuredImage.imageURL,
      expandedText: bird.lore, // Pass lore directly
    )).toList();
  }

  /*Widget birdsNearbyCarousel() {
    final List<AppCard> birdCards = _mapBirdsToCards(_currentBirds);

    return CarouselSlider.builder(
      itemCount: birdCards.length,
      options: CarouselOptions(
        // Height should match your design tokens for magnified cards
        height: 190,
        viewportFraction: 0.75,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        autoPlay: _expandedBirdIndex == null, // Pause autoplay if a card is expanded
        autoPlayInterval: AppDurations.durationXXXSlow,
        onPageChanged: (index, reason) {
          // Crucial: Reset expansion state when user swipes to avoid "ghost" panels on new cards
          if (_expandedBirdIndex != null) {
            setState(() => _expandedBirdIndex = null);
          }
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final bird = _currentBirds[index];
        final card = birdCards[index];
        final bool isExpanded = _expandedBirdIndex == index;

        // 3. Inject expansion logic and content into the AppCard grandchild
        return AppCard(
          title: card.title,
          subtitle: card.subtitle,
          image: card.image,
          parentPill: card.parentPill,
          height: 200,
          width: 320,
          topLeftBadge: card.topLeftBadge,
          topRightBadge: card.topRightBadge,
          onTap: card.onTap,
          // Expanded State logic
          canExpand: true,
          isExpanded: isExpanded,
          expandedSubtitle: bird.lore, // Pulls description from your ModBird model
          onExpandToggle: () {
            setState(() {
              // Toggle expansion: if already expanded, close it; otherwise, open this index
              _expandedBirdIndex = isExpanded ? null : index;
            });
          },
        );
      },
    );
  }*/
}
