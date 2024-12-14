import 'dart:convert';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:http/http.dart' as http;

class ProjectRepository {
  final String baseUrl;

  ProjectRepository(this.baseUrl);

  Future<List<ProjectModel>> getProjects() async {
    print("$baseUrl/projects");

    final response = await http.get(Uri.parse("$baseUrl/projects"));
    print("getproject:${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> projectList = json.decode(response.body);
      return projectList.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> addProject(ProjectModel project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add project');
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
