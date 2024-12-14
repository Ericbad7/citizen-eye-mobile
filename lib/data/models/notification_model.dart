import 'package:citizeneye/data/models/user_model.dart';

class NotificationModel {
  final int id;
  final String type;
  final String message;
  bool read;
  final int userId;
  final bool hidden;
  final DateTime createdAt;
  final UserModel? user; // Changez ici pour utiliser la classe User

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.read,
    required this.userId,
    required this.hidden,
    required this.createdAt,
    this.user, // Mettez à jour ici
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'] ?? 'unknown',
      message: json['message'] ?? 'No message provided',
      read: json['read'] == 1,
      userId: json['user_id'],
      hidden: json['hidden'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null, // Ajoutez cette ligne
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'read': read ? 1 : 0,
      'user_id': userId,
      'hidden': hidden ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'user': user?.toJson(), // Ajoutez cette ligne pour inclure l'utilisateur
    };
  }
}
