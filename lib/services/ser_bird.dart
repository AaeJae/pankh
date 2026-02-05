import 'package:hive/hive.dart';
//custom file imports
import '../models/mod_bird.dart';
import 'ser_birdhive.dart';

class SerBird {
  ////////////////////////
  // GET HIVE CACHED BIRDS
  ////////////////////////

  static List<ModBird> getBirds({
    int limitRows=999,
    String? filterColumn,
    dynamic filterValue,
  }) {
    var box = Hive.box(SerBirdHive.hiveBirdBox);
    List<ModBird> allBirds = box.values.map((data) => ModBird.fromMap(data)).toList();

    // Mimic Firestore Filtering
    if (filterColumn != null && filterValue != null) {
      allBirds = allBirds.where((bird) {
        final birdMap = bird.toMap();
        return birdMap[filterColumn] == filterValue;
      }).toList();
    }

    allBirds.shuffle(); // Good for Carousel and Quizzes
    return allBirds.take(limitRows).toList();
  }
}