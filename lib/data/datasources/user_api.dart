import 'dart:convert';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart'; // Importez UserLocalStorage
import 'package:http/http.dart' as http;

class UserApi {
  // Inscription
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation) async {
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
    print(response.statusCode);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Vérifier que les données contiennent bien les informations attendues
      final user = data['user'];
      final token = data['token'];

      // Sauvegarder les détails de l'utilisateur
      await UserLocalStorage.saveUser(
        user['id'], // ID de l'utilisateur
        user['name'], // Nom de l'utilisateur
        user['email'], // Email de l'utilisateur
      );
      await UserLocalStorage.saveToken(token);

      return data; // Retourne l'utilisateur et le token
    } else {
      throw Exception('Erreur d\'inscription: ${response.body}');
    }
  }

  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);

      // Vérifier que les données contiennent bien les informations attendues
      final user = data['user'];
      final token = data['token'];
      print(user['id']);
      // Sauvegarder les détails de l'utilisateur
      await UserLocalStorage.saveUser(
        user['id'].toString(), // ID de l'utilisateur
        user['name'], // Nom de l'utilisateur
        user['email'], // Email de l'utilisateur
      );

      await UserLocalStorage.saveToken(token);
      print("------------------------");
      return data; // Retourne l'utilisateur et le token
    } else {
      throw Exception('Erreur de connexion: ${response.body}');
    }
  }
}
