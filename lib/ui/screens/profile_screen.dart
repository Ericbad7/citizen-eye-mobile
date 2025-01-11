import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/user_profile_model.dart';
import 'package:citizeneye/logic/controllers/profile_view_controller.dart';
import 'package:citizeneye/ui/components/profil_header_component.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/widgets/button_widget.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewController profileViewController;

  @override
  void initState() {
    super.initState();
    profileViewController = Get.put(
      ProfileViewController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileViewController.isLoading.value) {
        return const Center(child: LoadingScreen());
      }

      if (profileViewController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profileViewController.errorMessage.value,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: profileViewController.fetchProfile,
                child: const Text('Rafraichir'),
              ),
            ],
          ),
        );
      }

      if (profileViewController.profile == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vous n'avez pas encore lancé de pétitions.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ButtonWidget(
                paddingVertical: 10,
                label: 'Consulter d\'autres',
                onPressed: profileViewController.fetchProfile,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: profileViewController.fetchProfile,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[800],
            actions: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                ),
                onPressed: () {
                  _logout();
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(userProfile: profileViewController.profile.value),
                const SizedBox(height: 10),
                _buildStatsCards(),
                const SizedBox(height: 10),
                _buildInterestsSection(),
                const SizedBox(height: 10),
                _buildBioSection(profileViewController.profile.value),
                const SizedBox(height: 10),
                _buildMediaGrid(),
                const SizedBox(height: 10),
                _buildFavoriteQuotes(),
              ],
            ),
          ),
        ),
      );
    });
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
    await UserLocalStorage.clearAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Get.offAll(() => const AuthScreen());
  }
}
