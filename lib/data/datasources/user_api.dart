import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:http/http.dart' as http;

class UserApi {
  // Inscription
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Vérifier que les données contiennent bien les informations attendues
        if (data case {'user': Map user, 'token': String token}) {
          // Sauvegarder les détails de l'utilisateur
          await UserLocalStorage.saveUser(
            user['id'].toString(), // ID de l'utilisateur
            user['name'], // Nom de l'utilisateur
            user['email'], // Email de l'utilisateur
          );
          await UserLocalStorage.saveToken(token);

          return {
            'status': true,
            'message': data['message'] ?? 'Inscription réussie',
          };
        } else {
          return {
            'status': false,
            'message': 'Réponse du serveur invalide: données manquantes.',
          };
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        if (data.containsKey('errors')) {
          // Concaténer tous les messages d'erreur de validation
          String errorMessages = "";
          data['errors'].forEach((key, value) {
            errorMessages += value.join("\n") + "\n";
          });
          return {
            'status': false,
            'message': errorMessages.trim(), // Supprimer le dernier saut de ligne
          };
        } else {
          return {
            'status': false,
            'message': data['message'] ?? 'Erreur inconnue',
          };
        }
      } else if (response.statusCode == 401) {
        final data = json.decode(response.body);
        return {
          'status': false,
          'message': data['message'] ?? 'Non autorisé',
        };
      } else {
        return {
          'status': false,
          'message':
              'Erreur serveur (${response.statusCode}): ${response.body}',
        };
      }
    } on SocketException catch (_) {
      return {
        'status': false,
        'message': 'Aucune connexion Internet',
      };
    } on HttpException catch (_) {
      return {
        'status': false,
        'message': 'Erreur HTTP.',
      };
    } on FormatException catch (_) {
      return {
        'status': false,
        'message': 'Format de réponse non valide.',
      };
    } on TimeoutException catch (_) {
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

  // Connexion
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Vérifier que les données contiennent bien les informations attendues
        if (data case {'user': Map user, 'token': String token}) {
          // Sauvegarder les détails de l'utilisateur
          await UserLocalStorage.saveUser(
            user['id'].toString(), // ID de l'utilisateur
            user['name'], // Nom de l'utilisateur
            user['email'], // Email de l'utilisateur
          );

          await UserLocalStorage.saveToken(token);

          return {
            'status': true,
            'message': data['message'] ?? 'Connexion réussie',
          };
        } else {
          return {
            'status': false,
            'message': 'Réponse du serveur invalide: données manquantes.',
          };
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'status': false,
          'message': data['message'] ?? 'Erreur inconnue',
        };
      } else if (response.statusCode == 401) {
        final data = json.decode(response.body);
        return {
          'status': false,
          'message': data['message'] ?? 'Non autorisé',
        };
      } else {
        return {
          'status': false,
          'message':
              'Erreur serveur (${response.statusCode}): ${response.body}',
        };
      }
    } on SocketException catch (_) {
      return {
        'status': false,
        'message': 'Aucune connexion Internet',
      };
    } on HttpException catch (_) {
      return {
        'status': false,
        'message': 'Erreur HTTP.',
      };
    } on FormatException catch (_) {
      return {
        'status': false,
        'message': 'Format de réponse non valide.',
      };
    } on TimeoutException catch (_) {
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
}
