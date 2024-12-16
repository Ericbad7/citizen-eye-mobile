import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final String profileImageUrl;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPickImage,
    required this.profileImageUrl,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  bool _isCommentEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkIfCommentIsEmpty);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkIfCommentIsEmpty);
    super.dispose();
  }

  void _checkIfCommentIsEmpty() {
    setState(() {
      _isCommentEmpty = widget.controller.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ajout d'un GestureDetector
      onTap: () {
        FocusScope.of(context).unfocus(); // Ferme le clavier si tap sur le vide
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImageUrl),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: 'Écrivez un commentaire...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                maxLines: 1, // Limite le nombre de lignes à 1
                // Vous pouvez ajouter une logique ici pour gérer le
                // défilement si l'utilisateur écrit beaucoup de texte
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.image,
                color: Colors.blueAccent,
              ),
              onPressed: widget.onPickImage,
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.paperPlane,
                color: _isCommentEmpty ? Colors.grey : Colors.blueAccent,
              ),
              onPressed: _isCommentEmpty ? null : widget.onSend,
            ),
          ],
        ),
      ),
    );
  }
}
