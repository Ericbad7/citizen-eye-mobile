import 'dart:convert';
import 'package:citizeneye/data/models/alert_model.dart';
import 'package:http/http.dart' as http;

class AlertRepository {
  final String baseUrl;

  // Constructeur prenant l'URL de base comme paramètre
  AlertRepository(this.baseUrl);

  /// **Récupère une liste d'alertes depuis l'API**
  Future<List<AlertModel>> getAlerts() async {
    final url = Uri.parse("$baseUrl/alerts"); // Endpoint pour les alertes
    print("Fetching alerts from: $url");

    final response = await http.get(url);
    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      final List<dynamic> alertList = json.decode(response.body);
      // Convertir chaque élément JSON en AlertModel
      return alertList.map((json) => AlertModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load alerts');
    }
  }

  /// **Récupère une alerte spécifique via son ID**
  Future<AlertModel> getAlertById(int alertId) async {
    final url = Uri.parse('$baseUrl/alerts/$alertId');
    print("Fetching alert from: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Convertir le JSON en objet AlertModel
      return AlertModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load alert');
    }
  }

  /// **Ajoute une nouvelle alerte via l'API**
  Future<void> addAlert(AlertModel alert) async {
    final url = Uri.parse('$baseUrl/alerts');
    print("Posting new alert to: $url");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(alert.toJson()), // Sérialisation en JSON
    );

    if (response.statusCode != 201) {
      print("Failed to add alert: ${response.body}");
      throw Exception('Failed to add alert');
    }
  }

  /// **Met à jour une alerte existante**
  Future<void> updateAlert(int alertId, AlertModel alert) async {
    final url = Uri.parse('$baseUrl/alerts/$alertId');
    print("Updating alert at: $url");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(alert.toJson()), // Sérialisation en JSON
    );

    if (response.statusCode != 200) {
      print("Failed to update alert: ${response.body}");
      throw Exception('Failed to update alert');
    }
  }

  /// **Supprime une alerte spécifique via son ID**
  Future<void> deleteAlert(int alertId) async {
    final url = Uri.parse('$baseUrl/alerts/$alertId');
    print("Deleting alert at: $url");

    final response = await http.delete(url);

    if (response.statusCode != 204) {
      print("Failed to delete alert: ${response.body}");
      throw Exception('Failed to delete alert');
    }
  }
}
