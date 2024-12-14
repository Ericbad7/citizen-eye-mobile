import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  final Function(bool isLiked) onLikeToggle;
  final Color likeColor; // Allow dynamic color for the like button

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.likeCount,
    required this.onLikeToggle,
    required this.likeColor, // Default color is red
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.likeCount;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      print("isLikedLikeButton:$isLiked");
    });
    widget.onLikeToggle(isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: isLiked
                ? widget.likeColor
                : Colors.grey, // Dynamic color for the like button
          ),
          onPressed: _toggleLike,
          splashRadius: 20,
        ),
        Text('$likeCount'),
      ],
    );
  }
}
