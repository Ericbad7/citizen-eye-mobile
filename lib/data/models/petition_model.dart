import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/models/signature_model.dart';
import 'package:citizeneye/data/models/user_model.dart';

class PetitionModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final UserModel owner;
  final ProjectModel? project;
  final DateTime createdAt;
  final List<SignatureModel> signatures;

  PetitionModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.owner,
    this.project,
    required this.createdAt,
    this.signatures = const [],
  });

  void updateOrAddSignature(SignatureModel newSignature) {
    final index =
        signatures.indexWhere((signature) => signature.id == newSignature.id);

    if (index != -1) {
      signatures[index] = newSignature;
    } else {
      signatures.add(newSignature);
    }
  }

  bool hadSigned(String userId) {
    return signatures
        .any((signature) => signature.user.id == int.parse(userId));
  }

  bool isOwner(String userId) {
    return owner.id == int.parse(userId);
  }

  int getSignatureCount() {
    return signatures.length;
  }

  /// Conversion depuis un objet JSON
  factory PetitionModel.fromJson(Map<String, dynamic> json) {
    return PetitionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] != null && json['image']['path'] != null
          ? (json['image']['path'] as String)
          : null,
      owner: UserModel.fromJson(json['owner']),
      project: json['project'] != null
          ? ProjectModel.fromJson(json['project'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      signatures: (json['signatures'] as List<dynamic>? ?? [])
          .map((signature) => SignatureModel.fromJson(signature))
          .toList(),
    );
  }
}
