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
      if (viewModel.isLoading.value) {
        return const Center(child: LoadingScreen());
      }

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
                onPressed: () => viewModel.fetchProjects(),
                child: const Text('Rafraichir'),
              ),
            ],
          ),
        );
      }

      if (viewModel.projects.isEmpty) {
        return const Center(
          child: Text(
            "Aucun projet en vue.",
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: viewModel.projects.length,
          itemBuilder: (context, index) {
            final project = viewModel.projects[index];
            return ProjectCard(project: project);
          },
        ),
      );
    });
  }

  Future<void> _onRefresh() async {
    await viewModel.fetchProjects();
  }
}
