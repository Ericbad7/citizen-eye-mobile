import 'package:citizeneye/data/models/comment_model.dart';
import 'package:citizeneye/data/models/petition_model.dart';
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
  final List<Comment> comments;
  final List<ReactionModel> reactions;
  final List<PetitionModel> petitions;
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

  void updateOrAddComment(Comment newComment) {
    final index = comments.indexWhere((comment) => comment.id == newComment.id);

    if (index != -1) {
      comments[index] = newComment;
    } else {
      comments.add(newComment);
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
      id: json['id'] as int? ?? 0, // Provide a default value if null
      title: json['title'] as String? ?? '', // Provide a default value if null
      description: json['description'] as String? ?? '', // Provide a default value if null
      imageUrl: json['image'] != null && json['image']['path'] != null
          ? (json['image']['path'] as String?)
          : null,
      goal: json['objective'] as String? ?? '', // Provide a default value if null
      beneficiaryZone: json['zone'] as String? ?? '', // Provide a default value if null
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(), // Handle null or invalid date
      endDate: DateTime.tryParse(json['end_date'] as String? ?? '') ?? DateTime.now(), // Handle null or invalid date
      budget: double.tryParse(json['budget']?.toString() ?? '') ?? 0.0, // Handle null or invalid budget
      owner: json['owner'] as String? ?? '', // Provide a default value if null
      contractor: json['contractor'] as String? ?? '', // Provide a default value if null
      status: json['status'] as String? ?? '', // Provide a default value if null
      funds: (json['funds'] as List<dynamic>?) ?? [], // Ensure funds is a list or empty
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment as Map<String, dynamic>))
          .toList() ?? [], // Handle null comments list and individual comments
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((reaction) => ReactionModel.fromJson(reaction as Map<String, dynamic>))
          .toList() ?? [], // Handle null reactions list and individual reactions
      petitions: (json['petitions'] as List<dynamic>?)
          ?.map((petition) => PetitionModel.fromJson(petition as Map<String, dynamic>))
          .toList() ?? [], // Handle null petitions list and individual petitions
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(), // Handle null or invalid date
    );
  }

  /// Méthode pour calculer le total des fonds
  double getTotalFunds() {
    return funds.fold<double>(
        0.0, (total, fund) => total + (fund['amount'] ?? 0.0));
  }
}
