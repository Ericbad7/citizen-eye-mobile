import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/repositories/like_repository.dart';
import 'package:flutter/material.dart';

class LikeViewModel {
  static bool isLiked = false; // Static: shared among all instances
  static int likeCount = 0; // Static: shared among all instances
  static bool isLoading = false; // Static: shared among all instances
  static String errorMessage = ''; // Static: shared among all instances

  static final LikeRepository likeRepository = LikeRepository(baseUrl: baseUrl);

  // Static method to check if a like exists
  static Future<bool> checkExistingLike(int userId, int projectId,
      {int? commentId}) async {
    try {
      final existingLike = await likeRepository
          .checkLikeExists(userId, projectId, commentId: commentId);
      return existingLike;
    } catch (e) {
      debugPrint('Error checking like: $e');
      return false;
    }
  }

  // Static method to toggle like
  static Future<void> toggleLike(int userId, int projectId,
      {int? commentId, required String emojiType}) async {
    isLoading = true;
    try {
      // Check if like exists
      print('Action de like/unlike envoyée.');
      final existingLike = await checkExistingLike(userId, projectId,
          commentId: commentId); // Call static checkExistingLike
      print("existingLike: $existingLike");

      if (existingLike) {
        // If like exists, perform an unlike
        await likeRepository.unlikeItem(userId, commentId ?? 0);
        isLiked = false;
        print("isLiked: $isLiked");
        likeCount = (likeCount > 0) ? likeCount - 1 : 0;
      } else {
        // Otherwise, add a like
        print("----------");
        await likeRepository.addLike({
          'user_id': userId,
          'emoji_type': emojiType,
          'comment_id': commentId ?? 0, // Add commentId if necessary
          'project_id': projectId,
        });

        isLiked = true;
        likeCount++;
      }

      errorMessage = '';
    } catch (e) {
      // Error handling
      errorMessage = 'Like/unlike action failed';
      debugPrint(': $e');
    } finally {
      isLoading = false;
    }
  }
}
