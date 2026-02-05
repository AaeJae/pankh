import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your service to initialize it
import 'package:pankh/constants/app_tokens.dart';
import 'package:pankh/screens/homescreen/homescreen.dart';
import 'package:pankh/widgets/wid_uihelper.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_bird.dart';
import '../../services/ser_user.dart';

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
      // CHECK IF USER HAS A UID, IF NOT, GIVE
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
      // --- CAROUSEL BIRDS PRECACHE FROM GIT REPO URL VIA HIVE ---
      ///////////////////
      initialBirds = SerBird.getBirds(limitRows: 10); // Get 10 random birds for Carousel
      for (var bird in initialBirds) {
        if (bird.gitImageURL.isNotEmpty && mounted) {
          precacheImage(NetworkImage(bird.gitImageURL), context); // Pre-cache images (Still needed since images are URLs to Git)
        }
      }
      // end get carousel birds

    } catch (e) {
      debugPrint("Error during initialization: $e");
    } finally {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 3000) await Future.delayed(Duration(milliseconds: 3000 - elapsed)); // Ensure the splash is visible for at least 3 seconds for UX/Branding
      if (mounted) Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(carouselBirds: initialBirds)));

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