import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PetitionButton extends StatelessWidget {
  final String petitionMessage;
  final VoidCallback? onPressed; // Add the onPressed attribute

  const PetitionButton(
      {super.key, required this.petitionMessage, this.onPressed});

  void _publishPetition(BuildContext context) async {
    final Uri petitionUri = Uri(
      scheme: 'mailto',
      path: 'petition@example.com',
      query: 'subject=Publication de Pétition&body=$petitionMessage',
    );

    if (await canLaunch(petitionUri.toString())) {
      await launch(petitionUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de publier la pétition')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => _publishPetition(context),
      child: Container(
        width: 100, // Width of the container
        height: 100, // Height of the container
        decoration: BoxDecoration(
          color: Colors.blue[100], // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8, // Shadow blur radius
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            Icon(
              Icons.assignment, // Representative icon for petition
              color: Colors.blue,
              size: 30, // Icon size
            ),
            SizedBox(height: 8), // Space between icon and text
            Text(
              "Pétition",
              style: TextStyle(
                color: Colors.blue, // Text color
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
