import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LikeRepository {
  final String baseUrl;

  LikeRepository({required this.baseUrl});

  /// Récupère tous les reactions
  Future<List<Map<String, dynamic>>> getAllLikes() async {
    final response = await http.get(Uri.parse('$baseUrl/reactions'));
    print("getreactions:${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> reactions = json.decode(response.body);
      return reactions.map((like) => like as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load reactions');
    }
  }

  /// Ajoute un nouveau like
  Future<Map<String, dynamic>> addLike(Map<String, dynamic> likeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(likeData),
    );
    print("response.statusCode :${response.statusCode}");

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create like');
    }
  }

  /// Récupère un like spécifique par ID
  Future<Map<String, dynamic>> getLikeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/reactions/count/$id'));

    if (response.statusCode == 200) {
      print("reponselikeby:${response.body}");
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Like not found');
    } else {
      throw Exception('Failed to fetch like');
    }
  }

  /// Ajoute un nouveau like
  Future<Map<String, dynamic>> likeItem(int userId, int itemId) async {
    final likeData = {'user_id': userId, 'item_id': itemId};

    final response = await http.post(
      Uri.parse('$baseUrl/reactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(likeData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to like item');
    }
  }

  /// Annule un like
  Future<void> unlikeItem(int userId, int itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/reactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'item_id': itemId}),
    );

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Like not found to unlike');
    } else {
      throw Exception('Failed to unlike item');
    }
  }

  /// Supprime un like par ID
  Future<void> deleteLike(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reactions/$id'));

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Like not found');
    } else {
      throw Exception('Failed to delete like');
    }
  }

  /// Récupère le nombre de reactions pour un item donné
  Future<int> getLikeCount(int itemId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/reactions/count/$itemId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['like_count'];
    } else {
      throw Exception('Failed to fetch like count');
    }
  }

  // Méthode pour vérifier si un like existe déjà
  Future<bool> checkLikeExists(int userId, int projectId,
      {int? commentId}) async {
    try {
      // Construction de l'URL de l'API avec les paramètres userId et projectId
      String url = '$baseUrl/reactions/check/$userId/$projectId';

      // Ajouter le comment_id dans l'URL si il est présent
      if (commentId != null) {
        url += '?comment_id=$commentId';
      }

      // Affichage pour le debug
      print('URL construite: $url');

      final response = await http.get(Uri.parse(url));

      print("Réponse de la checklist: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Si la réponse est OK, analyser la réponse
        final data = jsonDecode(response.body);

        // Retourner true si le like existe, false sinon
        return data['like_exists'] ??
            false; // Supposons que le backend renvoie { "like_exists": true/false }
      } else {
        // Gérer une erreur de serveur ou une autre réponse inattendue
        debugPrint(
            'Erreur lors de la vérification du like: ${response.statusCode}');
        throw Exception(
            'Erreur lors de la vérification du like, code ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions
      debugPrint('Erreur lors de la vérification du like: $e');
      throw Exception('Erreur lors de la vérification du like');
    }
  }
}
