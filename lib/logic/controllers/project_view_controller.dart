import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/logic/services/project_service.dart';
import 'package:get/get.dart';

class ProjectViewController extends GetxController {
  var projects = <ProjectModel>[].obs;
  var filteredProjects = <ProjectModel>[].obs; // New observable list for filtered projects
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Filter states
  var bigBudget = false.obs;
  var deadline75Percent = false.obs;
  var reactionFilter = 'none'.obs; // 'none', 'most', 'least'
  var hasIncident = false.obs;

  ProjectViewController();

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
    // Initialize filteredProjects with all projects after fetching
    ever(projects, (_) => filterProjects(''));
  }

  void updateFilters({
    bool? bigBudget,
    bool? deadline75Percent,
    String? reactionFilter,
    bool? hasIncident,
  }) {
    if (bigBudget != null) this.bigBudget.value = bigBudget;
    if (deadline75Percent != null) this.deadline75Percent.value = deadline75Percent;
    if (reactionFilter != null) this.reactionFilter.value = reactionFilter;
    if (hasIncident != null) this.hasIncident.value = hasIncident;
    fetchProjects(); // Fetch projects with updated filters
  }

  Future<void> fetchProjects({Map<String, dynamic>? filters}) async {
    isLoading.value = true;
    errorMessage.value = '';

    // Use provided filters or current internal filter states
    final Map<String, dynamic> currentFilters = filters ?? {
      'big_budget': bigBudget.value,
      'deadline_75_percent': deadline75Percent.value,
      'reaction_filter': reactionFilter.value,
      'has_incident': hasIncident.value,
    };

    final response = await getProjects(filters: currentFilters);
    if (response["status"]) {
      projects.value = response['projects'];
      isLoading.value = false;
    } else {
      errorMessage.value = response['message'];
      isLoading.value = false;
    }
  }

  void filterProjects(String query) {
    if (query.isEmpty) {
      filteredProjects.value = projects.value;
    } else {
      filteredProjects.value = projects.value
          .where((project) =>
              project.title.toLowerCase().contains(query.toLowerCase()) ||
              project.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
