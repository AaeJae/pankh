class BirdModel {
  final String id;
  final String birdName;
  final String birdFamily;
  final List<String> birdImageUrls;
  final List<String> birdAudioUrls;


  BirdModel({
    required this.id,
    required this.birdName,
    required this.birdFamily,
    required this.birdImageUrls,
    required this.birdAudioUrls,
  });

  // Converts Firestore Document to BirdModel object
  factory BirdModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return BirdModel(
      id: documentId,
      birdName: data['birdName'] ?? 'Unknown Bird',
      // Safely convert dynamic lists from Firebase to String lists
      birdFamily: data['birdFamily'] ?? [],
      birdImageUrls: List<String>.from(data['birdImageUrls'] ?? []),
      birdAudioUrls: List<String>.from(data['birdAudioUrls'] ?? []),
    );
  }
}