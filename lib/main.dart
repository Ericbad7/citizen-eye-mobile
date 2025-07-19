import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/index_screen.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define Facebook-like MaterialColor
    MaterialColor facebookBlue = const MaterialColor(
      0xFF1877f2,
      <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF1877f2), // Primary Facebook Blue
        600: Color(0xFF1565C0),
        700: Color(0xFF0D47A1),
        800: Color(0xFF0A3B8C),
        900: Color(0xFF082F78),
      },
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitizenEye',
      theme: ThemeData(
        primarySwatch: facebookBlue,
        scaffoldBackgroundColor: Colors.white, // White background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // You can add more theme properties here to customize other widgets
        // For example, button themes, text themes, etc.
      ),
      home: const SafeArea(child: SplashScreen()),
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
      // Tente de récupérer le profil de l'utilisateur pour valider le token
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Token valide, redirige vers l'écran principal
        Get.off(() => const IndexScreen());
      } else {
        // Token invalide ou expiré, efface le token et redirige vers l'authentification
        await UserLocalStorage.clearToken();
        Get.off(() => const AuthScreen());
      }
    } else {
      // Pas de token, redirige vers l'écran d'authentification
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
