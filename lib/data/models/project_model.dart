import 'package:citizeneye/data/models/comment_model.dart';

class ProjectModel {
  final int id; // Ajouté pour représenter l'ID du projet
  final String title;
  final String description;
  final String imageUrl;
  final String goal; // Objectif du projet
  final String beneficiaryZone; // Zone bénéficiaire
  final DateTime startDate; // Date de début
  final DateTime endDate; // Date de fin
  final double budget; // Budget du projet
  final String projectManager; // Gestionnaire du projet
  final String owner; // Propriétaire du projet
  final String contractor; // Entrepreneur du projet
  final String status; // Statut du projet
  final List<dynamic>
      funds; // Liste des fonds (vous pouvez créer un modèle si nécessaire)
  final List<dynamic> comments; // Liste des commentaires
  final List<dynamic> likes; // Liste des commentaires

  ProjectModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.goal,
      required this.beneficiaryZone,
      required this.startDate,
      required this.endDate,
      required this.budget,
      required this.projectManager,
      required this.owner,
      required this.contractor,
      required this.status,
      this.funds = const [],
      this.comments = const [],
      this.likes = const []});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'], // Assurez-vous de récupérer l'ID
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
      goal: json['objective'], // Correspond au champ JSON
      beneficiaryZone: json['zone'], // Correspond au champ JSON
      startDate: DateTime.parse(json['start_date']), // Date de début
      endDate: DateTime.parse(json['end_date']), // Date de fin
      budget: double.tryParse(json['budget']) ?? 0.0, // Conversion du budget
      projectManager: json['owner'], // Gestionnaire du projet
      owner: json['owner'], // Propriétaire du projet
      contractor: json['contractor'], // Entrepreneur
      status: json['status'], // Statut
      funds: json['funds'], // Liste des fonds
      comments: json['comments'], // Liste des commentaires
      likes: json['likes'], // Liste des commentaires
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'objective': goal,
      'zone': beneficiaryZone,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'budget': budget.toString(), // Convertir en chaîne pour l'API
      'owner': owner,
      'contractor': contractor,
      'status': status,
      'funds': funds,
      'comments': comments,
      'likes': likes
    };
  }

  // Méthode pour obtenir le total des fonds
  double getTotalFunds() {
    // Implémentez la logique de calcul ici si nécessaire
    return 0.0; // Placeholder, implémentez selon vos besoins
  }
}
