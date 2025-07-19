import 'package:citizeneye/ui/components/home_app_bar_component.dart';
import 'package:citizeneye/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        // Ajouter ici la logique pour annuler la recherche si nécessaire
      }
    });
  }

  void _showFilterModal() {
    // Implémentez votre logique de filtrage ici
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer les projets'),
        content: const Text('Options de filtrage seront implémentées ici'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: HomeAppBar(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearchVisible
                ? Padding(
                    key: const ValueKey('search-bar'),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SearchBars(
                      controller: _searchController,
                      onChanged: (value) {
                        // Ajouter la logique de recherche en temps réel
                      },
                    ),
                  )
                : const SizedBox(key: ValueKey('empty'), height: 8),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProjectCard(),
                      childCount:
                          10, // Remplacer par votre vrai nombre de projets
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar et info projet
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nom du Projet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Localisation • 2 jours restants',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Image du projet
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/400x300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            const Text(
              'Description du projet avec un texte plus long qui pourrait être tronqué si nécessaire...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.thumb_up, '120'),
                _buildActionButton(Icons.comment, '24'),
                _buildActionButton(Icons.share, 'Partager'),
                _buildActionButton(Icons.bookmark, 'Sauvegarder'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
      onPressed: () {},
    );
  }
}
