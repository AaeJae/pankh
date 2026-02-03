import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appTokens.dart';
import 'package:pankh/screens/homescreen/homescreen.dart';
import 'package:pankh/widgets/uihelper.dart';
// Import your service to initialize it
import 'package:pankh/services/serBird.dart';
import '../../models/modBird.dart';

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
    // Start a stopwatch to ensure we show the splash for at least a minimum time (e.g. 1.5s)
    // for branding, but don't exceed the actual time needed for data loading.
    final stopwatch = Stopwatch()..start();
    List<modBird> initialBirds = [];

    try {
      initialBirds = await BirdService.getBirds(limitRows: 5, filterColumn: null, filterValue: null);
      for (var bird in initialBirds) {
        if (bird.gitImageURL != "" && mounted) precacheImage(NetworkImage(bird.gitImageURL), context);
      }
    } catch (e) {
      debugPrint("Error during initialization: $e");
    } finally {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 3000) {
        await Future.delayed(Duration(milliseconds: 3000 - elapsed)); // Ensure the splash is visible for at least 1.5 seconds for UX/Branding
      }

      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(carouselBirds: initialBirds))
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
                  child: UiHelper.CustomSvg(
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
                  UiHelper.CustomImage(
                      img: "appIcon.png",
                      width: MediaQuery.of(context).size.width * 0.2
                  ),
                  UiHelper.CustomText(
                    text: "Pankh",
                    color: AppColors.colWhite,
                    fontSize: AppFontSizes.fontSizeLogo,
                    fontFamily: AppFonts.fontFamilyLogo,
                    fontWeight: FontWeight.bold,
                  ),
                  UiHelper.CustomText(
                      text: "Birding | Quizzing | Community",
                      color: AppColors.colWhite,
                      fontSize: AppFontSizes.fontSizeTitle,
                      fontFamily: AppFonts.fontFamilySubtitle,
                      fontWeight: FontWeight.bold
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: UiHelper.CustomImage(
                        img: "SplashMiddleGraphics.png",
                        height: 379,
                        width: MediaQuery.of(context).size.width * 0.9
                    ),
                  ),

                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiHelper.CustomText(
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