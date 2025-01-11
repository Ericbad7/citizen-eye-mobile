import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/index_screen.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
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
      Get.off(() => const IndexScreen());
    } else {
      // Sinon, redirigez vers l'écran d'authentification
      Get.off(() => const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingScreen()),
    );
  }
}
