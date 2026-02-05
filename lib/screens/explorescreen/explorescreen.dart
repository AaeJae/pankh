import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/widgets/wid_uihelper.dart';

import '../../widgets/wid_section.dart';

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
            // 1. FEATURED SECTION
          UiHelper.buildSectionHeaderWithPills(title: "Featured"),
          _buildFeaturedCarousel(),

            const SizedBox(height: 30),

            // 2. QUESTS SECTION
            WidSection(
              title: "Quests",
              defaultFilter: "Balcony Birding",
              cardHeight: 200,
              cardWidth: 200,
              pills: [
                {'label': 'Balcony Birding', 'isLocked': false},
                {'label': 'Field Trip', 'isLocked': false},
                {'label': 'Migration Specialist', 'isLocked': true},
              ],
              cardData: [
                ChildCard(
                  title: "Sparrows",
                  subtitle: "5 Questions",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Balcony Birding",
                  onTap: () => print("Clicked Sparrows"),
                ),
                ChildCard(
                  title: "Crows",
                  subtitle: "15 Questions",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Balcony Birding",
                  topLeftBadge: "Featured",
                  topRightBadge: "+50XP",
                  onTap: () => print("Clicked Sparrows"),
                ),
                ChildCard(
                  title: "Crows",
                  subtitle: "15 Questions",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Field Trip",
                  topLeftBadge: "Featured",
                  topRightBadge: "+50XP",
                  onTap: () => print("Clicked Sparrows"),
                ),
                ChildCard(
                  title: "Crows",
                  subtitle: "15 Questions",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Field Trip",
                  topLeftBadge: "Featured",
                  topRightBadge: "+50XP",
                  onTap: () => print("Clicked Sparrows"),
                ),
                ChildCard(
                  title: "Hawks",
                  subtitle: "Migration Specialist",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Medium",
                  isLocked: true,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 3. QUIZZES SECTION
            WidSection(
              title: "Quizzes",
              defaultFilter: "Easy",
              cardHeight: 200,
              cardWidth: 150,
              pills: [
                {'label': 'Easy', 'isLocked': false},
                {'label': 'Medium', 'isLocked': false},
              ],
              cardData: [
                ChildCard(
                  title: "Sparrows",
                  subtitle: "5 Questions",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Easy",
                  onTap: () => print("Clicked Sparrows"),
                ),
                ChildCard(
                  title: "Hawks",
                  subtitle: "Locked",
                  image: "https://picsum.photos/seed/bird/200/300",
                  parentPill: "Medium",
                  isLocked: true,
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI BUILDER METHODS ---


  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) => UiHelper.buildCard(
          width: MediaQuery.of(context).size.width * 0.8,
          title: "Winter Migration",
          subtitle: "Discover Arctic Travelers",
          hasTopLeftBadge: "Featured",
        ),
      ),
    );
  }




}