import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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

  String? _id;

  @override
  void initState() {
    super.initState();
    initId();
    widget.controller.addListener(_checkIfCommentIsEmpty);
  }

  initId() async {
    final id = await UserLocalStorage.getId();
    if (id != null) {
      setState(() {
        _id = id;
      });
    }
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
      onTap: () {
        if (_id == null) {
          Get.snackbar(
            'Info',
            'Connectez-vous pour réagir à ce post',
          );
          Get.to(() => const AuthScreen());
          return;
        } else {
          FocusScope.of(context).unfocus();
        }
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
                readOnly: _id == null ? true : false,
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
                maxLines: 1,
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
