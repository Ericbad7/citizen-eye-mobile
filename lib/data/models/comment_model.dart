// lib/data/models/comment_model.dart
import 'user_model.dart';

class Comment {
  final int id;
  final String content;
  final String? media;
  final String? mediaType;
  final int projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;

  Comment({
    required this.id,
    required this.content,
    this.media,
    this.mediaType,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      media: json['image'],
      mediaType: json['video'],
      projectId: int.parse(json['related_id'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
