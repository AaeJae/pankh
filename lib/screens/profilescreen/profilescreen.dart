import 'package:flutter/material.dart';
import 'package:pankh/services/ser_user.dart';
import 'package:pankh/models/mod_user.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colBackground,
      body: StreamBuilder<ModUser>(
        stream: SerUser.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data ?? SerUser.user;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: AppSizes.sizeLarge),
                _buildProfileStatsOverview(user),
                const SizedBox(height: AppSizes.sizeSmall),
                _buildAchievementsSection(),
                const SizedBox(height: AppSizes.sizeSmall),
                _buildCommunitySection(),
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
          padding: const EdgeInsets.fromLTRB(AppSizes.screenEdge, AppSizes.sizeXLarge, AppSizes.screenEdge, AppSizes.sizeLarge),
          decoration: const BoxDecoration(
            color: AppColors.colQuaternary, // Cream Mist
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(AppSizes.sizeLarge),),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.colWhite,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(user.name[0].toUpperCase(), style: AppTypography.title1,),),
              ),
              const SizedBox(width: AppSizes.sizeSmall),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: AppTypography.title2
                    ),
                    Text(
                      user.isGuest ? "@guest-birder" : "@${user.name.toLowerCase().replaceAll(' ', '-')}",
                      style: AppTypography.subtitle2,
                    ),
                    const SizedBox(height: AppSizes.sizeXSmall),
                    Text(
                      user.isGuest ? "Sign in to choose tags" : "#Foodie #NatureLover #Dancer",
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSizes.sizeXSmall),
                    Text(
                      user.isGuest ? "League: Unranked" : "League: ${user.league}",
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: AppSizes.sizeMedium, color: AppColors.colPrimary),
            ],
          ),
        ),

        // Bird Pet Section
        Positioned(
          bottom: -65,
          right: AppSizes.screenEdge,
          child: Container(
            width: 110,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.colQuaternary,
              borderRadius: BorderRadius.circular(AppSizes.sizeCircular),
              boxShadow: AppShadows.shadowSmall,
            ),
            child: const Center(
              child: Icon(Icons.emoji_nature, size: AppSizes.sizeLarge, color: AppColors.colPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStatsOverview(ModUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(title: "OVERVIEW", subtitle: "Your stats on Pankh", showViewAll: false,),
        const SizedBox(height: AppSizes.sizeXSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
          child: Row(
            children: [
              _statItem("XP", "${user.xp}", Icons.bolt, const Color(0xFFE1F5FE)),
              const SizedBox(width: AppSizes.sizeXSmall),
              _statItem("Streak", "${user.streak}", Icons.local_fire_department, const Color(0xFFFFF3E0)),
              const SizedBox(width: AppSizes.sizeXSmall),
              _statItem("Karma", "${user.karma}", Icons.favorite_sharp, const Color(0xFFF1F8E9)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sizeXSmall),
        decoration: BoxDecoration(
          color: AppColors.colSurface,
          borderRadius: BorderRadius.circular(AppSizes.sizeSmall),
          boxShadow: AppShadows.shadowSmall,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.colPrimary, size: AppSizes.sizeMedium),
            const SizedBox(height: AppSizes.sizeXXSmall),
            Text(value, style: AppTypography.subtitle2.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: AppTypography.body),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSectionTitle(title: "ACHIEVEMENTS", subtitle: "Popular content this week", showViewAll: true, showViewAllLabel: true),
        const SizedBox(height:AppSizes.sizeSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
          child: SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _achievementBadge("Early Bird", Icons.wb_twilight, true),
                _achievementBadge("First Sighting", Icons.visibility, true),
                _achievementBadge("Streak Master", Icons.local_fire_department, false),
                _achievementBadge("Rare Finder", Icons.auto_awesome, false),
                _achievementBadge("Rare Finder", Icons.auto_awesome, false),
                _achievementBadge("Rare Finder", Icons.auto_awesome, false),
                _achievementBadge("Rare Finder", Icons.auto_awesome, false),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _achievementBadge(String name, IconData icon, bool isUnlocked) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sizeSmall),
      child: Column(
        children: [
          CircleAvatar(
            radius: AppSizes.sizeMedium,
            backgroundColor: isUnlocked ? AppColors.colSecondary : AppColors.colDisabled,
            child: Icon(icon, color: AppColors.colWhite, size: AppSizes.sizeMedium),
          ),
          const SizedBox(height: AppSizes.sizeXXSmall),
          Text(name, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(title: "COMMUNITY", subtitle: "The Heart of Pankh", showViewAll: true, showViewAllLabel: true,),
        AppTabContainer(
          height: 300,
          isScrollable: false,
          tabs: [
            AppTab(
              label: "Posts",
              content: [_buildEmptyState("No posts yet. Share your story!")],
            ),
            AppTab(
              label: "Photos",
              content: [_buildEmptyState("Your gallery is empty. Snapshot a bird!")],
            ),
            AppTab(
              label: "Groups",
              content: [_buildEmptyState("Join birding groups to connect!")],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sizeXLarge),
        child: Column(
          children: [
            const Icon(Icons.eco_outlined, color: AppColors.colDisabled, size: 48),
            const SizedBox(height: AppSizes.sizeSmall),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.colOnDisabled),
            ),
          ],
        ),
      ),
    );
  }
}