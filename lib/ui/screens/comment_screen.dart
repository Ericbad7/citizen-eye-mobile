// lib/ui/screens/comments_screen.dart

import 'package:citizeneye/data/models/comment_model.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/models/user_model.dart';
import 'package:citizeneye/ui/components/comment_input_component.dart';
import 'package:citizeneye/ui/components/comment_tile_component.dart';
import 'package:citizeneye/ui/components/publication_info_component.dart';
import 'package:citizeneye/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentsScreen extends StatefulWidget {
  final ProjectModel project;

  const CommentsScreen({super.key, required this.project});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final List<Comment> _comments = []; // Liste des commentaires
  final TextEditingController _commentController = TextEditingController();

  void _addComment(String text) {
    setState(() {
      _comments.add(
        Comment(
          id: _comments.length + 1, // Id temporaire pour la démo
          content: text,
          userId: 1, // Id d'utilisateur temporaire
          projectId: widget.project.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          user: UserModel(
            id: 1,
            name: 'User',
            email: 'user@example.com',
            avatar: 'https://via.placeholder.com/100x100.png', // URL temporaire
          ),
        ),
      );
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Commentaires',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.share, color: Colors.white),
            onPressed: () {
              // Partager le projet
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PublicationInfo(project: widget.project),
            ListView.builder(
              shrinkWrap: true, // Empêche le débordement
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return CommentTile(
                  comment: comment,
                  onLikeToggle: () {
                    // Gérer le toggle like
                  },
                  onReply: () {
                    // Gérer la réponse
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: CommentInput(
          controller: _commentController,
          onSend: () => _addComment(_commentController.text),
          onPickImage: () {
            // Logique pour sélectionner une image
          },
          profileImageUrl:
              'https://via.placeholder.com/100x100.png', // URL temporaire pour la photo de profil
        ),
      ),
    );
  }
}
