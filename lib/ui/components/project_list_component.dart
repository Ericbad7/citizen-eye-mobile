import 'package:citizeneye/logic/controllers/project_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:citizeneye/ui/widgets/project_card.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:get/get.dart';

class ProjectList extends StatelessWidget {
  final ProjectViewController viewModel;

  const ProjectList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: LoadingScreen()),
        );
      }

      if (viewModel.errorMessage.value.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(
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
          ),
        );
      }

      if (viewModel.filteredProjects.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Text(
              "Aucun projet disponible",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final project = viewModel.filteredProjects[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProjectCard(project: project),
            );
          },
          childCount: viewModel.filteredProjects.length,
        ),
      );
    });
  }
}
