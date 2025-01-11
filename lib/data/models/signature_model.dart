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
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
