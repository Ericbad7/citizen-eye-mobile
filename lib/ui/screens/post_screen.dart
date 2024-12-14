import 'package:citizeneye/ui/components/petition_button_component.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizeneye/ui/components/alert_button_component.dart';
import 'package:citizeneye/ui/components/post_button_component.dart';
import 'package:citizeneye/ui/components/post_card_component.dart';
import 'package:citizeneye/ui/components/post_field_component.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();
  File? _mediaFile;

  // Initialize ImagePicker
  final ImagePicker _picker = ImagePicker();

  void _handleMediaSelected(File media) {
    setState(() {
      _mediaFile = media;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Media selected: ${media.path.split('/').last}')),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _handleMediaSelected(File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _handlePost() {
    final comment = _commentController.text;
    if (comment.isNotEmpty || _mediaFile != null) {
      print("Post Submitted with comment: $comment and media: $_mediaFile");
      _commentController.clear();
      setState(() {
        _mediaFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          'CitizenEye',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Enable general scrolling
        padding: const EdgeInsets.all(16.0), // Padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PostInputField(controller: _commentController),
            // Space between input and buttons
            if (_mediaFile != null)
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _mediaFile!,
                        height: 150,
                        width: double.infinity, // Full width
                        fit: BoxFit.cover, // Cover the space
                      ),
                    ),
                  ),
                ],
              ),
            PostButton(onPressed: _handlePost),
            const SizedBox(height: 16.0), // Space before alert and post buttons
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space between buttons
              children: [
                Expanded(
                  child: AlertButton(message: _commentController.text),
                ),
                const SizedBox(width: 16.0), // Space between the buttons
                Expanded(
                  child:
                      PetitionButton(petitionMessage: _commentController.text),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Additional space before posts

            // Replace ListView with a Column
            Column(
              children: List.generate(10, (index) {
                return PostCard(
                  username: 'User $index',
                  profileImage: const AssetImage(
                      'assets/images/logo.png'), // Replace with actual image
                  postImage: const AssetImage(
                      'assets/images/school.png'), // Replace with actual image
                  caption: 'This is a sample caption for post $index',
                  timeAgo: '${index + 1}h',
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
