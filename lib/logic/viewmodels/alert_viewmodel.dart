import 'package:citizeneye/data/models/alert_model.dart';
import 'package:citizeneye/data/repositories/alert_repository.dart';
import 'package:get/get.dart';

class AlertViewModel {
  final AlertRepository _alertRepository;

  // Reactive list to hold alerts
  var alerts = <AlertModel>[].obs;
  var isLoading = false.obs; // Track loading state

  AlertViewModel(this._alertRepository);

  /// Fetch the alerts
  Future<void> fetchAlerts() async {
    try {
      isLoading.value = true; // Set loading to true before fetching
      final alertList = await _alertRepository.getAlerts();
      alerts.value = alertList; // Update the alerts list
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes: $e');
    } finally {
      isLoading.value = false; // Set loading to false after fetching
    }
  }

  /// Add a new alert
  Future<void> addAlert(AlertModel alert) async {
    try {
      await _alertRepository.addAlert(alert);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'alerte: $e');
    }
  }

  /// Delete an alert
  Future<void> deleteAlert(int alertId) async {
    try {
      await _alertRepository.deleteAlert(alertId);
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'alerte: $e');
    }
  }

  /// Fetch a specific alert by ID
  Future<AlertModel> fetchAlertById(int id) async {
    try {
      return await _alertRepository.getAlertById(id);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'alerte: $e');
    }
  }
}
