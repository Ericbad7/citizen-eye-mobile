import 'dart:convert';
import 'package:citizeneye/data/models/user_profile_model.dart';

import 'package:citizeneye/ui/components/profil_header_component.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/string_api.dart';
import '../../data/datasources/user_local_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> futureUserProfile;

  @override
  void initState() {
    super.initState();
    futureUserProfile =
        _fetchUserProfile(); // Appeler la méthode lors de l'initialisation
  }

  Future<UserProfile> _fetchUserProfile() async {
    final String? userId = await UserLocalStorage.getId();

    // Afficher la valeur de userId dans la console

    final response = await http.get(Uri.parse("$baseUrl/users/$userId"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket, // Icône de déconnexion
              color: Colors.white,
            ),
            onPressed: () {
              // Logique pour déconnexion
              _logout(); // Appelez votre méthode de déconnexion ici
            },
          )
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: futureUserProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            UserProfile userProfile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(userProfile: userProfile),
                  const SizedBox(height: 10),
                  _buildStatsCards(),
                  const SizedBox(height: 10),
                  _buildInterestsSection(),
                  const SizedBox(height: 10),
                  _buildBioSection(userProfile),
                  const SizedBox(height: 10),
                  _buildMediaGrid(),
                  const SizedBox(height: 10),
                  _buildFavoriteQuotes(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Widget for Stats Cards
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(FontAwesomeIcons.pen, 'Posts', '23'),
          _buildStatCard(FontAwesomeIcons.heart, 'Liked', '1.2K'),
          _buildStatCard(FontAwesomeIcons.thumbsUp, 'Likes', '180'),
        ],
      ),
    );
  }

  // Helper function to create a stat card with an icon
  Widget _buildStatCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FaIcon(icon, color: Colors.blue[800]), // Add icon here
            const SizedBox(height: 8), // Space between icon and title
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(color: Colors.blue[800], fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for User Interests
  Widget _buildInterestsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: [
              _buildInterestChip(FontAwesomeIcons.globe, 'Travel'),
              _buildInterestChip(FontAwesomeIcons.music, 'Music'),
              _buildInterestChip(FontAwesomeIcons.camera, 'Photography'),
              _buildInterestChip(FontAwesomeIcons.laptop, 'Technology'),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to create interest chips with icons
  Widget _buildInterestChip(IconData icon, String interest) {
    return Chip(
      label: Row(
        children: [
          FaIcon(icon, size: 16), // Icon for the chip
          const SizedBox(width: 4),
          Text(interest),
        ],
      ),
      backgroundColor: Colors.blue[100],
    );
  }

  // Widget for Bio and Contact Information
  Widget _buildBioSection(UserProfile userProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(userProfile.bio),
          const SizedBox(height: 10),
          const Text('Contact:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Email: ${userProfile.email}'),
          Text('Phone: ${userProfile.phone}'),
        ],
      ),
    );
  }

  // Widget for Media Grid
  Widget _buildMediaGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Media',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9, // Example media count
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with actual media URLs
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget for Favorite Quotes
  Widget _buildFavoriteQuotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favorite Quotes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            '"The best way to predict the future is to create it."',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 5),
          Text(
            '- Peter Drucker',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  void _logout() async {
    await UserLocalStorage.clearAll(); // Effacez toutes les données stockées
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('userId'); // Effacer l'ID utilisateur des SharedPreferences
    Get.offAll(() => const AuthScreen()); // Redirigez vers l'écran de connexion
  }
}
