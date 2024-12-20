import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/app_sizes.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: project.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du projet
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  project.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Titre du projet
              Center(
                child: Text(
                  project.title,
                  style: const TextStyle(
                      fontSize: AppSizes.textSizeExtraLarge,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // Objectif du projet
              _buildSectionTitle('Objectif'),
              Text(project.goal, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Zone bénéficiaire
              _buildSectionTitle('Zone Bénéficiaire'),
              Text(project.beneficiaryZone,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Calendrier
              _buildSectionTitle('Calendrier'),
              Text("${project.endDate}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Budget
              _buildSectionTitle('Budget'),
              Text("${project.budget}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Maître d'ouvrage
              _buildSectionTitle('Maître d\'ouvrage'),
              // GestureDetector(
              //   child: Text(
              //     project.projectManager,
              //     style: const TextStyle(
              //       fontSize: 16,
              //       color: Colors.blue,
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              //   onTap: () {
              //     _showProjectOwnerDetails(context, project.beneficiaryZone);
              //   },
              // ),
              const SizedBox(height: 16),
              // Description
              _buildSectionTitle('Description'),
              Text(project.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Boutons d'interaction
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('Like'),
                    onPressed: () {
                      // Fonctionnalité de like
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.comment),
                    label: const Text('Comment'),
                    onPressed: () {
                      // Fonctionnalité de commentaire
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    onPressed: () {
                      // Fonctionnalité de partage
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppSizes.textSizeLarge,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  void _showProjectOwnerDetails(BuildContext context, String ownerDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails du Maître d\'ouvrage'),
          content: Text(ownerDetails),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
