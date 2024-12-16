import 'package:citizeneye/utils/constants/app_colors.dart';
import 'package:citizeneye/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double paddingVertical;
  final double paddingHorizontal;
  final Widget? icon; // Pour ajouter une icône optionnelle

  const ButtonWidget({super.key, 
    required this.label,
    required this.onPressed,
    this.color = AppColors.buttonColor,
    this.textColor = AppColors.buttonTextColor,
    this.fontSize = 16.0, // Taille par défaut du texte
    this.borderRadius =
        AppSizes.borderRadiusLarge, // Rayon par défaut des coins
    this.paddingVertical = 16.0, // Padding vertical
    this.paddingHorizontal = 20.0, // Padding horizontal
    this.icon, // Icône optionnelle
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!, // Afficher l'icône si elle est fournie
            const SizedBox(width: 8), // Espacement entre l'icône et le texte
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
