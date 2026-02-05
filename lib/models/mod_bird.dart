class PankhMaster {
  static const int id = 0;
  static const int birdName = 1;
  static const int gitAudioURL1 = 2;
  static const int gitAudioURL2 = 3;
  static const int gitAudioURL3 = 4;
  static const int gitImageURL = 5;
  static const int gitImageSilhouetteURL = 6;
  static const int gitImagePartURL = 7;
  static const int hindiNames = 8;
  static const int marathiNames = 9;
  static const int folkStory = 10;
  static const int order = 11;
  static const int family = 12;
  static const int genus = 13;
  static const int species = 14;
  static const int region = 15;
  static const int habitat = 16;
  static const int urbanOccurrence = 17;
  static const int conservationStatus = 18;
  static const int notableQuality = 19;
  static const int personalObservation = 20;
}

class ModBird {
  final int birdID;
  final String birdName;
  final List<String> gitAudioURLs;
  final String gitImageURL;
  final String gitImageSilhouetteURL;
  final String gitImagePartURL;
  final List<String> hindiNames;
  final List<String> marathiNames;
  final String folkStory;
  final String order;
  final String family;
  final String genus;
  final String species;
  final String region;
  final String habitat;
  final String urbanOccurrence;
  final String conservationStatus;
  final String notableQuality;
  final String personalObservation;

  ModBird({
    required this.birdID,
    required this.birdName,
    required this.gitAudioURLs,
    required this.gitImageURL,
    required this.gitImageSilhouetteURL,
    required this.gitImagePartURL,
    required this.hindiNames,
    required this.marathiNames,
    required this.folkStory,
    required this.order,
    required this.family,
    required this.genus,
    required this.species,
    required this.region,
    required this.habitat,
    required this.urbanOccurrence,
    required this.conservationStatus,
    required this.notableQuality,
    required this.personalObservation,
  });

  // Helper to split comma-separated strings safely
  static List<String> _splitNames(dynamic value) {
    if (value == null || value.toString().isEmpty) return [];
    return value.toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // 1. Convert CSV Row (List) to Bird Object
  factory ModBird.fromCsv(List<dynamic> row) {
    // Collect non-empty audio URLs using your PankhMaster constants
    List<String> audios = [];
    if (row[PankhMaster.gitAudioURL1]?.toString().isNotEmpty ?? false) audios.add(row[PankhMaster.gitAudioURL1].toString());
    if (row[PankhMaster.gitAudioURL2]?.toString().isNotEmpty ?? false) audios.add(row[PankhMaster.gitAudioURL2].toString());
    if (row[PankhMaster.gitAudioURL3]?.toString().isNotEmpty ?? false) audios.add(row[PankhMaster.gitAudioURL3].toString());

    return ModBird(
      birdID: int.tryParse(row[PankhMaster.id].toString()) ?? 0,
      birdName: row[PankhMaster.birdName]?.toString() ?? '',
      gitAudioURLs: audios,
      gitImageURL: row[PankhMaster.gitImageURL]?.toString() ?? '',
      gitImageSilhouetteURL: row[PankhMaster.gitImageSilhouetteURL]?.toString() ?? '',
      gitImagePartURL: row[PankhMaster.gitImagePartURL]?.toString() ?? '',
      hindiNames: _splitNames(row[PankhMaster.hindiNames]),
      marathiNames: _splitNames(row[PankhMaster.marathiNames]),
      folkStory: row[PankhMaster.folkStory]?.toString() ?? '',
      order: row[PankhMaster.order]?.toString() ?? '',
      family: row[PankhMaster.family]?.toString() ?? '',
      genus: row[PankhMaster.genus]?.toString() ?? '',
      species: row[PankhMaster.species]?.toString() ?? '',
      region: row[PankhMaster.region]?.toString() ?? '',
      habitat: row[PankhMaster.habitat]?.toString() ?? '',
      urbanOccurrence: row[PankhMaster.urbanOccurrence]?.toString() ?? '',
      conservationStatus: row[PankhMaster.conservationStatus]?.toString() ?? '',
      notableQuality: row[PankhMaster.notableQuality]?.toString() ?? '',
      personalObservation: row[PankhMaster.personalObservation]?.toString() ?? '',
    );
  }

  // 2. Convert Bird Object to Map (for Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'birdID': birdID,
      'birdName': birdName,
      'gitAudioURLs': gitAudioURLs,
      'gitImageURL': gitImageURL,
      'gitImageSilhouetteURL': gitImageSilhouetteURL,
      'gitImagePartURL': gitImagePartURL,
      'hindiNames': hindiNames,
      'marathiNames': marathiNames,
      'folkStory': folkStory,
      'order': order,
      'family': family,
      'genus': genus,
      'species': species,
      'region': region,
      'habitat': habitat,
      'urbanOccurrence': urbanOccurrence,
      'conservationStatus': conservationStatus,
      'notableQuality': notableQuality,
      'personalObservation': personalObservation,
    };
  }

  // 3. Create Bird Object from Map (when reading from Hive)
  factory ModBird.fromMap(Map<dynamic, dynamic> map) {
    return ModBird(
      birdID: map['birdID'] ?? 0,
      birdName: map['birdName'] ?? '',
      gitAudioURLs: List<String>.from(map['gitAudioURLs'] ?? []),
      gitImageURL: map['gitImageURL'] ?? '',
      gitImageSilhouetteURL: map['gitImageSilhouetteURL'] ?? '',
      gitImagePartURL: map['gitImagePartURL'] ?? '',
      hindiNames: List<String>.from(map['hindiNames'] ?? []),
      marathiNames: List<String>.from(map['marathiNames'] ?? []),
      folkStory: map['folkStory'] ?? '',
      order: map['order'] ?? '',
      family: map['family'] ?? '',
      genus: map['genus'] ?? '',
      species: map['species'] ?? '',
      region: map['region'] ?? '',
      habitat: map['habitat'] ?? '',
      urbanOccurrence: map['urbanOccurrence'] ?? '',
      conservationStatus: map['conservationStatus'] ?? '',
      notableQuality: map['notableQuality'] ?? '',
      personalObservation: map['personalObservation'] ?? '',
    );
  }
}