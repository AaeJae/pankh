import 'package:hive/hive.dart';
part 'mod_bird.g.dart'; // Run: flutter packages pub run build_runner build

@HiveType(typeId: 0)
class ModBird extends HiveObject {
  @HiveField(0)
  final int birdID; // int

  @HiveField(1)
  final String rank;

  @HiveField(2)
  final String birdName;

  @HiveField(3)
  final String sciName;

  @HiveField(4)
  final String eBirdCode;

  @HiveField(5)
  final List<String> hindiNames;

  @HiveField(6)
  final List<String> marathiNames;

  @HiveField(7)
  final String lore;

  @HiveField(8)
  final String quality;

  @HiveField(9)
  final List<BirdImage> birdImages;

  @HiveField(10)
  final List<BirdAudio> birdAudios;

  @HiveField(11)
  final BirdInfo birdInfo;

  @HiveField(12)
  final String syncVersion;

  ModBird({
    required this.birdID, // int
    required this.rank,
    required this.birdName,
    required this.sciName,
    required this.eBirdCode,
    required this.lore,
    required this.quality,
    required this.hindiNames,
    required this.marathiNames,
    required this.birdImages,
    required this.birdAudios,
    required this.birdInfo,
    required this.syncVersion,
  });

  // Factory to parse Firebase / JSON
  factory ModBird.fromFirestore(Map<String, dynamic> data, {String? manualVersion}) {
    return ModBird(
      birdID: data['birdID'] is String
          ? int.parse(data['birdID'])
          : (data['birdID'] ?? 0),
      rank: data['rank'] ?? '',
      birdName: data['birdName'] ?? '',
      sciName: data['sciName'] ?? '',
      eBirdCode: data['eBirdCode'] ?? '',
      lore: data['lore'] ?? '',
      quality: data['quality'] ?? '',
      hindiNames: List<String>.from(data['hindiNames'] ?? []),
      marathiNames: List<String>.from(data['marathiNames'] ?? []),
      birdImages: (data['birdImages'] as List? ?? [])
          .map((i) => BirdImage.fromMap(i))
          .toList(),
      birdAudios: (data['birdAudios'] as List? ?? [])
          .map((a) => BirdAudio.fromMap(a))
          .toList(),
      birdInfo: BirdInfo.fromMap(data['birdInfo'] ?? {}),
      syncVersion: manualVersion ?? '',
    );
  }
  // Helper to handle unexpected Firebase types
  static String _convertToString(dynamic value) {
    if (value == null) return "";
    if (value is String) return value;
    // If it's a Firebase Timestamp, convert to ISO string
    if (value.runtimeType.toString() == 'Timestamp') {
      return value.toDate().toIso8601String();
    }
    return value.toString();
  }
  // Getter for the Featured Image (Safe Fallback)
  BirdImage get featuredImage => birdImages.firstWhere(
        (img) => img.isFeatured,
    orElse: () => birdImages.isNotEmpty
        ? birdImages.first
        : BirdImage(imageURL: '', isFeatured: false, source: 'Unknown',  sourceCreator: 'Unknown', sourceCreatorFull: 'Unknown', sourceLicense: 'Unknown'),
  );

  String? get diet => birdInfo.diet;
  String? get habitat => birdInfo.habitat;
  String? get family => birdInfo.family;
  String? get iucnStatus => birdInfo.iucnStatus;
  String? get name => birdName;


}

@HiveType(typeId: 1)
class BirdInfo {
  @HiveField(0)
  final String order;
  @HiveField(1)
  final String family;
  @HiveField(2)
  final String genus;
  @HiveField(3)
  final String specie;
  @HiveField(4)
  final String iucnStatus;
  @HiveField(5)
  final double kgMass; // double or int?
  @HiveField(6)
  final String habitat;
  @HiveField(7)
  final String diet;
  @HiveField(8)
  final String mating;
  @HiveField(9)
  final String breeding;
  @HiveField(10)
  final String parasitism;
  @HiveField(11)
  final String flight;
  @HiveField(12)
  final String movement;

  BirdInfo({
    required this.order,
    required this.family,
    required this.genus,
    required this.specie,
    required this.iucnStatus,
    required this.kgMass, //double or int?
    required this.habitat,
    required this.diet,
    required this.mating,
    required this.breeding,
    required this.parasitism,
    required this.flight,
    required this.movement,
  });

  factory BirdInfo.fromMap(Map<dynamic, dynamic> map) => BirdInfo(
    order: map['order'] ?? '',
    family: map['family'] ?? '',
    genus: map['genus'] ?? '',
    specie: map['specie'] ?? '',
    iucnStatus: map['iucnStatus'] ?? '',
    kgMass: (map['kgMass'] as num?)?.toDouble() ?? 0.0, // double or int?
    habitat: map['habitat'] ?? '',
    diet: map['diet'] ?? '',
    mating: map['mating'] ?? '',
    breeding: map['breeding'] ?? '',
    parasitism: map['parasitism'] ?? '',
    flight: map['flight'] ?? '',
    movement: map['movement'] ?? '',
  );


}

@HiveType(typeId: 2)
class BirdImage {
  @HiveField(0)
  final String imageURL;
  @HiveField(1)
  final bool isFeatured; // boolean
  @HiveField(2)
  final String source;
  @HiveField(3)
  final String sourceCreator;
  @HiveField(4)
  final String sourceCreatorFull;
  @HiveField(5)
  final String sourceLicense;


  BirdImage({
    required this.imageURL,
    required this.isFeatured, // boolean
    required this.source,
    required this.sourceCreator,
    required this.sourceCreatorFull,
    required this.sourceLicense,
  });

  factory BirdImage.fromMap(Map<dynamic, dynamic> map) => BirdImage(
    imageURL: map['imageURL'] ?? '',
    isFeatured: map['isFeatured'] ?? false,
    source: map['source'] ?? '',
    sourceCreator: map['sourceCreator'] ?? '',
    sourceCreatorFull: map['sourceCreatorFull'] ?? '',
    sourceLicense: map['sourceLicense'] ?? '',
  );
}

@HiveType(typeId: 3)
class BirdAudio {
  @HiveField(0)
  final String audioURL;
  @HiveField(1)
  final String audioType;
  @HiveField(2)
  final int length; // int
  @HiveField(3)
  final String source;
  @HiveField(4)
  final String sourceCreator;
  @HiveField(5)
  final String sourceLicense;

  BirdAudio({
    required this.audioURL,
    required this.audioType,
    required this.length, // int
    required this.source,
    required this.sourceCreator,
    required this.sourceLicense,
  });

  factory BirdAudio.fromMap(Map<dynamic, dynamic> map) => BirdAudio(
    audioURL: map['audioURL'] ?? '',
    audioType: map['audioType'] ?? '',
    length: map['length'] ?? 0, // int
    source: map['source'] ?? '',
    sourceCreator: map['sourceCreator'] ?? '',
    sourceLicense: map['sourceLicense'] ?? '',
  );
}