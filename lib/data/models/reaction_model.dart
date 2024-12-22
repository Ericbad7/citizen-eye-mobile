class ReactionModel {
  final String emojiType;
  final String userId;
  final bool activated;

  ReactionModel({
    required this.emojiType,
    required this.userId,
    required this.activated,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      emojiType: json['emoji_type'] as String,
      userId: json['user_id'].toString(),
      activated: json['activated'] == 1
          ? true
          : json['activated'] == true
              ? true
              : false,
    );
  }
}
