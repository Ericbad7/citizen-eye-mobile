import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  // Sauvegarde des informations de l'utilisateur
  static Future<void> saveUser(
      String userId, String userName, String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('user_name', userName);
    await prefs.setString('user_email', userEmail);
  }

  // Récupération des informations de l'utilisateur
  static Future<Map<String, String?>> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString('user_id'),
      'user_name': prefs.getString('user_name'),
      'user_email': prefs.getString('user_email'),
    };
  }

  // Sauvegarde du token
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Récupération du token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // Effacement de toutes les données
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Effacement des informations de l'utilisateur
  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }

  // Effacement du token
  static Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
