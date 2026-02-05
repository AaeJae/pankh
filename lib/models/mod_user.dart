import 'package:cloud_firestore/cloud_firestore.dart';

class ModUser {
  final String uid;
  final String name;
  final int xp;
  final int streak;
  final int karma;
  final String league;
  final bool isGuest;
  final DateTime? createdAt;

  ModUser({
    required this.uid,
    required this.name,
    required this.xp,
    required this.streak,
    required this.karma,
    required this.league,
    required this.isGuest,
    this.createdAt,
  });

  // --- FROM FIRESTORE ---
  // This converts the Map from Firebase into a ModUser object
  factory ModUser.fromMap(Map<String, dynamic> data, String documentId) {
    return ModUser(
      uid: documentId,
      name: data['name'] ?? 'Guest Birdie',
      xp: data['xp'] ?? 0,
      streak: data['streak'] ?? 0,
      karma: data['karma'] ?? 0,
      league: data['league'] ?? 'Seedling',
      isGuest: data['is_anonymous'] ?? true,
    );
  }

  // --- TO MAP ---
  // Useful if you ever need to update the whole user object back to Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'xp': xp,
      'streak': streak,
      'karma': karma,
      'league': league,
      'isGuest': isGuest,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}