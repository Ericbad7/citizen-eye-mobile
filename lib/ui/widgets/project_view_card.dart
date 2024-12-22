import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/ui/screens/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';

import 'package:citizeneye/ui/widgets/badge_widget.dart';

class ProjectViewCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectViewCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the project details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectImage(),
              const SizedBox(height: 10),
              _buildProjectTitle(),
              const SizedBox(height: 5),
              _buildProjectTheme(),
              const SizedBox(height: 8),
              _buildProjectDescription(),
              const SizedBox(height: 10),
              _buildProjectDetails(),
              const SizedBox(height: 15),
              _buildProgressIndicator(),
              const SizedBox(height: 10),
              _buildInteractionButtons(context),
              const SizedBox(height: 15),
              _buildBadges(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        project.imageUrl!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProjectTitle() {
    return Text(
      project.title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProjectTheme() {
    return Text(
      'Thème: ',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 14,
      ),
    );
  }

  Widget _buildProjectDescription() {
    return Text(
      project.description,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objectif: ${project.goal}',
          style: TextStyle(color: Colors.grey[800]),
        ),
        Text(
          'Zone bénéficiaire: ${project.beneficiaryZone}',
          style: TextStyle(color: Colors.grey[800]),
        ),
        // Text(
        //   'Responsable: ${project.projectManager}',
        //   style: TextStyle(color: Colors.grey[800]),
        // ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: 56 / 100,
      color: _getTimeColor(100),
      backgroundColor: Colors.grey[300],
      minHeight: 8,
    );
  }

  Widget _buildInteractionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            LikeButton(
              size: 30,
              likeCount: 100,
              countBuilder: (int? count, bool isLiked, String text) {
                final color = isLiked ? Colors.pink : Colors.blue;
                return Text(
                  count == 0 ? "Love" : text,
                  style: TextStyle(color: color),
                );
              },
            ),
            _buildIconButton(
              icon: FontAwesomeIcons.comment,
              color: Colors.blueAccent,
              onPressed: () {
                // Get.to(() => CommentsScreen(project: project));
              },
            ),
            _buildIconButton(
              icon: FontAwesomeIcons.shareFromSquare,
              color: Colors.blueAccent,
              onPressed: () {
                _shareProject(context);
              },
            ),
            _buildIconButton(
              icon: FontAwesomeIcons.coins,
              color: Colors.blueAccent,
              onPressed: () {
                _showFundingDetails(context);
              },
            ),
          ],
        ),
        _buildIconButton(
          icon: FontAwesomeIcons.triangleExclamation,
          color: Colors.redAccent,
          onPressed: () {
            // Fonctionnalité de signalement (à implémenter)
          },
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return const Align(
      alignment: Alignment.bottomLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (true)
            BadgeWidget(
              text: 'Gros Budget',
              color: Colors.green,
            ),
          if (56 < 25)
            BadgeWidget(
              text: 'Délai Critique',
              color: Colors.red,
            ),
          if (100 > 50)
            BadgeWidget(
              text: '${100} Réactions',
              color: Colors.blue,
            ),
          if (true)
            BadgeWidget(
              text: 'Incident Signifié',
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  void _shareProject(BuildContext context) {
    // Implémentation de la fonctionnalité de partage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité de partage à venir!')),
    );
  }

  void _showFundingDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Pour voir le fond arrondi
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height *
                0.6, // Ajustez la hauteur selon vos besoins
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de fermeture
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Détails des fonds',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Utilisation de GridView pour afficher les détails
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio:
                        1, // Ajuster le ratio pour la taille des cartes
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildFundingCard(
                        icon: FontAwesomeIcons.donate,
                        title: 'Dons reçus',
                        amount: 20,
                        color: Colors.blueAccent,
                      ),
                      _buildFundingCard(
                        icon: FontAwesomeIcons.solidCreditCard,
                        title: 'Prêts reçus',
                        amount: 30,
                        color: Colors.orangeAccent,
                      ),
                      _buildFundingCard(
                        icon: FontAwesomeIcons.handHoldingHeart,
                        title: 'Soutiens reçus',
                        amount: 34,
                        color: Colors.purpleAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget helper pour construire les cartes de financement
  Widget _buildFundingCard({
    required IconData icon,
    required String title,
    required double amount,
    required Color color,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 140, // Limiter la hauteur maximale
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTimeColor(int remainingTime) {
    if (remainingTime > 50) {
      return Colors.green;
    } else if (remainingTime > 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
      splashRadius: 20,
    );
  }
}
