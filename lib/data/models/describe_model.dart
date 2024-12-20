class Describe {
  final String id; // Unique identifier for the post
  final String userId; // ID of the user who created the post
  final String mediaUrl; // URL of the media (image/video)
  final String description; // Description of the post
  final DateTime timestamp; // Time when the post was created
  final int reactions; // Number of reactions on the post
  final int comments; // Number of comments on the post

  Describe({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.description,
    required this.timestamp,
    this.reactions = 0,
    this.comments = 0,
  });

  // Method to convert a Describe object to a map (for storage or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mediaUrl': mediaUrl,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'reactions': reactions,
      'comments': comments,
    };
  }

  // Method to create a Describe object from a map (for loading from storage or API)
  factory Describe.fromMap(Map<String, dynamic> map) {
    return Describe(
      id: map['id'],
      userId: map['userId'],
      mediaUrl: map['mediaUrl'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
      reactions: map['reactions'] ?? 0,
      comments: map['comments'] ?? 0,
    );
  }
}
