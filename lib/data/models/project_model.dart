import 'package:citizeneye/data/models/reaction_model.dart';

class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final String goal;
  final String beneficiaryZone;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String owner;
  final String contractor;
  final String status;
  final List<dynamic> funds;
  final List<dynamic> comments;
  final List<ReactionModel> reactions;
  final List<dynamic> petitions;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.goal,
    required this.beneficiaryZone,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.owner,
    required this.contractor,
    required this.status,
    this.funds = const [],
    this.comments = const [],
    this.reactions = const [],
    this.petitions = const [],
    required this.createdAt,
  });

  Map<String, dynamic> calculateProjectDuration() {
    final totalDuration = endDate.difference(startDate).inDays;

    final currentDate = DateTime.now();
    int daysPassed = 0;

    if (currentDate.isAfter(startDate)) {
      daysPassed = currentDate.difference(startDate).inDays;
    }
    if (daysPassed > totalDuration) {
      daysPassed = totalDuration;
    }

    final daysRemaining = totalDuration - daysPassed;

    final percentagePassed = (daysPassed / totalDuration) * 100;

    return {
      'percentagePassed': percentagePassed,
      'daysRemaining': daysRemaining,
    };
  }

  void updateOrAddReaction(ReactionModel newReaction) {
    final index = reactions
        .indexWhere((reaction) => reaction.userId == newReaction.userId);

    if (index != -1) {
      reactions[index] = newReaction;
    } else {
      reactions.add(newReaction);
    }
  }

  int getCommentCount() {
    return comments.length;
  }

  int getLikeCount() {
    return reactions
        .where((reaction) =>
            reaction.emojiType == 'liked' && reaction.activated == true)
        .length;
  }

  int getDislikeCount() {
    return reactions
        .where((reaction) =>
            reaction.emojiType == 'disliked' && reaction.activated == true)
        .length;
  }

  int getPetitionCount() {
    return petitions.length;
  }

  bool hasReaction(String userId) {
    return reactions.any(
        (reaction) => reaction.userId == userId && reaction.activated == true);
  }

  String? getReactionType(String userId) {
    final reaction = reactions.firstWhere(
      (reaction) => (reaction.userId == userId && reaction.activated == true),
      orElse: () => ReactionModel(
        emojiType: '',
        userId: '',
        activated: false,
      ),
    );
    return reaction.emojiType.isNotEmpty ? reaction.emojiType : null;
  }

  /// Conversion depuis un objet JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] != null && (json['image'] as List).isNotEmpty
          ? (json['image'][0]['path'] as String)
          : null,
      goal: json['objective'] as String,
      beneficiaryZone: json['zone'] as String,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      budget: double.tryParse(json['budget'].toString()) ?? 0.0,
      owner: json['owner'] as String,
      contractor: json['contractor'] as String,
      status: json['status'] as String,
      funds: json['funds'] ?? [],
      comments: json['comments'] ?? [],
      reactions: (json['reactions'] as List<dynamic>? ?? [])
          .map((reaction) => ReactionModel.fromJson(reaction))
          .toList(),
      petitions: json['petitions'] ?? [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Méthode pour calculer le total des fonds
  double getTotalFunds() {
    return funds.fold<double>(
        0.0, (total, fund) => total + (fund['amount'] ?? 0.0));
  }
}
