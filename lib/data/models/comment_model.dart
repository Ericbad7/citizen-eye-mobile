// lib/data/models/comment_model.dart
import 'user_model.dart';

class Comment {
  final int id;
  final String content;
  final String? image;
  final String? video;
  final int userId;
  final int projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user; // Ajouter une propriété User

  Comment({
    required this.id,
    required this.content,
    this.image,
    this.video,
    required this.userId,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.user, // Initialiser l'objet User
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      image: json['image'],
      video: json['video'],
      userId: json['user_id'],
      projectId: json['project_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(
          json['user']), // Créer un User à partir des données JSON
    );
  }
}
