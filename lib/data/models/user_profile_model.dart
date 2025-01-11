class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String profileImageUrl;
  final String coverImageUrl;

  UserProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.bio = '',
    this.profileImageUrl = '',
    this.coverImageUrl = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profile_picture'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
    );
  }

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
