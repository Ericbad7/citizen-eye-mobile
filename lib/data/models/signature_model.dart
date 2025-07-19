import 'package:citizeneye/data/models/user_model.dart';

class SignatureModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;

  SignatureModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      id: json['id'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
