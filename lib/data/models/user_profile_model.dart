class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String profileImageUrl;
  final String coverImageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.profileImageUrl,
    required this.coverImageUrl,
  });

  // Méthode fromJson pour créer une instance de UserProfile à partir d'un objet JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print('Parsing UserProfile from JSON: $json');

    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '', // Default to empty string if null
      bio: json['bio'] ?? '',
      profileImageUrl: json['profile_picture'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
    );
  }

  // Méthode toJson pour convertir l'objet UserProfile en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
    };
  }
}
