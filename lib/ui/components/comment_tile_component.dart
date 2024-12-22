// widgets/comment_tile.dart
import 'package:citizeneye/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 8,
              backgroundImage: comment.user.avatar != null
                  ? NetworkImage(comment.user.avatar!)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
              backgroundColor: Colors.blueGrey[200],
            ),
            const SizedBox(width: 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${comment.user.name} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: comment.content,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.solidHeart,
                      color: true ? Colors.blue[800] : Colors.blueGrey,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    const Text(
                      '12',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      FontAwesomeIcons.heartCrack,
                      color: true ? Colors.blueGrey : Colors.blue[800],
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    const Text(
                      '12',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      FontAwesomeIcons.reply,
                      color: Colors.blueGrey,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
