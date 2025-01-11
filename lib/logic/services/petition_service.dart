import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/petition_model.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMyPetitions(String id) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/petitions/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserLocalStorage.getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> petitionList = data['petitions'];
      final petitions =
          petitionList.map((json) => PetitionModel.fromJson(json)).toList();

      return {
        'status': true,
        'message': data['message'],
        'petitions': petitions,
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

Future<Map<String, dynamic>> getPetitions() async {
  try {
    final response = await http.get(Uri.parse("$baseUrl/petitions"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> petitionList = data['petitions'];
      final petitions =
          petitionList.map((json) => PetitionModel.fromJson(json)).toList();

      return {
        'status': true,
        'message': data['message'],
        'petitions': petitions,
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

Future<Map<String, dynamic>> signPetition({required int id}) async {
  final url = Uri.parse('$petitionsUrl/$id/sign');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserLocalStorage.getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': true,
        'message': data['message'],
        'signature': data['signature'],
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

Future<Map<String, dynamic>> sendPetition({
  required int id,
  required String title,
  required String description,
  File? media,
}) async {
  try {
    var request =
        http.MultipartRequest('POST', Uri.parse('$projectsUrl/$id/petition'))
          ..headers['Authorization'] =
              'Bearer ${await UserLocalStorage.getToken()}'
          ..fields['title'] = title
          ..fields['description'] = description;

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
        'petition': data['petition'],
      };
    } else {
      final data = json.decode(responseBody);
      return {
        'status': false,
        'message':
            data['message'] ?? 'Erreur lors du lancement de la pétition.',
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

Future<Map<String, dynamic>> updatePetition({
  required int id,
  required String title,
  required String description,
  File? media,
}) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('$petitionsUrl/$id'))
      ..headers['Authorization'] = 'Bearer ${await UserLocalStorage.getToken()}'
      ..fields['title'] = title
      ..fields['description'] = description;

    if (media != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'media',
        media.path,
      ));
    }

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      return {
        'status': true,
        'message': data['message'],
        'petition': data['petition'],
      };
    } else {
      final data = json.decode(responseBody);
      return {
        'status': false,
        'message':
            data['message'] ?? 'Erreur lors du lancement de la pétition.',
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

Future<Map<String, dynamic>> deletePetition({required int id}) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/petitions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserLocalStorage.getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': true,
        'message': data['message'],
        'petition': data['petition'],
      };
    } else {
      final data = json.decode(response.body);
      return {
        'status': false,
        'message':
            data['message'] ?? 'Erreur lors du lancement de la pétition.',
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
