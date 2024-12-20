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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchPressed: _toggleSearchBar,
      ),
      body: Column(
        children: [
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
