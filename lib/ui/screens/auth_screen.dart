import 'package:citizeneye/data/datasources/user_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/ui/components/tabButton_component.dart';
import 'package:citizeneye/ui/screens/index_screen.dart';
import 'package:citizeneye/widgets/custom_appbar.dart';
import 'package:citizeneye/widgets/input_field.dart';
import 'package:citizeneye/widgets/button_widget.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserApi _userApi = UserApi();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Authentification'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CitizenEye',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Votre fenêtre sur la citoyenneté',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTabButton("Se connecter", _isLogin, () {
                        setState(() {
                          _isLogin = true;
                        });
                      }),
                      const SizedBox(width: 10),
                      buildTabButton("S'inscrire", !_isLogin, () {
                        setState(() {
                          _isLogin = false;
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogin)
                          InputField(
                            label: "Noms & Prénoms",
                            hintText: "Entrez votre nom et prénoms",
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            icon: FontAwesomeIcons.user,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer vos noms et prénoms";
                              }
                              return null;
                            },
                          ),
                        InputField(
                          label: "Email",
                          hintText: "Entrez votre email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          icon: FontAwesomeIcons.envelope,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer votre email";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Veuillez entrer un email valide";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          label: "Mot de passe",
                          hintText: "Entrez votre mot de passe",
                          controller: _passwordController,
                          isPassword: true,
                          icon: FontAwesomeIcons.lock,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Le mot de passe doit contenir au moins 6 caractères";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        if (!_isLogin)
                          InputField(
                            label: "Confirmer le mot de passe",
                            hintText: "Confirmez votre mot de passe",
                            controller: _confirmPasswordController,
                            isPassword: true,
                            icon: Icons.lock,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return "Les mots de passe ne correspondent pas";
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 20),
                        if (_isLoading) const LoadingScreen(),
                        if (!_isLoading)
                          ButtonWidget(
                            paddingHorizontal: 60,
                            label: _isLogin ? "Se connecter" : "S'inscrire",
                            onPressed: _submitAuthForm,
                          ),
                        const SizedBox(height: 20),
                        const Divider(),
                        ButtonWidget(
                          label: "Se connecter en tant qu'invité",
                          onPressed: _loginAsGuest,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitAuthForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isLogin) {
          final response = await _userApi.login(
            _emailController.text,
            _passwordController.text,
          );
          final token = response['token'];
          await UserLocalStorage.saveToken(token);
        } else {
          final response = await _userApi.register(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
            _confirmPasswordController.text,
          );
          final token = response['token'];
          await UserLocalStorage.saveToken(token);
        }

        // Stocker le token

        // Rediriger vers l'écran principal
        Get.off(() => IndexScreen());
      } catch (error) {
        print(error.toString());
        Get.snackbar("Erreur", error.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loginAsGuest() {
    print("Connexion en tant qu'invité");
    Get.off(() => IndexScreen());
  }
}
