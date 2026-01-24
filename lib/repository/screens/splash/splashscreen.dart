import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/domain/constants/appColors.dart';
import '../../../widgets/uihelper.dart';
import '../homescreen/homescreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [UiHelper.CustomImage(img: "hummingBird.png")],
      ),
    );
  }
}
