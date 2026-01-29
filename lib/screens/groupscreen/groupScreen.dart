import 'package:flutter/material.dart';


class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreen();
}

class _GroupScreen extends State<GroupScreen> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Group Screen"),
      ),
    );


  }

}