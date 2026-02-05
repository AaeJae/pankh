import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SerAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle({int? pendingXP}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase handles "Login vs Signup" automatically here
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // INTERNAL HANDLER: If they are brand new, initialize their Firestore doc
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _initializeNewUser(userCredential.user!, pendingXP ?? 0);
      }
      return userCredential.user;
    } catch (e) {
      debugPrint("Auth Error: $e");
      return null;
    }
  }

  Future<void> _initializeNewUser(User user, int pendingXP) async {
    // Put your "Welcome to Pankh" logic here (Set XP to 0, Karma to 10, etc.)
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'xp': pendingXP,
      'streak':0,
      'karma': 0,
      'league': 'Seedling',
      'is_anonymous': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
