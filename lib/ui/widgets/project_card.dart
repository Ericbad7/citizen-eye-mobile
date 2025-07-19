import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/models/reaction_model.dart';
import 'package:citizeneye/logic/services/project_service.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/comment_screen.dart';
import 'package:citizeneye/ui/screens/petition_view.dart';
import 'package:citizeneye/utils/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  String? _id;
  ProjectModel? _projectModel;

  @override
  void initState() {
    super.initState();
    initId();
    initProject();
  }

  initProject() => _projectModel = widget.project;

  initId() async {
    final id = await UserLocalStorage.getId();
    if (id != null) setState(() => _id = id);
  }

  void _react(String reactionType) async {
    if (_id == null) {
      Get.snackbar('Info', 'Connectez-vous pour réagir à ce post');
      Get.to(() => const AuthScreen());
      return;
    }

    final result = await reactToProject(
      id: _projectModel!.id,
      reactionType: reactionType,
    );

    if (result['status']) {
      setState(() {
        _projectModel!
            .updateOrAddReaction(ReactionModel.fromJson(result['reaction']));
      });
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible de réagir à ce post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CommentsScreen(project: _projectModel!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _projectModel!.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildImage(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _projectModel!.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildProjectInfo(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          _buildActionBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              _projectModel!.imageUrl != null &&
                      _projectModel!.imageUrl!.isNotEmpty
                  ? '$imagePath/${_projectModel!.imageUrl!}'
                  : 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _projectModel!.owner.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Publié ${formatDate(_projectModel!.createdAt)}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () => Get.to(PetitionView(project: _projectModel!)),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            image: NetworkImage(
              _projectModel!.imageUrl != null &&
                      _projectModel!.imageUrl!.isNotEmpty
                  ? '$imagePath/${_projectModel!.imageUrl!}'
                  : 'https://via.placeholder.com/400x250',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child:
            _projectModel!.imageUrl == null || _projectModel!.imageUrl!.isEmpty
                ? const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey))
                : null,
      ),
    );
  }

  Widget _buildProjectInfo() {
    final duration = _projectModel!.calculateProjectDuration();
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.attach_money,
          text: '${_projectModel!.budget}',
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          icon: Icons.timer,
          text: '${duration['daysRemaining']}j restants',
          color: _getTimeColor(_projectModel!.endDate),
        ),
        const Spacer(),
        Text(
          '${duration['percentagePassed'].toInt()}% complété',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
      {required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: FontAwesomeIcons.thumbsUp,
            label: 'J\'aime',
            isActive: _projectModel!.hasReaction(_id ?? '') &&
                _projectModel!.getReactionType(_id ?? '') == 'liked',
            count: _projectModel!.getLikeCount(),
            onTap: () => _react('liked'),
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.thumbsDown,
            label: 'Je n\'aime pas',
            isActive: _projectModel!.hasReaction(_id ?? '') &&
                _projectModel!.getReactionType(_id ?? '') == 'disliked',
            count: _projectModel!.getDislikeCount(),
            onTap: () => _react('disliked'),
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.comment,
            label: 'Commenter',
            count: _projectModel!.getCommentCount(),
            onTap: () => _openComments(context),
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.penToSquare,
            label: 'Pétition',
            count: _projectModel!.petitions.length,
            onTap: () => Get.to(PetitionView(project: _projectModel!)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Function() onTap,
    int count = 0,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 18, color: isActive ? Colors.blue : Colors.grey[600]),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (count > 0)
                Text(
                  count.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.blue : Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTimeColor(DateTime endDate) {
    final remainingDays = endDate.difference(DateTime.now()).inDays;
    if (remainingDays > 50) return Colors.green;
    if (remainingDays > 20) return Colors.orange;
    return Colors.red;
  }
}
