import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/repositories/alert_repository.dart';
import 'package:citizeneye/data/repositories/comment_repository.dart';
import 'package:citizeneye/data/repositories/project_repository.dart';
import 'package:citizeneye/logic/viewmodels/alert_viewmodel.dart';
import 'package:citizeneye/logic/viewmodels/comment_viewmodel.dart';
import 'package:citizeneye/logic/viewmodels/project_viewmodel.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/index_screen.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';

void main() {
  runApp(const MyApp());
  // Créez une instance de votre ProjectRepository
  final projectRepository = ProjectRepository(baseUrl);
  final commentRepository = CommentRepository(baseUrl: baseUrl);

  // Enregistrez le ProjectViewModel avec le repository
  Get.put(ProjectViewModel(projectRepository: projectRepository));
  Get.put(CommentViewModel(commentRepository: commentRepository));
  Get.put(AlertRepository(baseUrl)); // Register AlertRepository
  Get.put(AlertViewModel(Get.find())); // Register AlertViewModel
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await UserLocalStorage.getToken();
    if (token != null) {
      // Si le token est présent, redirigez vers l'écran principal
      Get.off(() => IndexScreen());
    } else {
      // Sinon, redirigez vers l'écran d'authentification
      Get.off(() => AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingScreen()),
    );
  }
}
