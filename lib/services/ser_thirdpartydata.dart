import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../services/ser_bird.dart'; // Assuming this is your bird service path
import '../models/mod_bird.dart';

class ThirdPartyDataService {
  static const String _ebirdApiKey = 'vd8itdkpv9a';

  static Future<List<ModBird>> ebirdNearbyBirds(String hotspotName) async {

    ///////////////////////////////////////////////////
    // GET COORDINATES FOR SELECTED CITY
    ///////////////////////////////////////////////////
    double lat = 21.1458; // Default Nagpur
    double lng = 79.0882;

    try {
      final geoUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$hotspotName&format=json&limit=1');
      final geoResponse = await http.get(geoUrl, headers: {'User-Agent': 'Pankh_Bird_App'});

      if (geoResponse.statusCode == 200) {
        final List geoData = json.decode(geoResponse.body);
        if (geoData.isNotEmpty) {
          lat = double.parse(geoData[0]['lat']);
          lng = double.parse(geoData[0]['lon']);
          debugPrint("📍 Coords found: $lat, $lng");
        }
      }
    } catch (e) {
      debugPrint("⚠️ Geocoding failed, using India default: $e");
    }

    ///////////////////////////////////////////////////
    // GET EBIRD NEARBY LIST
    ///////////////////////////////////////////////////
    List<String> comNameBirds = [];
    try {

      final response = await http.get(
          Uri.parse(
              'https://api.ebird.org/v2/data/obs/geo/recent?lat=$lat&lng=$lng&dist=50'),
          headers: {'X-eBirdApiToken': _ebirdApiKey});

      if (response.statusCode == 200) {
        final List ebirdSpotterBirds = json.decode(response.body);
        comNameBirds = ebirdSpotterBirds
            .map((obs) => obs['comName'].toString().toLowerCase().trim())
            .toList();
        debugPrint("🌍 eBird Birds Loaded: ${comNameBirds.length}");
      }
    } catch (e) {
      debugPrint("❌ API Error: $e");
    }
    ///////////////////////////////////////////////////
    // FETCH PANKH BIRD HIVE LIST
    ///////////////////////////////////////////////////

    List<ModBird> hiveBirds = await SerBird.getBirds();
    debugPrint("📦 Hive Birds Loaded: ${hiveBirds.length}");

    ///////////////////////////////////////////////////
    // COMPARE INTERSECTION
    ///////////////////////////////////////////////////
    final Set<String> ebirdSet = comNameBirds.toSet();
    List<ModBird> matchedBirds = hiveBirds.where((bird) {
      String cleanName = bird.birdName.toLowerCase().trim();
      return ebirdSet.contains(cleanName);
    }).toList();

    matchedBirds.forEach((bird) => debugPrint("🦜 Matched: ${bird.birdName}"));
    return matchedBirds.take(10).toList();
  }
}