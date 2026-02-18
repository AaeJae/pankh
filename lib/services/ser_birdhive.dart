import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/mod_bird.dart'; // Make sure the path is correct

class SerBirdHive {
  static const String hiveBirdBox = "pankh_birds";

  static Future<void> init() async {
    // Register ALL Adapters (Order doesn't matter, but IDs must match your model)
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ModBirdAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(BirdInfoAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BirdImageAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(BirdAudioAdapter());

    // 3. Open the Box with the Type
    await Hive.openBox<ModBird>(hiveBirdBox);

    print("📦 Hive initialized and Box '$hiveBirdBox' is open.");
  }

  // Use this if you want to wipe the local cache (e.g., for a 'Refresh' button)
  static Future<void> clearCache() async {
    var box = Hive.box<ModBird>(hiveBirdBox);
    await box.clear();
  }
}
