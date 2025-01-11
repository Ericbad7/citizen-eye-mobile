import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/ui/components/petition_card_component.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/post_petition.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PetitionView extends StatefulWidget {
  final ProjectModel project;
  const PetitionView({super.key, required this.project});

  @override
  State<PetitionView> createState() => _PetitionViewState();
}

class _PetitionViewState extends State<PetitionView> {
  String? _id;

  @override
  void initState() {
    super.initState();
    initId();
  }

  initId() async {
    final id = await UserLocalStorage.getId();
    if (id != null) {
      setState(() {
        _id = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[800],
        title: Text(
          widget.project.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.newspaper, color: Colors.white),
            onPressed: () {
              if (_id == null) {
                Get.snackbar(
                  'Info',
                  'Connectez-vous pour continuer',
                );
                Get.to(() => const AuthScreen());
                return;
              }
              Get.to(PostPetitionScreen(id: widget.project.id));
            },
          ),
        ],
      ),
      body: widget.project.petitions.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children:
                    List.generate(widget.project.petitions.length, (index) {
                  return PetitionCard(
                    petition: widget.project.petitions.reversed.toList()[index],
                  );
                }),
              ),
            )
          : const Center(child: Text('Aucune pétition contre ce projet.')),
    );
  }
}
