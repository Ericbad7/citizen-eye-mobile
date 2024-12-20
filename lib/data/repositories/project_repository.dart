import 'dart:convert';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:http/http.dart' as http;

class ProjectRepository {
  final String baseUrl;

  ProjectRepository(this.baseUrl);

  Future<List<ProjectModel>> getProjects() async {

    final response = await http.get(Uri.parse("$baseUrl/projects"));
    if (response.statusCode == 200) {
      final List<dynamic> projectList = json.decode(response.body)['projects'];
      return projectList.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
    Future<void> deleteProject(int projectId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/projects/$projectId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete project');
    }
  }
}
