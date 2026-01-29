import 'package:flutter/material.dart';

import '../../widgets/widBotMenu.dart';
import '../../widgets/widHeader.dart';


class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreen();
}

class _BuyScreen extends State<BuyScreen> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(

     body: const Center(
        child: Text("Buy Screen"),
      ),
    );





  }

}