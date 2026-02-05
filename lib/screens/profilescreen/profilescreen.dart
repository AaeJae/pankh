import 'package:flutter/material.dart';
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/widgets/wid_uihelper.dart';
// Added missing imports for data access
import 'package:pankh/services/ser_user.dart';
import 'package:pankh/models/mod_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // We wrap the entire stream here so the header and stats update together
      body: StreamBuilder<ModUser>(
        stream: SerUser.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data ?? SerUser.user;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // 1. Pass the user object to the header
                _buildProfileHeader(user),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // 2. Pass the user object to the stats overview
                      _buildProfileStatsOverview(user),
                      const SizedBox(height: 20),

                      _buildAchievementsSection(),
                      const SizedBox(height: 20),

                      _buildActivitySection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ModUser user) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
          decoration: const BoxDecoration(
            color: Color(0xFFF2E4B5),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic User DP or Initial
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: AppColors.colPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiHelper.customText(
                      text: user.name, // DYNAMIC NAME
                      fontSize: AppFontSizes.fontSizeTitleBig,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colPrimary,
                    ),
                    UiHelper.customText(
                      text: user.isGuest ? "@guest-birder" : "@${user.name.toLowerCase().replaceAll(' ', '-')}",
                      fontSize: AppFontSizes.fontSizeBody,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colPrimary,
                    ),
                    const SizedBox(height: 5),
                    UiHelper.customText(
                      text: user.isGuest ? "Sign in to choose tags" : "#Foodie #NatureLover #Dancer",
                      fontSize: AppFontSizes.fontSizeCaption,
                      fontWeight: FontWeight.normal,
                      color: AppColors.colPrimary,
                    ),
                    const SizedBox(height: 5),
                    UiHelper.customText(
                      text: user.isGuest ? "Unranked" : "League: ${user.league}",
                      fontSize: AppFontSizes.fontSizeCaption,
                      fontWeight: FontWeight.normal,
                      color: AppColors.colPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.edit, size: 25, color: AppColors.colPrimary),
            ],
          ),
        ),

        // BIRD PET SECTION
        Positioned(
          bottom: -55,
          right: 20,
          child: Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF2E4B5),
              borderRadius: BorderRadius.circular(200),
            ),
            child: const Center(
              child: Icon(Icons.emoji_nature, size: 40, color: Colors.black87),
            ),
          ),
        ),

        // end BIRD PET SECTION

      ],
    );
  }

  Widget _buildProfileStatsOverview(ModUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        UiHelper.customText(
          text: "Overview",
          fontSize: AppFontSizes.fontSizeTitle,
          fontWeight: FontWeight.bold,
          color: AppColors.colPrimary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // DYNAMIC STATS FROM CACHE/FIREBASE
            UiHelper.statCardBuilder("XP", user.xp.toString(), Icons.bolt, const Color(0xFFE1F5FE)),
            const SizedBox(width: 12),
            UiHelper.statCardBuilder("Streak", user.streak.toString(), Icons.local_fire_department, const Color(0xFFFFF3E0)),
            const SizedBox(width: 12),
            UiHelper.statCardBuilder("Karma", user.karma.toString(), Icons.favorite_sharp, const Color(0xFFF1F8E9)),
          ],
        ),
      ],
    );
  }

  // TODO
  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiHelper.customText(
          text: "Achievements",
          fontSize: AppFontSizes.fontSizeTitle,
          fontWeight: FontWeight.bold,
          color: AppColors.colPrimary,
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              UiHelper.badgeBuilder("Early Bird", Icons.wb_twilight, isUnlocked: true),
              UiHelper.badgeBuilder("First Sighting", Icons.remove_red_eye, isUnlocked: true),
              UiHelper.badgeBuilder("Streak Master", Icons.local_fire_department, isUnlocked: false),
              UiHelper.badgeBuilder("Rare Finder", Icons.auto_awesome, isUnlocked: false),
              UiHelper.badgeBuilder("Guardian", Icons.shield, isUnlocked: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return DefaultTabController(
      length: 3, // Posts, Photos, Groups
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiHelper.customText(
            text: "Community",
            fontSize: AppFontSizes.fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: AppColors.colPrimary,
          ),
          const SizedBox(height: 10),

          // The Tab Bar
          TabBar(
            labelColor: AppColors.colPrimary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.colOnTertiary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Posts"),
              Tab(text: "Photos"),
              Tab(text: "Groups"),
            ],
          ),

          // The Content Area
          SizedBox(
            height: 300, // Fixed height for the scrollable area
            child: TabBarView(
              children: [
                _buildActivityList("No posts yet. Share your first birding story!"),
                _buildActivityList("Your gallery is empty. Snapshot a bird!"),
                _buildActivityList("You haven't joined any birding groups yet."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(String emptyMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty_rounded, color: Colors.grey[300], size: 50),
            const SizedBox(height: 10),
            UiHelper.customText(
              text: emptyMessage,
              textAlign: TextAlign.center,
              color: Colors.grey,
              fontSize: AppFontSizes.fontSizeCaption,
            ),
          ],
        ),
      ),
    );
  }
}
