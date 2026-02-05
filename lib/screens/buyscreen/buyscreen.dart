import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/mod_bird.dart';
import '../../services/ser_thirdpartydata.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});
  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final ThirdPartyDataService _dataService = ThirdPartyDataService();

  @override
  void initState() {
    super.initState();
    //ThirdPartyDataService.ebirdNearbyBirds("Thane");
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Console Test Running...")),
    );
  }
}