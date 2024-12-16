// widgets/comment_tile.dart
import 'package:citizeneye/data/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLikeToggle;
  final VoidCallback onReply;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onLikeToggle,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: comment.user.avatar != null
                ? NetworkImage(comment.user.avatar)
                : const AssetImage('assets/images/profile_placeholder.png')
                    as ImageProvider,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (comment.image !=
                      null) // Affiche l'image si elle est présente
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.network(
                        comment.image!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          true ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: true ? Colors.blue[800] : Colors.grey,
                        ),
                        onPressed: onLikeToggle,
                      ),
                      const SizedBox(width: 4),
                      const Text('${12}'),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: onReply,
                        child: Text(
                          'Répondre',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
