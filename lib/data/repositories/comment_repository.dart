// lib/data/repositories/comment_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';

class CommentRepository {
  final String baseUrl;

  CommentRepository({required this.baseUrl});

  Future<List<Comment>> fetchCommentsByProjectId(int projectId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/projects/$projectId/comments'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Méthode pour obtenir le nombre de commentaires d'un projet
  Future<int> fetchCommentCount(int projectId) async {
    print("$baseUrl/projects/$projectId/comments/count");
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/comments/count'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['count']);
      return data['count'];
    } else {
      throw Exception('Failed to fetch comment count');
    }
  }

  Future<Comment> addComment(int projectId, String content,
      {String? imageUrl, String? videoUrl}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/comments'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'content': content,
        'image': imageUrl,
        'video': videoUrl,
        'user_id': 11, // Assume user ID is set or fetched elsewhere
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/comments/$commentId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }
}
