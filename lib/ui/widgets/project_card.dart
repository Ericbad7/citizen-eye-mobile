import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/datasources/user_local_storage.dart';
import '../../data/models/project_model.dart';
import '../../logic/viewmodels/like_viewmodel.dart';
import '../screens/comment_screen.dart';
import '../widgets/badge_widget.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late bool isLiked;
  late int likeCount;
  bool isProcessing = false; // Empêche les doubles clics

  @override
  void initState() {
    super.initState();
    likeCount = widget.project.likes.length;
    isLiked = false;
    _loadLikeStatus();
  }

  void _loadLikeStatus() async {
    String? userId = await UserLocalStorage.getId();
    if (userId == null) {
      return;
    }

    try {
      bool existingLike = await LikeViewModel.checkExistingLike(
        int.parse(userId),
        widget.project.id,
      );

      if (mounted) {
        setState(() {
          isLiked = existingLike;
        });
      }
    } catch (e) {
      debugPrint("Erreur lors du chargement du statut de like : $e");
    }
  }

  Future<void> _toggleLike() async {
    if (isProcessing) return;

    final userId = await UserLocalStorage.getId();
    if (userId == null) {
      debugPrint("Aucun utilisateur connecté. Action ignorée.");
      return;
    }

    final previousLikeState = isLiked;
    final previousLikeCount = likeCount;

    setState(() {
      isProcessing = true;
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    try {
      await LikeViewModel.toggleLike(
        int.parse(userId),
        widget.project.id,
        commentId: null,
        emojiType: "applause",
      );
    } catch (e) {
      debugPrint("Erreur lors du toggleLike : $e");
      setState(() {
        isLiked = previousLikeState;
        likeCount = previousLikeCount;
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(height: 140),
            const SizedBox(height: 10),
            Text(
              widget.project.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildBadges()),
                _buildCircularProgress(size: 70),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({double height = 150}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.project.imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: Colors.grey[300],
            child: const Center(child: Text('Image non disponible')),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidHeart,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: isProcessing ? null : _toggleLike,
            ),
            Text('$likeCount'),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(FontAwesomeIcons.comment, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CommentsScreen(project: widget.project),
                  ),
                );
              },
            ),
            Text('${widget.project.comments.length}'),
          ],
        ),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCircularProgress({double size = 80}) {
    final totalDuration =
        widget.project.endDate.difference(widget.project.startDate).inDays;
    final elapsedDuration =
        DateTime.now().difference(widget.project.startDate).inDays;
    final remainingDuration = totalDuration > 0
        ? (totalDuration - elapsedDuration).clamp(0, totalDuration)
        : 0;

    final progress = totalDuration > 0
        ? (elapsedDuration / totalDuration).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _getTimeColor(widget.project.endDate)),
                backgroundColor: Colors.grey[300],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$remainingDuration j restants',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.project.budget != null && widget.project.budget > 247289.20)
          const BadgeWidget(text: 'Gros Budget', color: Colors.green),
        if (_isCriticalDeadline())
          const BadgeWidget(text: 'Délai Critique', color: Colors.red),
      ],
    );
  }

  bool _isCriticalDeadline() {
    return widget.project.endDate
        .isBefore(DateTime.now().add(const Duration(days: 50)));
  }

  Color _getTimeColor(DateTime endDate) {
    final remainingDays = endDate.difference(DateTime.now()).inDays;
    if (remainingDays > 50) {
      return Colors.green;
    } else if (remainingDays > 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
