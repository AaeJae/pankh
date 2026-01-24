import 'package:flutter/material.dart';
import 'package:pankh/widgets/uihelper.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomImage(img: "hummingBird.png"),
            SizedBox(height: 30),
            UiHelper.CustomImage(img: "sparrowVector.png"),
            SizedBox(height: 10),
            UiHelper.CustomText(
              text: "Test Text",
              color: Color(0xFF000000),
              fontWeight: FontWeight.bold,
              fontFamily: "regular",
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
