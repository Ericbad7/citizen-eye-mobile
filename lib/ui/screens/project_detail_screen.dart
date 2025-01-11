import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              _buildImage(height: 200),
              
              Center(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Objectif du projet
              _buildSectionTitle('Objectif'),
              Text(project.goal),
              const SizedBox(height: 8),
              _buildSectionTitle('Zone Bénéficiaire'),
              Text(project.beneficiaryZone),
              const SizedBox(height: 8),
              _buildSectionTitle('Calendrier'),
              Text(
                "Du ${DateFormat('dd MMMM yyyy', 'fr').format(project.startDate)} au ${DateFormat('dd MMMM yyyy', 'fr').format(project.endDate)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSectionTitle('Budget'),
              Text(
                "${project.budget}",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildSectionTitle('Maître d\'ouvrage'),
              GestureDetector(
                child: Text(
                  project.owner,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // _showProjectOwnerDetails(context, project.beneficiaryZone);
                },
              ),
              const SizedBox(height: 8),
              _buildSectionTitle('Description'),
              Text(
                project.description,
                style: const TextStyle(),
              ),
              const SizedBox(height: 8),
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

  Widget _buildImage({double height = 150}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image.network(
        '$imagePath/${project.imageUrl!}',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  // void _showProjectOwnerDetails(BuildContext context, String ownerDetails) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Détails du Maître d\'ouvrage'),
  //         content: Text(ownerDetails),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('Fermer'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
