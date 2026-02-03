import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/modBird.dart';

class BirdService {
  // In serBird.dart

  static Future<List<modBird>> getBirds({
    int limitRows = 5,
    String? filterColumn,
    dynamic filterValue,
  }) async {
    try {
      Query query = FirebaseFirestore.instance.collection('birds');

      if (filterColumn != null && filterValue != null) {
        query = query.where(filterColumn, isEqualTo: filterValue);
      }

      // Limit the fetch to save DB costs and bandwidth
      final snapshot = await query.limit(limitRows).get();

      // RESOURCE EFFICIENT: Use your existing factory constructor
      return snapshot.docs.map((doc) {
        return modBird.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

    } catch (e) {
      return [];
    }
  }

}