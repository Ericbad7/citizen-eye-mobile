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

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _uploadMedia() {
    // Logic to handle media upload (e.g., open image/video picker)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchPressed: _toggleSearchBar,
        onMediaPressed: _uploadMedia,
      ),
      body: Column(
        children: [
          // Afficher la barre de recherche si _isSearchVisible est true
          if (_isSearchVisible)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBars(),
            ),
          const Expanded(
            child: Text(""),
          ),
        ],
      ),
    );
  }
}
