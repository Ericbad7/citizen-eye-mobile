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
      id: json['id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      media: json['image'] as String?,
      mediaType: json['video'] as String?,
      projectId: int.tryParse(json['related_id']?.toString() ?? '') ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}), // Provide empty map if user is null
    );
  }
}
