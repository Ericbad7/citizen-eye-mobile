class UserModel {
  final int id;
  final String name;
  final String email;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? 'No name provided', // Valeur par défaut si null
      email: json['email'] ?? 'No email provided', // Valeur par défaut si null
      avatar: json['avatar'] ?? '', // Valeur par défaut si null
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }
}
