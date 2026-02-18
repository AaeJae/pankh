import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/mod_bird.dart';
import 'ser_birdhive.dart';

class SerSyncFirebaseHive {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncBirds() async {
    final Box<ModBird> _birdBox = Hive.box<ModBird>(SerBirdHive.hiveBirdBox);
    final Box _settingsBox = Hive.box('settings');

    try {
      // 1. Fetch Global Server Version
      DocumentSnapshot meta = await _firestore
          .collection('sync_metadata')
          .doc('last_run')
          .get();

      // Default to '0' if the field doesn't exist to force initial sync
      String serverVersion = meta['currentVersion']?.toString() ?? '0';
      String localVersion = _settingsBox.get('birdBoxVersion', defaultValue: '-1');

      // 2. Global Check: If versions match, skip the entire process
      if (serverVersion == localVersion && _birdBox.isNotEmpty) {
        debugPrint("✅ Bird box is up to date (Version: $serverVersion). Skipping sync.");
        return;
      }

      debugPrint("🔄 Syncing birds: Local($localVersion) -> Server($serverVersion)");
      // 3. Fetch all birds from Firestore
      QuerySnapshot snapshot = await _firestore.collection('birds').get();
      Map<int, ModBird> updateMap = {};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          // Pass serverVersion as a constant to all birds for the local record
          final bird = ModBird.fromFirestore(data, manualVersion: serverVersion);
          updateMap[bird.birdID] = bird;
        } catch (e) {
          debugPrint("❌ Error parsing bird ${doc.id}: $e");
        }
      }

      // 4. Update Hive and Local Version
      await _birdBox.clear(); // Clear old data to ensure a clean sync
      await _birdBox.putAll(updateMap);
      await _settingsBox.put('birdBoxVersion', serverVersion);

      debugPrint("✅ Successfully synced ${updateMap.length} birds to version $serverVersion");

    } catch (e) {
      debugPrint("❌ Sync Failed: $e");
    }
  }
}