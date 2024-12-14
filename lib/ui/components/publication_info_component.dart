// widgets/publication_info.dart
import 'package:citizeneye/data/models/project_model.dart';
import 'package:flutter/material.dart';

class PublicationInfo extends StatelessWidget {
  final ProjectModel project;

  const PublicationInfo({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(project.description,
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              project.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.blueAccent),
              const SizedBox(width: 5),
              Text('likes'),
            ],
          ),
        ],
      ),
    );
  }
}
