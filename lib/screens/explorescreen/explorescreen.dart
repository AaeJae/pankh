import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/widgets/wid_uihelper.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Mock states for the filters
  String activeQuestFilter = "Novice";
  String activeQuizFilter = "Easy";

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
            UiHelper.buildSectionHeaderWithPills("Featured", []), // No filters for featured
            _buildFeaturedCarousel(),

            const SizedBox(height: 30),

            // 2. QUESTS SECTION
            UiHelper.buildSectionHeaderWithPills("Quests", ["Novice", "Ranger", "Expert"],
                currentFilter: activeQuestFilter,
                onTap: (val) => setState(() => activeQuestFilter = val)
            ),
            UiHelper.buildHorizontalCardCarousel(type: "Quest", count: 4, lockedAfterIndex: 1),

            const SizedBox(height: 30),

            // 3. QUIZZES SECTION
            UiHelper.buildSectionHeaderWithPills("Quizzes", ["Easy", "Medium", "Expert"],
                currentFilter: activeQuizFilter,
                onTap: (val) => setState(() => activeQuizFilter = val)
            ),
            UiHelper.buildHorizontalCardCarousel(type: "Quiz", count: 5, lockedAfterIndex: 0),

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
          isFeatured: true,
        ),
      ),
    );
  }




}