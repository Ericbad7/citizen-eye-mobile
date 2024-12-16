import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;

  const PostInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 16.0), // Increased vertical margin
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0), // Padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // White background for the field
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Subtle shadow
            blurRadius: 5.0,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Exprimez-vous...',
          hintStyle: TextStyle(color: Colors.grey[600]), // Grey hint text
          border: InputBorder.none, // No border
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ), // Padding inside the text field
          suffixIcon: IconButton(
            icon: Icon(Icons.photo_camera,
                color: Colors.blue[800]), // Camera icon
            onPressed: () {
              // Action when icon is pressed (e.g., open image picker)
            },
          ),
        ),
      ),
    );
  }
}
