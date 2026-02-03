class modBird {
  final int birdID;
  final String birdName;
  final List<String> gitAudio;
  final String gitImageURL;
  final List<String> hindiName;
  final List<String> marathiName;
  final String folkStory;
  final String order;
  final String family;
  final String genus;
  final String species;
  final String region;
  final String habitat;
  final String urbanOccurance;
  final String conservationStatus;
  final String notableQuality;
  final String personalObservation;

  modBird({
    required this.birdID,
    required this.birdName,
    required this.gitAudio,
    required this.gitImageURL,
    required this.hindiName,
    required this.marathiName,
    required this.folkStory,
    required this.order,
    required this.family,
    required this.genus,
    required this.species,
    required this.region,
    required this.habitat,
    required this.urbanOccurance,
    required this.conservationStatus,
    required this.notableQuality,
    required this.personalObservation
  });

  // Map Firestore data to our Bird object
  factory modBird.fromFirestore(Map<String, dynamic> data) {
    return modBird(
      birdID: data['birdID'] ?? 0,
      birdName: data['birdName'] ?? '',
      gitAudio: List<String>.from(data['gitAudio'] ?? []),
      gitImageURL: data['gitImageURL'] ?? '',
      hindiName: List<String>.from(data['hindiName'] ?? []),
      marathiName: List<String>.from(data['marathiName'] ?? []),
      folkStory: data['folkStory'] ?? '',
      order: data['order'] ?? '',
      family: data['family'] ?? '',
      genus: data['genus'] ?? '',
      species: data['species'] ?? '',
      region: data['region'] ?? '',
      habitat: data['habitat'] ?? '',
      urbanOccurance: data['urbanOccurance'] ?? '',
      conservationStatus: data['conservationStatus'] ?? '',
      notableQuality: data['notableQuality'] ?? '',
      personalObservation: data['personalObservation'] ?? '',
    );
  }
}