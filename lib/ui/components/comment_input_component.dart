import 'dart:io';

import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:video_trimmer/video_trimmer.dart';
import 'package:file_picker/file_picker.dart';

class CommentInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String profileImageUrl;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.profileImageUrl,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  bool _isCommentEmpty = true;
  File? _selectedMedia;
  String? _id;
  // final Trimmer _trimmer = Trimmer();

  @override
  void initState() {
    super.initState();
    initId();
    widget.controller.addListener(_checkIfCommentIsEmpty);
  }

  Future<void> initId() async {
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

  Future<void> _pickMedia() async {
    final fichier = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      allowMultiple: false,
    );

    if (fichier != null) {
      final filePath = fichier.files.single.path;
      if (filePath == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrage',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Recadrage',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _selectedMedia = File(croppedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 70.0, maxHeight: _selectedMedia != null ? 400.0 : 70.0),
      color: Colors.white,
      child: Column(
        children: [
          if (_selectedMedia != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _selectedMedia!.path.endsWith('.mp4')
                  ? Text(
                      "Vidéo sélectionnée : ${_selectedMedia!.path.split('/').last}")
                  : Image.file(
                      _selectedMedia!,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          GestureDetector(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profileImageUrl),
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: _id == null,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: 'Écrivez un commentaire...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
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
                    onPressed: _pickMedia,
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: (!_isCommentEmpty || _selectedMedia != null)
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                    onPressed: (!_isCommentEmpty || _selectedMedia != null)
                        ? widget.onSend
                        : null,
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
