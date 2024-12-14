import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/repositories/project_repository.dart';
import 'package:get/get.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/repositories/project_repository.dart';
import 'package:get/get.dart';

class ProjectViewModel extends GetxController {
  var projects = <ProjectModel>[].obs; // Liste des projets
  var isLoading = true.obs; // Indicateur de chargement
  var errorMessage = ''.obs; // Message d'erreur

  final ProjectRepository projectRepository; // Dépendance pour le dépôt

  ProjectViewModel({required this.projectRepository});

  @override
  void onInit() {
    super.onInit();
    fetchProjects(); // Récupérer les projets lors de l'initialisation
  }

  // Méthode pour récupérer les projets
  Future<void> fetchProjects() async {
    try {
      isLoading.value = true; // Indiquer que le chargement commence
      errorMessage.value = ''; // Réinitialiser le message d'erreur
      projects.value =
          await projectRepository.getProjects(); // Récupérer les projets
    } catch (e) {
      errorMessage.value =
          'Une erreur est survenue lors de la récupération des projets.';
    } finally {
      isLoading.value = false; // Indiquer que le chargement est terminé
    }
  }

  // Méthode pour ajouter un nouveau projet
  Future<void> addProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Réinitialiser le message d'erreur
      await projectRepository.addProject(project); // Ajouter le projet
      await fetchProjects(); // Recharger les projets
    } catch (e) {
      errorMessage.value =
          'Impossible d\'ajouter le projet. Veuillez réessayer.';
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour supprimer un projet
  Future<void> deleteProject(int projectId) async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Réinitialiser le message d'erreur
      await projectRepository.deleteProject(projectId); // Supprimer le projet
      await fetchProjects(); // Recharger les projets
    } catch (e) {
      errorMessage.value =
          'Impossible de supprimer le projet. Veuillez réessayer.';
    } finally {
      isLoading.value = false;
    }
  }
}
