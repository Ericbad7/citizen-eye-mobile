import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Text(
      'CitizenEye',
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}