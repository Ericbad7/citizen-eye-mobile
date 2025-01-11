import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/models/petition_model.dart';
import 'package:citizeneye/logic/services/petition_service.dart';
import 'package:citizeneye/utils/helpers/camera_manager.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizeneye/ui/components/post_button_component.dart';
import 'package:citizeneye/ui/components/post_field_component.dart';
import 'dart:io';

class PostPetitionScreen extends StatefulWidget {
  final int id;
  final PetitionModel? petition;
  const PostPetitionScreen({super.key, required this.id, this.petition});

  @override
  State<PostPetitionScreen> createState() => _PostPetitionScreenState();
}

class _PostPetitionScreenState extends State<PostPetitionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    if (widget.petition != null) {
      _titleController.text = widget.petition!.title;
      _commentController.text = widget.petition!.description;
    }
  }

  void _submitPetition() async {
    if (_image != null) {
      setState(() {
        _isLoading = true;
      });

      final result = await sendPetition(
        id: widget.id,
        title: _titleController.text,
        description: _commentController.text,
        media: _image,
      );

      if (result['status']) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);

        Get.snackbar(
          '',
          result['message'],
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Erreur',
          result['message'] ?? 'Erreur lors du lancement de la pétition.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Erreur',
        'Choisissez une image pour illustrer votre idée.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _editPetition() async {
    setState(() {
      _isLoading = true;
    });
    final result = await updatePetition(
      id: widget.petition!.id,
      title: _titleController.text,
      description: _commentController.text,
      media: _image,
    );

    if (result['status']) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, result['petition']);

      Get.snackbar(
        '',
        result['message'],
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Erreur',
        result['message'] ?? 'Erreur lors du lancement de la pétition.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[800],
            title: const Text(
              'Lancez votre pétition',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostInputField(
                  controller: _titleController,
                  hintText: 'Titrez votre idée...',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return _bottomSheetContent();
                      },
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                if (_image != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.file(
                        _image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (widget.petition != null &&
                    widget.petition!.imageUrl != null &&
                    _image == null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        '$imagePath/${widget.petition!.imageUrl!}',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                DescriptionInputField(
                  controller: _commentController,
                  hintText: 'Exprimez vous...',
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PostButton(
              onPressed: _isLoading
                  ? () {}
                  : widget.petition == null
                      ? _submitPetition
                      : _editPetition,
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black26,
            child: const LoadingScreen(label: ''),
          ),
      ],
    );
  }

  Widget _bottomSheetContent() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      height: 200,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 226, 227, 237),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.camera,
              size: 40.0,
            ),
            title: const Text(
              'Caméra',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await getImageFromCamera(_picker);
              setState(() {
                _image = image;
              });
            },
          ),
          ListTile(
            selectedTileColor: Colors.grey,
            leading: const Icon(
              Icons.image,
              size: 40.0,
            ),
            title: const Text(
              'Galerie',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await getImageFromGallery(_picker);
              setState(() {
                _image = image;
              });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
