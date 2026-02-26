import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/constants/designSystemTester.dart';
import '../questscreen/questspatialmapscreen.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staging Area")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("MVP Buy Screen Placeholder"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text("Preview Quest Map"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // 🚀 This navigates to your new spatial map
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestSpatialMapScreen()),
                );
              },
            ),
            AppButton(
              label: "Design Tester",
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => DesignSystemScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}