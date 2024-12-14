import 'package:flutter/material.dart';

class AppColors {
  // Get the integer value from Colors.blue[800]
  static const Color primaryColor = Color(0xFF1976D2); // Bleu principal
  static const Color secondaryColor = Color(0xFF29B6F6); // Bleu clair
  static const Color accentColor = Color(0xFFFFC107); // Jaune accentué
  static const Color errorColor = Color(0xFFE53935); // Rouge pour les erreurs
  static const Color successColor = Color(0xFF43A047); // Vert pour le succès
  static const Color backgroundColor =
      Color(0xFFF5F5F5); // Couleur de fond claire
  static const Color textColor = Color(0xFF212121); // Texte principal sombre

  // Couleurs de fond

  static const Color cardColor = Color(0xFFFFFFFF); // Blanc pour les cartes

  // Couleurs de texte
  static const Color textPrimaryColor =
      Color(0xFF333333); // Texte principal (Noir/gris foncé)
  static const Color textSecondaryColor =
      Color(0xFF666666); // Texte secondaire (gris)

  // Couleurs des boutons
  static const Color buttonColor = Color(0xFF2196F3); // Bleu pour les boutons

  static const Color buttonTextColor =
      Color(0xFFFFFFFF); // Couleur du texte des boutons (blanc)

  // Couleurs d'alerte
  // Rouge pour les erreurs
  static const Color warningColor =
      Color(0xFFFFC107); // Jaune pour les avertissements

  // Couleurs spécifiques aux états des projets
  static const Color onTrackColor =
      Color(0xFF28A745); // Vert pour les projets dans les temps
  static const Color delayedColor =
      Color(0xFFFFC107); // Jaune pour les projets retardés
  static const Color criticalColor =
      Color(0xFFDC3545); // Rouge pour les projets en situation critique

  // Couleurs des ombres
  static const Color shadowColor =
      Color(0x29000000); // Ombre légère pour les cartes et boutons
}
