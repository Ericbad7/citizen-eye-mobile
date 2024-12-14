import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final Function onPressed;

  const PostButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Facebook-like primary color
        elevation: 4, // Add a subtle shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.publish, color: Colors.white), // Icon
          SizedBox(width: 8), // Space between icon and text
          Text(
            'Publier',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ],
      ),
    );
  }
}
