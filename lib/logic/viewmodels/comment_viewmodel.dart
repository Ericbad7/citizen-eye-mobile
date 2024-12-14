import 'package:get/get.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/comment_repository.dart';

class CommentViewModel extends GetxController {
  final CommentRepository commentRepository;

  var comments = <Comment>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var commentCount =
      0.obs; // Variable observable pour le nombre de commentaires

  CommentViewModel({required this.commentRepository});

  // Charger les commentaires pour un projet spécifique
  Future<void> loadComments(int projectId) async {
    isLoading.value = true;
    try {
      comments.value =
          await commentRepository.fetchCommentsByProjectId(projectId);
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Failed to load comments';
    } finally {
      isLoading.value = false;
    }
  }

  // Charger le nombre de commentaires pour un projet spécifique
  Future<void> loadCommentCount(int projectId) async {
    try {
      commentCount.value = await commentRepository.fetchCommentCount(projectId);

      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Failed to load comment count';
    }
  }

  // Ajouter un nouveau commentaire à un projet
  Future<void> addComment(int projectId, String content,
      {String? imageUrl, String? videoUrl}) async {
    isLoading.value = true;
    try {
      final newComment = await commentRepository.addComment(
        projectId,
        content,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );
      comments.add(newComment);
      commentCount.value++; // Incrémenter le nombre de commentaires
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Failed to add comment';
    } finally {
      isLoading.value = false;
    }
  }

  // Supprimer un commentaire
  Future<void> deleteComment(int commentId) async {
    isLoading.value = true;
    try {
      await commentRepository.deleteComment(commentId);
      comments.removeWhere((comment) => comment.id == commentId);
      commentCount.value--; // Décrémenter le nombre de commentaires
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Failed to delete comment';
    } finally {
      isLoading.value = false;
    }
  }
}
