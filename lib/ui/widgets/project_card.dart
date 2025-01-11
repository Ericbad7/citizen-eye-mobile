import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/models/reaction_model.dart';
import 'package:citizeneye/logic/services/project_service.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/comment_screen.dart';
import 'package:citizeneye/ui/screens/petition_view.dart';
import 'package:citizeneye/ui/widgets/badge_widget.dart';
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
  bool isProcessing = false;
  String? _id;
  ProjectModel? _projectModel;

  @override
  void initState() {
    super.initState();
    initId();
    initProject();
  }

  initProject() {
    _projectModel = widget.project;
  }

  initId() async {
    final id = await UserLocalStorage.getId();
    if (id != null) {
      setState(() {
        _id = id;
      });
    }
  }

  void _react(String reactionType) async {
    if (_id == null) {
      Get.snackbar(
        'Info',
        'Connectez-vous pour réagir à ce post',
      );
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

  void _openBottomSheet(BuildContext context, ProjectModel project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: CommentsScreen(project: project),
        );
      },
    );
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
            _buildHeader(),
            const SizedBox(height: 10),
            _buildImage(height: 250),
            const SizedBox(height: 10),
            Text(
              _projectModel!.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _projectModel!.description,
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

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '$imagePath/${_projectModel!.imageUrl!}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              _projectModel!.owner.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Publié ${formatDate(_projectModel!.createdAt)}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.solidBell,
            color: Colors.blueGrey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildImage({double height = 150}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        '$imagePath/${_projectModel!.imageUrl!}',
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
                color: (_projectModel!.hasReaction(_id ?? '') &&
                        _projectModel!.getReactionType(_id ?? '') == 'liked')
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: () {
                _react('liked');
              },
            ),
            Text('${_projectModel!.getLikeCount()}'),
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.heartCrack,
                color: (_projectModel!.hasReaction(_id ?? '') &&
                        _projectModel!.getReactionType(_id ?? '') == 'disliked')
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: () {
                _react('disliked');
              },
            ),
            Text('${_projectModel!.getDislikeCount()}'),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.solidCommentDots,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                _openBottomSheet(context, _projectModel!);
              },
            ),
            Text('${_projectModel!.getCommentCount()}'),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.newspaper,
                color: Colors.red,
              ),
              onPressed: () {
                Get.to(PetitionView(
                  project: _projectModel!,
                ));
              },
            ),
            Text('${_projectModel!.petitions.length}'),
          ],
        )
      ],
    );
  }

  Widget _buildBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: BadgeWidget(
        text: '${_projectModel!.budget}',
        color: Colors.blueGrey.shade300,
      ),
    );
  }

  Widget _buildCircularProgress({double size = 80}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                value: _projectModel!
                        .calculateProjectDuration()['percentagePassed'] /
                    100,
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _getTimeColor(_projectModel!.endDate)),
                backgroundColor: Colors.grey[300],
              ),
            ),
            Text(
              '${(_projectModel!.calculateProjectDuration()['percentagePassed']).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${_projectModel!.calculateProjectDuration()['daysRemaining']} j restants',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
