import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/widgets/wid_uihelper.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Mock states for the filters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: UiHelper.customText(
          text: "Explore",
          fontSize: AppFontSizes.fontSizeTitleBig,
          fontWeight: FontWeight.bold,
          color: AppColors.colPrimary,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /////////// 1. FEATURED SECTION
            AppSectionTitle(
              title: "FEATURED",
              subtitle: "Popular content this week",
              showViewAllLabel: false,
              showViewAll: true,
            ),
            AppCarousel(
              height: 200,
              cardWidth: 350,
              cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaLow),
              viewportFraction: 0.75,
              enlargeCenterPage: true,
              autoplay: true,
              scrollType: AppScrollType.infinite,
              cards:[
                AppCard(title: "Winter Migration", subtitle:"Discover Arctic Travellers",topLeftBadge:"Featured", topRightBadge: "+50XP",image: "https://picsum.photos/seed/bird9/200/300", ),
                AppCard(title: "Bird Fashion Week", subtitle:"Who wore it best?",topLeftBadge:"Featured", topRightBadge: "+50XP",image: "https://picsum.photos/seed/bird1/200/300", ),
              ],
            ),
            const SizedBox(height: AppSizes.sizeSmall),

            // TAB CONTAINER // TODO MAKE STICKY
            AppTabContainer(
              isScrollable: false,
              height: 350,
              tabs: [
                AppTab(label: "Quizzes",
                  content: [
                    AppCarousel(
                      height: 200,
                      cardWidth: 170,
                      cardOverlay: AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
                      cards:
                      [
                        AppCard(title: "Sound Quiz", subtitle:"Do you have a good ear?",topLeftBadge:"+50XP", image: "https://picsum.photos/seed/bird9/200/300", ),
                        AppCard(title: "Image Quiz", subtitle:"Pehchan kaun!",topLeftBadge:"+150XP", image: "https://picsum.photos/seed/bird2/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                        AppCard(title: "Meme Quiz", subtitle:"Kispar hai ye meme?",topLeftBadge:"+250XP", image: "https://picsum.photos/seed/bird3/200/300", ),
                      ],
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
              ],
            ),

            // // 2. QUESTS SECTION
            // AppSection(
            //   title: "Quests",
            //   defaultFilter: "Balcony Birding",
            //   cardHeight: 200,
            //   cardWidth: 200,
            //   pills: [
            //     {'label': 'Balcony Birding', 'isLocked': false},
            //     {'label': 'Field Trip', 'isLocked': false},
            //     {'label': 'Migration Specialist', 'isLocked': true},
            //   ],
            //   cardData: [
            //     ChildCard(
            //       title: "Sparrows",
            //       subtitle: "5 Questions",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Balcony Birding",
            //       onTap: () => print("Clicked Sparrows"),
            //     ),
            //     ChildCard(
            //       title: "Crows",
            //       subtitle: "15 Questions",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Balcony Birding",
            //       topLeftBadge: "Featured",
            //       topRightBadge: "+50XP",
            //       onTap: () => print("Clicked Sparrows"),
            //     ),
            //     ChildCard(
            //       title: "Crows",
            //       subtitle: "15 Questions",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Field Trip",
            //       topLeftBadge: "Featured",
            //       topRightBadge: "+50XP",
            //       onTap: () => print("Clicked Sparrows"),
            //     ),
            //     ChildCard(
            //       title: "Crows",
            //       subtitle: "15 Questions",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Field Trip",
            //       topLeftBadge: "Featured",
            //       topRightBadge: "+50XP",
            //       onTap: () => print("Clicked Sparrows"),
            //     ),
            //     ChildCard(
            //       title: "Hawks",
            //       subtitle: "Migration Specialist",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Medium",
            //       isLocked: true,
            //     ),
            //   ],
            // ),
            //
            // const SizedBox(height: 30),
            //
            // // 3. QUIZZES SECTION
            // AppSection(
            //   title: "Quizzes",
            //   defaultFilter: "Easy",
            //   cardHeight: 200,
            //   cardWidth: 150,
            //   pills: [
            //     {'label': 'Easy', 'isLocked': false},
            //     {'label': 'Medium', 'isLocked': false},
            //   ],
            //   cardData: [
            //     ChildCard(
            //       title: "Sparrows",
            //       subtitle: "5 Questions",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Easy",
            //       onTap: () => print("Clicked Sparrows"),
            //     ),
            //     ChildCard(
            //       title: "Hawks",
            //       subtitle: "Locked",
            //       image: "https://picsum.photos/seed/bird/200/300",
            //       parentPill: "Medium",
            //       isLocked: true,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}