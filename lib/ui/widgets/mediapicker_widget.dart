import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MediaPicker extends StatefulWidget {
  final Function(File) onMediaSelected;

  const MediaPicker({Key? key, required this.onMediaSelected})
      : super(key: key);

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedMedia;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final pickedFile = await (isVideo
        ? _picker.pickVideo(source: source)
        : _picker.pickImage(source: source));
    if (pickedFile != null) {
      setState(() {
        _selectedMedia = File(pickedFile.path);
      });
      widget.onMediaSelected(_selectedMedia!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectedMedia != null ? Image.file(_selectedMedia!) : Container(),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => _pickMedia(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () => _pickMedia(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}
