import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/data/repositories/project_repository.dart';
import 'package:get/get.dart';

class ProjectViewModel extends GetxController {
  var projects = <ProjectModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final ProjectRepository projectRepository;

  ProjectViewModel({required this.projectRepository});

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      projects.value = await projectRepository.getProjects();
    } catch (e) {
      errorMessage.value = 'Erreur de chargement.';
    } finally {
      isLoading.value = false;
    }
  }
}
