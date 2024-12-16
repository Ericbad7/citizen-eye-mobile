import 'package:flutter/material.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(notification.user?.avatar ??
              ""), // URL de l'avatar de l'utilisateur
        ),
        title: Text(
          notification.type,
          style: TextStyle(
            fontWeight:
                notification.read == true ? FontWeight.normal : FontWeight.bold,
            color: notification.read == true ? Colors.black : Colors.blue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              notification.user?.name ?? "", // Nom de l'utilisateur
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          _formatTimestamp(notification.createdAt),
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          // Ajouter une logique pour marquer la notification comme lue ou afficher des détails
          // notificationViewModel.markAsRead(notification.id); (par exemple)
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
