import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> reactToProject(
    {required int id, required String reactionType}) async {
  final url = Uri.parse('$projectsUrl/$id/reaction');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserLocalStorage.getToken()}',
      },
      body: jsonEncode({
        'emoji_type': reactionType,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': true,
        'message': data['message'],
        'reaction': data['reaction'],
      };
    } else if (response.statusCode == 400) {
      final data = json.decode(response.body);
      return {
        'status': false,
        'message': data['message'],
      };
    } else if (response.statusCode == 401) {
      final data = json.decode(response.body);
      return {
        'status': false,
        'message': 'Non autorisé : ${data['message']}',
      };
    } else {
      return {
        'status': false,
        'message': 'Erreur serveur : Code ${response.statusCode}',
      };
    }
  } on SocketException {
    return {
      'status': false,
      'message': 'Aucune connexion Internet',
    };
  } on HttpException {
    return {
      'status': false,
      'message': 'Erreur HTTP.',
    };
  } on FormatException {
    return {
      'status': false,
      'message': 'Format de réponse non valide.',
    };
  } on TimeoutException {
    return {
      'status': false,
      'message': 'Délai d\'attente de la requête dépassé.',
    };
  } catch (e) {
    return {
      'status': false,
      'message': 'Erreur inconnue: $e',
    };
  }
}

Future<Map<String, dynamic>> commentProject({
  required int id,
  required String content,
  File? media,
}) async {
  try {
    var request =
        http.MultipartRequest('POST', Uri.parse('$projectsUrl/$id/comment'))
          ..headers['Authorization'] =
              'Bearer ${await UserLocalStorage.getToken()}'
          ..fields['content'] = content;

    if (media != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'media',
        media.path,
      ));
    }

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final data = json.decode(responseBody);
      return {
        'status': true,
        'message': data['message'],
        'comment': data['comment'],
      };
    } else {
      final data = json.decode(responseBody);
      return {
        'status': false,
        'message': data['message'] ?? 'Erreur lors de l\'ajout du commentaire.',
      };
    }
  } on SocketException {
    return {
      'status': false,
      'message': 'Aucune connexion Internet. Veuillez réessayer.',
    };
  } on TimeoutException {
    return {
      'status': false,
      'message': 'Le délai d\'attente a été dépassé.',
    };
  } on FormatException {
    return {
      'status': false,
      'message': 'Format de réponse non valide.',
    };
  } catch (e) {
    return {
      'status': false,
      'message': 'Une erreur inattendue s\'est produite : $e',
    };
  }
}
