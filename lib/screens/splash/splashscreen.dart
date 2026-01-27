import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appTokens.dart';
import 'package:pankh/screens/homescreen/homescreen.dart';
import 'package:pankh/widgets/uihelper.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(duration: const Duration(seconds: 30), vsync: this)..repeat();
    Timer(const Duration(seconds: 4), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
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
        // FIX 1: Apply the Radial Gradient from FFF8D0 to 3B633D
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
              child: RotationTransition(
                turns: _rotationController,
                child: UiHelper.CustomSvg(img: "svgSwirl.svg", height: 550, width: 550, opacity: 0.4)
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: RotationTransition(
                turns: _rotationController,
                child: UiHelper.CustomSvg(img: "svgSwirl.svg", height: 200, width: 200, opacity: 0.6)
              ),
            ),
            Positioned(
              bottom: 10,
              right: -50,
              child: RotationTransition(
                turns: _rotationController,
                child: UiHelper.CustomSvg(img: "svgSwirl.svg", height: 250, width: 250, opacity: 0.2)
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  UiHelper.CustomImage(img: "appIcon.png", width: MediaQuery.of(context).size.width * 0.2),
                  UiHelper.CustomText(text: "Pankh", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeLogo, fontFamily: AppFonts.fontFamilyLogo, fontWeight: FontWeight.bold,),
                  //const SizedBox(height: 10),
                  UiHelper.CustomText(text: "Birding | Quizzing | Community", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeTitle, fontFamily: AppFonts.fontFamilySubtitle, fontWeight: FontWeight.bold),
                  const SizedBox(height: 30),

                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The Mandala Circle background
                        UiHelper.CustomImage(img: "SplashMiddleGraphics.png", height: 379, width: MediaQuery.of(context).size.width * 0.9),
                      ],
                    ),
                  ),

                  const Spacer(),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiHelper.CustomText(text: "Made with ❤️ for Bharat", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeTitle, fontFamily: AppFonts.fontFamilySubtitle,),
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