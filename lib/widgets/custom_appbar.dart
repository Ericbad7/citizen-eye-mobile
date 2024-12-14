import 'package:citizeneye/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final bool showBackButton;

  CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = AppColors.primaryColor, // Option 1
    // backgroundColor = Colors.blue[800]!,  // Assert that the color is not null
    this.elevation = 4.0,
    this.actions,
    this.showBackButton = false, // Par défaut, on ne montre pas le bouton back
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          false, // Ne pas afficher le bouton "back" automatiquement
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Coins arrondis au bas de l'AppBar
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(); // Retour à l'écran précédent
              },
            )
          : null, // Si `showBackButton` est faux, pas de bouton
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
