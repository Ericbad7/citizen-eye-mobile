import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/logic/services/project_service.dart';
import 'package:get/get.dart';

class ProjectViewController extends GetxController {
  var projects = <ProjectModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  ProjectViewController();

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await getProjects();
    if (response["status"]) {
      projects.value = response['projects'];
      isLoading.value = false;
    } else {
      errorMessage.value = response['message'];
      isLoading.value = false;
    }
  }
}
