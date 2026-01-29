import 'package:flutter/material.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Explore Screen"),
      ),
    );


  }

}