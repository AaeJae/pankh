import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Design System
import 'package:pankh/constants/appDesignSystem.dart';

// Services
import '../../constants/designSystemTester.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_bird.dart';
import '../../services/ser_thirdpartydata.dart';
import '../../services/ser_user.dart';
import '../../services/ser_syncfirebasehive.dart';
import '../homescreen/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Using 'late final' for better memory management of the controller
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
        duration: const Duration(seconds: 30),
        vsync: this
    )..repeat();

    _initializeApp();
  }

  /// Initialize all required services and data
  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start();
    List<ModBird> initialBirds = [];

    try {
      // 1. AUTH LOGIC
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
      await SerUser.checkUserExists();
      SerUser.startListening();

      // 2. DATA SYNC
      await SerSyncFirebaseHive().syncBirds();

      // 3. CAROUSEL BIRDS
      initialBirds = SerBird.getBirds(limitRows: 10);

      try {
        // Performance: Added a timeout to prevent infinite splash hang on poor network
        final nearbyBirds = await ThirdPartyDataService.ebirdNearbyBirds()
            .timeout(AppDurations.durationXSlow);

        if (nearbyBirds != null && nearbyBirds.isNotEmpty) {
          initialBirds = nearbyBirds;
        }
      } catch (_) {
        debugPrint("Using default birds (eBird timed out/failed)");
      }

      // 4. PRE_CACHE BIRDS - Optimized: Uses the splash duration to warm up memory
      if (mounted) {
        for (var bird in initialBirds) {
          precacheImage(NetworkImage(bird.featuredImage.imageURL), context);
        }
      }

    } catch (e) {
      debugPrint("❌ Initialization error: $e");
    } finally {
      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      // Using 2500ms for consistent branding presence
      if (elapsed < 2500) await Future.delayed(Duration(milliseconds: 2500 - elapsed));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    // Battery Performance: Ensuring ticker is killed immediately
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            // Applying design tokens
            colors: [AppColors.colQuaternary, AppColors.colSecondary],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -250,
              left: -250,
              child: RepaintBoundary(
                child: RotationTransition(
                  turns: _rotationController,
                  child: SvgPicture.asset(
                    "assets/svg/svgSwirls.svg",
                    height: 550,
                    width: 550,
                    // Use ColorFilter for performance and design token application
                    colorFilter: ColorFilter.mode(
                        AppColors.colPrimary.withAlpha(AppAlpha.alphaMedium),
                        BlendMode.srcIn
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.sizeXLarge),
                  const SizedBox(height: AppSizes.sizeXLarge),
                  const SizedBox(height: AppSizes.sizeLarge),
                  // Image.asset(
                  //     "assets/images/appIcon.png",
                  //     width: MediaQuery.of(context).size.width * 0.2
                  // ),
                  Text(
                    "Pankh",
                    style: AppTypography.logo.copyWith(
                      color: AppColors.colWhite,
                    ),
                  ),
                  Text(
                    "Birding | Quizzing | Community",
                    style: AppTypography.subtitle2.copyWith(
                      color: AppColors.colWhite,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sizeXLarge),

                  Center(
                    child: Image.asset(
                        "assets/images/SplashMiddleGraphics.webp",
                        height: 379,
                        width: MediaQuery.of(context).size.width * 0.9
                    ),
                  ),

                  const Spacer(),
                  // "Made in Bharat" section with design tokens
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sizeMedium),
                    child: Text(
                      "Made with ❤️ for Bharat",
                      style: AppTypography.body.copyWith(
                        color: AppColors.colWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}