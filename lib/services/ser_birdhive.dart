import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/mod_bird.dart'; // Make sure the path is correct

class SerBirdHive {
  static const String hiveBirdBox = "pankh_birds";

  static Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Seed the data from CSV
    await _seedDataFromPankhMasterCSV();
  }

  static Future<void> _seedDataFromPankhMasterCSV() async {
    var box = await Hive.openBox(hiveBirdBox);

    // DEV TIP: Uncomment the line below during development
    // to force a fresh import every time you update the CSV.
    // await box.clear();

    if (box.isEmpty) {
      print("Hive box is empty. Starting seeding process...");

      try {
        final String rawData = await rootBundle.loadString('assets/data/PankhMaster.csv'); // 1. Load the raw CSV string from assets
        List<List<dynamic>> rows = const CsvToListConverter().convert(rawData); // 2. Convert CSV string into a List of Lists
        for (int i = 1; i < rows.length; i++) { // 3. Loop through rows (Start at 1 to skip the header)
          final row = rows[i];
          ModBird bird = ModBird.fromCsv(row); // Use our model to parse the row
          await box.put(bird.birdID, bird.toMap()); // Save to Hive using birdID as the key
        }

        print("Successfully seeded ${box.length} birds into Hive.");
      } catch (e) {
        print("Error seeding Hive: $e");
      }
    } else {
      print("Hive already contains ${box.length} birds. Skipping seed.");
    }
  }


}