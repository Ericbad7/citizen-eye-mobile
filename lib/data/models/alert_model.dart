class AlertModel {
  final int id;
  final String? reason; // Nullable, car `reason` peut être null
  final String description;
  final String userName;
  final String projectName;

  AlertModel({
    required this.id,
    this.reason, // Nullable, donc pas obligatoire
    required this.description,
    required this.userName,
    required this.projectName,
  });

  // Convertir un JSON en AlertModel
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      reason: json['reason'], // Peut être null
      description: json['description'] ?? '', // Valeur par défaut si null
      userName: json['user_name'],
      projectName: json['project_name'],
    );
  }

  // Convertir un AlertModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'description': description,
      'user_name': userName,
      'project_name': projectName,
    };
  }
}
