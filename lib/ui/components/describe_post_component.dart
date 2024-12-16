import 'package:citizeneye/data/models/describe_model.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Describe post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for video or image
          Container(
            height: 250, // Set height for video/image
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage(post.mediaUrl), // Replace with your media URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // Add interaction buttons here (like, comment)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Handle like action
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  // Handle comment action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
