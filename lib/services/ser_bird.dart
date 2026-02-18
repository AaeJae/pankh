import 'package:hive/hive.dart';
import '../models/mod_bird.dart';
import 'ser_birdhive.dart';

class SerBird {
  ////////////////////////
  // GET HIVE CACHED BIRDS
  ////////////////////////

  static List<ModBird> getBirds({
    int limitRows = 999,
    String? filterColumn,
    dynamic filterValue,
  }) {
    // 1. Get the box (Must be opened with the type <ModBird>)
    var box = Hive.box<ModBird>(SerBirdHive.hiveBirdBox);

    // 2. Get values directly (They are already ModBird objects!)
    List<ModBird> allBirds = box.values.toList();

    // 3. Filtering logic
    if (filterColumn != null && filterValue != null) {
      allBirds = allBirds.where((bird) {

        // Handle 'rank' specifically to allow multiple difficulties
        if (filterColumn == 'rank') {
          // If filterValue is a List, check if bird.rank is in it
          if (filterValue is List) {
            return filterValue.contains(bird.rank);
          }
          // If filterValue is a String (like "P0, P1"), split it into a list and check
          if (filterValue is String && filterValue.contains(',')) {
            List<String> ranks = filterValue.split(',').map((e) => e.trim()).toList();
            return ranks.contains(bird.rank);
          }
          // Fallback to simple equality
          return bird.rank == filterValue;
        }

        // Standard equality for other columns
        if (filterColumn == 'birdID') return bird.birdID == filterValue;


        return true;
      }).toList();
    }

    allBirds.shuffle();
    return allBirds.take(limitRows).toList();
  }
}