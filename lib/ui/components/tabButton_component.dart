// Création d'un bouton onglet pour basculer entre connexion et inscription
import 'package:citizeneye/utils/constants/app_colors.dart';
import 'package:citizeneye/widgets/button_widget.dart';
import 'package:flutter/material.dart';

Widget buildTabButton(String title, bool isActive, VoidCallback onPressed) {
  return Expanded(
    child: ButtonWidget(
      label: title,
      onPressed: onPressed,
      color: isActive ? AppColors.primaryColor : Colors.blueGrey.shade200,
    ),
  );
}
