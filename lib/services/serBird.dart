import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/modBird.dart';

class BirdService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BirdModel>> getAllBirds() async {
    try {
      // Fetches the entire 'birds' collection
      QuerySnapshot snapshot = await _db.collection('birds').get();

      return snapshot.docs.map((doc) {
        return BirdModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching birds: $e");
      return [];
    }
  }
}