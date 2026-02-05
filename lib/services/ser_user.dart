import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:async';
//custom file imports
import '../models/mod_user.dart';
import 'ser_userhive.dart';

class SerUser {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Layer 1: Memory Cache (Instant access while app is running)
  static ModUser? _cachedUser;
  static StreamSubscription<ModUser>? _userSubscription;

  /// 1. Initialize/Verify Profile
  /// Uses Hive to skip Firestore 'get' calls for returning users.
  static Future<void> checkUserExists() async {
    if (uid.isEmpty) return;

    final hiveUserBox = Hive.box(SerUserHive.hiveUserBox);
    final String verificationKey = 'profile_verified_$uid';

    // Skip if we've already verified this specific UID on this device
    if (hiveUserBox.get(verificationKey, defaultValue: false)) {
      debugPrint("✅ Profile verified via Hive key: $verificationKey");
      return;
    }

    final userDoc = _db.collection('users').doc(uid);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'name': "Guest Birder",
        'xp': 0,
        'streak': 0,
        'karma': 10,
        'league': 'Seedling',
        'isGuest': isGuest,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("🆕 Created new Firestore profile for $uid");
    }

    // Mark verified so splash screen is faster next time
    await hiveUserBox.put(verificationKey, true);
  }

  /// 2. Real-time Listener
  /// Updates both Memory Cache and Hive Disk Cache whenever DB changes.
  static void startListening() {
    if (uid.isEmpty) return;

    _userSubscription?.cancel();
    _userSubscription = userStream.listen((user) {
      _cachedUser = user;

      // Update Layer 2: Hive Disk Cache
      Hive.box(SerUserHive.hiveUserBox).put(SerUserHive.userKey, user.toMap());
    }, onError: (e) => debugPrint("❌ SerUser Stream Error: $e"));
  }

  /// 3. The "Magic" Getter
  /// Provides the UI with data in 0.0ms by falling back through layers.
  static ModUser get user {
    if (_cachedUser != null) return _cachedUser!;

    final diskCached = SerUserHive.getCachedUser();
    if (diskCached != null) return diskCached;

    return ModUser(
      uid: uid,
      name: "Guest Birder",
      xp: 0,
      streak: 0,
      karma: 0,
      league: 'Seedling',
      isGuest: true,
    );
  }

  //////////////////////////
  // --- USER GETTERS ---
  //////////////////////////
  static String get uid => _auth.currentUser?.uid ?? "";
  static String get displayName => user.name;
  static int get currentXP => user.xp;
  static int get currentStreak => user.streak;
  static int get currentKarma => user.karma;
  static bool get isGuest => _auth.currentUser?.isAnonymous ?? true;

  static Stream<ModUser> get userStream {
    if (uid.isEmpty) return const Stream.empty();

    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return ModUser.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return user;
    });
  }

  //////////////////////////
  // --- UPDATERS ---
  //////////////////////////

  static Future<void> updateXP(int amount) async {
    if (uid.isEmpty) return;
    try {
      await _db.collection('users').doc(uid).update({
        'xp': FieldValue.increment(amount),
      });
    } catch (e) {
      debugPrint("Error updating XP: $e");
    }
  }

  static void dispose() {
    _userSubscription?.cancel();
    _cachedUser = null;
  }
}