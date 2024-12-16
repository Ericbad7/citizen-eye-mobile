import 'package:citizeneye/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align elements to the left
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Cover Image
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(userProfile.profileImageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12), // Smoother rounded corners
                ),
              ),
            ),
            // Dark Overlay
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black
                        .withOpacity(0.5), // Dark overlay for text visibility
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            // Profile Image
            Positioned(
              top: 50, // Position the profile image within the cover image
              left: 16,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(userProfile.profileImageUrl),
                backgroundColor: Colors.grey[300], // Fallback color
                // Optional: Add a border to the profile image
                child: ClipOval(
                  child: Image.network(
                    userProfile.profileImageUrl,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Increased spacing for a cleaner look
        // User Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            userProfile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Facebook theme color
            ),
          ),
        ),
        const SizedBox(height: 4), // Adjusted spacing
        // User Bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            userProfile.bio,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16, // Increased font size for better readability
            ),
          ),
        ),
        const SizedBox(height: 16), // Increased spacing
        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Add edit profile action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800], // Facebook theme color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Increased padding
                  ),
                  child: const Text(
                    'Editer le Profil',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white), // Increased font size
                  ),
                ),
              ),
              const SizedBox(width: 8), // Space between buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Add send message action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Message button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Increased padding
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white), // Increased font size
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16), // Increased spacing
      ],
    );
  }
}
