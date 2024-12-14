import 'package:flutter/material.dart';
import 'package:citizeneye/ui/widgets/project_card.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:get/get.dart';
import '../../logic/viewmodels/project_viewmodel.dart';

class ProjectList extends StatelessWidget {
  final ProjectViewModel viewModel;

  const ProjectList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If data is loading
      if (viewModel.isLoading.value) {
        return const Center(child: LoadingScreen());
      }

      // If there is an error message
      if (viewModel.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                viewModel.errorMessage.value,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    viewModel.fetchProjects(), // Retry fetching projects
                child: const Text('Réessayer'),
              ),
            ],
          ),
        );
      }

      // If no projects are available
      if (viewModel.projects.isEmpty) {
        return const Center(
          child: Text(
            "Aucun projet disponible.",
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      // If projects are available, display the list
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: viewModel.projects.length,
          itemBuilder: (context, index) {
            final project = viewModel.projects[index];
            return ProjectCard(project: project); // Display project card
          },
        ),
      );
    });
  }

  // Refresh projects when pulled down
  Future<void> _onRefresh() async {
    await viewModel.fetchProjects();
  }
}
