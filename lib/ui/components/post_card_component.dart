import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final ImageProvider profileImage;
  final ImageProvider postImage;
  final String caption;
  final String timeAgo;

  const PostCard({
    required this.username,
    required this.profileImage,
    required this.postImage,
    required this.caption,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: profileImage),
            title:
                Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(timeAgo),
            trailing: Icon(Icons.more_horiz),
          ),
          Image(image: postImage),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(caption),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
