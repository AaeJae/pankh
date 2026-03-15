import 'package:hive/hive.dart';
import '../models/mod_bird.dart';
import 'ser_birdhive.dart';

class SerBird {
  ////////////////////////
  // GET HIVE CACHED BIRDS WITH GENERIC FILTERS
  ////////////////////////

  static List<ModBird> getBirds({
    int limitRows = 999,
    Map<String, dynamic>? filters, // 👈 generic filters
  }) {
    var box = Hive.box<ModBird>(SerBirdHive.hiveBirdBox);
    List<ModBird> allBirds = box.values.toList();
    if (filters != null && filters.isNotEmpty) {
      allBirds = allBirds.where((bird) {
        bool keep = true;

        filters.forEach((key, value) {
          switch (key) {
            case 'rank':
              if (value is List) {
                keep = keep && value.contains(bird.rank);
              } else if (value is String && value.contains(',')) {
                List<String> ranks =
                value.split(',').map((e) => e.trim()).toList();
                keep = keep && ranks.contains(bird.rank);
              } else {
                keep = keep && bird.rank == value;
              }
              break;

            case 'birdID':
              keep = keep && bird.birdID == value;
              break;

            case 'hasAudio':
              final audioExists = bird.birdAudios.isNotEmpty;
              keep = keep && (value ? audioExists : !audioExists);
              break;

            case 'hasImage':
              final imageExists =
              bird.birdImages.any((img) => img.isFeatured == true);
              keep = keep && (value ? imageExists : !imageExists);
              break;

            case 'hasLore':
              final lore = bird.lore.isNotEmpty;
              keep = keep && (value ? lore : !lore);
              break;
            case 'hasHindiNames':
              final hindiNames = bird.hindiNames.isNotEmpty;
              keep = keep && (value ? hindiNames : !hindiNames);
              break;
            case 'hasMarathiNames':
              final marathiNames = bird.marathiNames.isNotEmpty;
              keep = keep && (value ? marathiNames : !marathiNames);
              break;

            case 'hasDiet':
              final diet = bird.birdInfo.diet.isNotEmpty;
              keep = keep && (value ? diet : !diet);
              break;
            case 'hasHabitat':
              final habitat = bird.birdInfo.habitat.isNotEmpty;
              keep = keep && (value ? habitat : !habitat);
              break;
            case 'hasiucnStatus':
              final iucnStatus = bird.birdInfo.iucnStatus.isNotEmpty;
              keep = keep && (value ? iucnStatus : !iucnStatus);
              break;
            case 'hasFamily':
              final family = bird.birdInfo.family.isNotEmpty;
              keep = keep && (value ? family : !family);
              break;

            default:
            // Unknown filter key → ignore
              break;
          }
        });
        return keep;
      }).toList();
    }
    allBirds.shuffle();
    return allBirds.take(limitRows).toList();
  }



}
