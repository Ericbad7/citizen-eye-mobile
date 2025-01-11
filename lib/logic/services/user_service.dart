import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/user_profile_model.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMyProfile() async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserLocalStorage.getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final profile = UserProfile.fromJson(data['profile']);
      return {
        'status': true,
        'message': data['message'],
        'profile': profile,
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
