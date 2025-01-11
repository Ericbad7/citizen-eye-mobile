import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3';
}

Future<List<String>> convertFilesToBytes(List<File> files) async {
  List<String> bytesList = [];
  for (var file in files) {
    List<int> bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    bytesList.add(base64Image);
  }
  return bytesList;
}

Future<List<String>?> saveImagesLocally(List<File> images) async {
  List<String> imagePaths = [];

  try {
    for (int i = 0; i < images.length; i++) {
      final imageFile = images[i];
      final directory = await getApplicationDocumentsDirectory();
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = '${directory.path}/$fileName';
      await imageFile.copy(filePath);
      imagePaths.add(filePath);
    }
    return imagePaths;
  } catch (e) {
    debugPrint('Erreur lors de la sauvegarde des images : $e');
    return [];
  }
}

Future<File> getImageFromCamera(ImagePicker picker) async {
  late File realImage;
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    // CroppedFile? croppedFile = await cropImage(image);
    // if (croppedFile != null) {
    //   realImage = File(croppedFile.path);
    // }

    realImage = File(image.path);
  }
  return realImage;
}

Future<File> getImageFromGallery(ImagePicker picker) async {
  late File realImage;
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    // CroppedFile? croppedFile = await cropImage(image);
    // if (croppedFile != null) {
    //   realImage = File(croppedFile.path);
    // }
    realImage = File(image.path);
  }
  return realImage;
}

Future<CroppedFile?> cropImage(XFile pickedFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: pickedFile.path,
    compressFormat: ImageCompressFormat.png,
    compressQuality: 100,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'CitizenEye',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio4x3,
        lockAspectRatio: false,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x4,
        ],
      ),
      IOSUiSettings(
        title: 'CitizenEye',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x4,
        ],
      ),
    ],
  );
  return croppedFile;
}
