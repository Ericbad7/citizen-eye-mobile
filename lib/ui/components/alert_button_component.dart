import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertButton extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed; // Add the onPressed attribute

  const AlertButton({Key? key, required this.message, this.onPressed})
      : super(key: key);

  void _sendAlertEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'autorite@example.com',
      query: 'subject=Signalement Urgent&body=$message',
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'envoyer l\'e-mail')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => _sendAlertEmail(context),
      child: Container(
        width: 100, // Width of the container
        height: 100, // Height of the container
        decoration: BoxDecoration(
          color: Colors.red[100], // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            const BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8, // Shadow blur radius
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            const Icon(
              FontAwesomeIcons.triangleExclamation, // Representative icon
              color: Colors.red,
              size: 30, // Icon size
            ),
            const SizedBox(height: 8), // Space between icon and text
            Text(
              "Alerter",
              style: TextStyle(
                color: Colors.red[800], // Text color
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
