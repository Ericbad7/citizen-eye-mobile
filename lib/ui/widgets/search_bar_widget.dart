import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBars extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode; // ✅ ajouté ici

  const SearchBars({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode, // ✅ et ici
  });

  @override
  State<SearchBars> createState() => _SearchBarsState();
}

class _SearchBarsState extends State<SearchBars> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon:
              const Icon(Icons.search_rounded, color: Colors.blueAccent),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon:
                      const Icon(Icons.clear_rounded, color: Colors.blueAccent),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                    setState(() {}); // Met à jour l'UI
                  },
                )
              : null,
          hintText: 'Rechercher un projet...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: theme.primaryColorDark,
        ),
        cursorColor: theme.primaryColor,
      ),
    );
  }
}
