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
  bool _isSearchVisible = false;

  late final ProjectViewModel projectViewModel;

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    projectViewModel = Get.put(ProjectViewModel(
        projectRepository: ProjectRepository("$baseUrl/reactions")));
    projectViewModel.fetchProjects();
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
          Expanded(
            child: ProjectList(viewModel: projectViewModel),
          ),
        ],
      ),
    );
  }
}
