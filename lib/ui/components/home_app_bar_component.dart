import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchPressed;
  final Icon? icon;
  const HomeAppBar({
    super.key,
    required this.onSearchPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[800],
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Citizen Eye',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: IconButton(
              icon: icon ?? const Icon(FontAwesomeIcons.magnifyingGlass,
                  color: Colors.black),
              onPressed: onSearchPressed,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
