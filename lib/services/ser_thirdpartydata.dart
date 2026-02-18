import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pankh/services/ser_birdhive.dart';
import '../models/mod_bird.dart';

class ThirdPartyDataService {
  static const String _ebirdApiKey = 'vd8itdkpv9a';

  static Future<List<ModBird>> ebirdNearbyBirds({double? lati, double? lngi}) async {
    double lat = lati ?? 19.0760;
    double lng = lngi ?? 72.8777;
    //List<ModBird> myBirds = SerBird.getBirds();
    //debugPrint("--------------------myBirds: ${myBirds.length}");

    final url = Uri.parse('https://api.ebird.org/v2/data/obs/geo/recent?lat=$lat&lng=$lng&dist=50');

    try {
      final response = await http.get(url, headers: {'X-eBirdApiToken': _ebirdApiKey});

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        Set<String> nearbyCodes = data
            .map((obs) => obs['speciesCode'].toString().toLowerCase())
            .toSet();
        debugPrint("--------------------ebirdBird50NearbySet: ${nearbyCodes.length}");

        final box = Hive.box<ModBird>(SerBirdHive.hiveBirdBox);

        final matchedBirds = box.values.where((bird) {
          return nearbyCodes.contains(bird.eBirdCode.toLowerCase());
        }).toList();
        debugPrint("--------------------matched Set: ${matchedBirds.length}");
        matchedBirds.shuffle();
        return matchedBirds.take(10).toList();
      }
    }
    catch (e) {
      debugPrint("Error in ebirdNearbyBirds: $e");
    }
    return [];
  }
}