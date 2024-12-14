import 'package:citizeneye/logic/viewmodels/alert_viewmodel.dart';
import 'package:citizeneye/data/models/describe_model.dart';
import 'package:citizeneye/ui/screens/notification_screen.dart';
import 'package:citizeneye/ui/screens/home_screen.dart';
import 'package:citizeneye/ui/screens/post_screen.dart';
import 'package:citizeneye/ui/screens/profile_screen.dart';
import 'package:citizeneye/ui/screens/project_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    PostScreen(),
    ProjectScreen(),
    AlertScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house), // Icône Accueil
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.feather), // Icône Accueil
            label: 'Publication',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList), // Icône Projets
            label: 'Projets',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bell), // Icône Alertes
            label: 'Alertes',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user), // Icône Profil
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800], // Couleur de l'élément sélectionné
        unselectedItemColor:
            Colors.black87, // Couleur des éléments non sélectionnés
        onTap: _onItemTapped,
      ),
    );
  }
}
