import 'package:flutter/material.dart';

class ProjectTile extends StatelessWidget {
  final String title;
  final String description;
  final String deadline;
  final VoidCallback onDetailsPressed;

  const ProjectTile({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre du projet
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Description du projet
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Date limite du projet
            Text(
              "Date limite : $deadline",
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Bouton pour voir les détails
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onDetailsPressed,
                child: const Text(
                  "Voir les détails",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
