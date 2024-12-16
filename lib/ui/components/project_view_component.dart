import 'package:flutter/material.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  String? selectedBudgetFilter;
  String? selectedThemeFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtres
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filtre par taille de budget
              DropdownButton<String>(
                hint: const Text("Taille du budget"),
                value: selectedBudgetFilter,
                items: ["Gros budget", "Petit budget"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBudgetFilter = value;
                  });
                },
              ),
              // Filtre par thématique
              DropdownButton<String>(
                hint: const Text("Thématique"),
                value: selectedThemeFilter,
                items: ["Infrastructure", "Environnement", "Éducation"]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedThemeFilter = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Liste de projets filtrée
        const Expanded(child: Text("")),
      ],
    );
  }
}
