import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onMediaPressed; // Callback for media button

  const HomeAppBar({
    Key? key,
    required this.onSearchPressed,
    required this.onMediaPressed, // Required for media button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[800],
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'CitizenEye',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black),
                  onPressed: onSearchPressed,
                ),
              ),
              const SizedBox(width: 16), // Spacing between buttons
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.upload,
                      color: Colors.black), // Icon for media upload
                  onPressed: onMediaPressed, // Handle media upload action
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
