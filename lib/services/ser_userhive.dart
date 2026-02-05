import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mod_user.dart';

class SerUserHive {
  static const String hiveUserBox = "pankh_user_data";
  static const String userKey = "current_user_profile";

  // Initializing the box
  static Future<void> init() async {
    await Hive.openBox(hiveUserBox);
  }

  // Get the cached user to show immediately on Splash/Home
  static ModUser? getCachedUser() {
    try {
      // Check if the box is actually open/initialized
      if (!Hive.isBoxOpen(hiveUserBox)) {
        debugPrint("⚠️ Hive: $hiveUserBox not open yet. Returning null.");
        return null;
      }

      final box = Hive.box(hiveUserBox);
      final data = box.get(userKey);

      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        return ModUser.fromMap(map, map['uid'] ?? "");
      }
    } catch (e) {
      debugPrint("❌ Error reading from Hive: $e");
    }
    return null;
  }
}