import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your service to initialize it
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/widgets/wid_uihelper.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_bird.dart';
import '../../services/ser_thirdpartydata.dart';
import '../../services/ser_user.dart';
import '../../services/ser_syncfirebasehive.dart';
import '../homescreen/homescreen.dart';
import '../quizscreen/quiz_binocsSpotter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Use super parameters

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
        duration: const Duration(seconds: 30),
        vsync: this
    )..repeat();

    // Start initialization logic
    _initializeApp();
  }

  /// Initialize all required services and data before moving to Home
  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start(); // Start a stopwatch to ensure we show the splash for at least a minimum time (e.g. 1.5s) for branding, but don't exceed the actual time needed for data loading.
    List<ModBird> initialBirds = [];


    try {
      ///////////////////
      // 1. CHECK IF USER HAS A UID, IF NOT, GIVE
      ///////////////////
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
        debugPrint("Logged in silently as Guest");
      } else {
        debugPrint("User already logged in: ${auth.currentUser!.uid}");
      }
      await SerUser.checkUserExists();
      SerUser.startListening();

      ////////////////////
      // --- 2. SYNC FIREBASE TO HIVE - check the version first; it's very fast if no update is needed---
      ///////////////////
      await SerSyncFirebaseHive().syncBirds();


      ////////////////////
      // --- 3. CAROUSEL BIRDS - GET ANY 10 first from Hive, ideally wait for eBird nearby data and fetch those from Hive ---
      ///////////////////
      initialBirds = SerBird.getBirds(limitRows: 10);
      if (initialBirds.isEmpty) {
        // If still empty, the sync definitely failed or the box isn't being read correctly.
        debugPrint("⚠️ Warning: initialBirds is still empty after sync!");
      }
      // Try to refine with eBird Nearby Data (with a timeout)
      try {
        final nearbyBirds = await ThirdPartyDataService.ebirdNearbyBirds().timeout(const Duration(seconds: 2));
        debugPrint("Nearby birds from ebird: $nearbyBirds");

        if (nearbyBirds != null && nearbyBirds.isNotEmpty) {
          initialBirds = nearbyBirds;
        }
      } catch (_) {
        debugPrint("Using default birds (eBird timed out/failed)");
      }

      ////////////////////
      // --- 4. PRE_CACHE BIRDS - only what is needed for the carousel ---
      ///////////////////
      if (mounted) {
        for (var bird in initialBirds) {
          precacheImage(NetworkImage(bird.featuredImage.imageURL), context);
        }
      }
      // end get carousel birds

    } catch (e) {
      debugPrint("❌ Initialization error: $e");
    } finally {
      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 2500) await Future.delayed(Duration(milliseconds: 2500 - elapsed));
      debugPrint("✅ Initialbirds: $initialBirds");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BinocsSpotterScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
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
            colors: [AppColors.colTertiary, AppColors.colSecondary],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -250,
              left: -250,
              // PERFORMANCE FIX: RepaintBoundary isolates the rotation animation
              // preventing the entire stack from rebuilding every frame.
              child: RepaintBoundary(
                child: RotationTransition(
                  turns: _rotationController,
                  child: UiHelper.customSvg(
                      img: "svgSwirl.svg",
                      height: 550,
                      width: 550,
                      opacity: 0.4
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  UiHelper.customImage(
                      img: "appIcon.png",
                      width: MediaQuery.of(context).size.width * 0.2
                  ),
                  UiHelper.customText(
                    text: "Pankh",
                    color: AppColors.colWhite,
                    fontSize: AppFontSizes.fontSizeLogo,
                    fontFamily: AppFonts.fontFamilyLogo,
                    fontWeight: FontWeight.bold,
                  ),
                  UiHelper.customText(
                      text: "Birding | Quizzing | Community",
                      color: AppColors.colWhite,
                      fontSize: AppFontSizes.fontSizeTitle,
                      fontFamily: AppFonts.fontFamilySubtitle,
                      fontWeight: FontWeight.bold
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: UiHelper.customImage(
                        img: "SplashMiddleGraphics.png",
                        height: 379,
                        width: MediaQuery.of(context).size.width * 0.9
                    ),
                  ),

                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiHelper.customText(
                        text: "Made with ❤️ for Bharat",
                        color: AppColors.colWhite,
                        fontSize: AppFontSizes.fontSizeTitle,
                        fontFamily: AppFonts.fontFamilySubtitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}