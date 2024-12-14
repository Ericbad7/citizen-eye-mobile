import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  // Méthode pour obtenir la position actuelle de l'utilisateur
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Les services de localisation ne sont pas activés
      return Future.error('Les services de localisation sont désactivés.');
    }

    // Vérifie les permissions d'accès à la localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Les permissions de localisation sont refusées
        return Future.error('Permission de localisation refusée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Les permissions sont refusées de manière permanente
      return Future.error(
          'Les permissions de localisation sont refusées de manière permanente');
    }

    // Retourne la position actuelle de l'utilisateur
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Méthode pour convertir des coordonnées GPS (latitude et longitude) en adresse (géocodage inversé)
  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Impossible de récupérer l'adresse : $e";
    }
  }

  // Méthode pour calculer la distance entre deux points géographiques en kilomètres
  static double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
            startLatitude, startLongitude, endLatitude, endLongitude) /
        1000; // Conversion en kilomètres
  }

  // Méthode pour vérifier si les services de localisation sont activés
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Méthode pour demander l'autorisation de localisation si nécessaire
  static Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
}
