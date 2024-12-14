import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/ui/components/homeAppBar_component.dart';
import 'package:citizeneye/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import '../components/project_view_component.dart';
import '../widgets/project_view_card.dart';

class ProjectScreen extends StatefulWidget {
  ProjectScreen({Key? key}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBars(),
            ),
          Expanded(
            child: Text(""),
          ),
        ],
      ),
    );
  }
}
