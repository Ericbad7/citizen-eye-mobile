import 'package:citizeneye/data/datasources/string_api.dart'; // Assurez-vous que ce fichier existe et est correct
import 'package:citizeneye/data/repositories/project_repository.dart';
import 'package:citizeneye/logic/viewmodels/project_viewmodel.dart';
import 'package:citizeneye/ui/components/project_list_component.dart';
import 'package:citizeneye/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/home_app_bar_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchVisible = false; // Variable to manage search bar visibility

  late final ProjectViewModel
      projectViewModel; // Déclaration de ProjectViewModel

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible; // Toggle search bar visibility
    });
  }

  void _uploadMedia() {
    // Logic to handle media upload (e.g., open image/video picker)
  }

  @override
  void initState() {
    super.initState();
    // Initialiser le ProjectViewModel ici
    projectViewModel = Get.put(ProjectViewModel(
        projectRepository: ProjectRepository("$baseUrl/likes")));
    projectViewModel.fetchProjects(); // Démarre le chargement des projets
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchPressed: _toggleSearchBar,
        onMediaPressed: _uploadMedia, // Function to handle media upload
      ),
      body: Column(
        children: [
          // Show search bar if _isSearchVisible is true
          if (_isSearchVisible)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBars(),
            ),
          Expanded(
            child:
                ProjectList(viewModel: projectViewModel), // Passer le ViewModel
          ),
        ],
      ),
    );
  }
}
