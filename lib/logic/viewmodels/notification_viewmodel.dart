import 'dart:convert';
import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NotificationViewModel extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadCount = 0.obs;

  // Récupérer toutes les notifications
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse("$baseUrl/notifications"));

      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        print("Parsed JSON Response: $jsonResponse");
        notifications.value = jsonResponse
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(int id) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/$id/mark-as-read'));
      if (response.statusCode == 200) {
        notifications.firstWhere((notification) => notification.id == id).read =
            true;
        notifications.refresh();
      } else {
        throw Exception('Failed to mark as read');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/mark-all-as-read'));
      if (response.statusCode == 200) {
        notifications.forEach((notification) => notification.read = true);
        notifications.refresh();
      } else {
        throw Exception('Failed to mark all as read');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Masquer une notification
  Future<void> hideNotification(int id) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/hide/$id'));
      if (response.statusCode == 200) {
        notifications.removeWhere((notification) => notification.id == id);
      } else {
        throw Exception('Failed to hide notification');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Récupérer les notifications non lues
  Future<void> fetchUnreadNotifications() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/unread'));
      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        notifications.value = jsonResponse
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to fetch unread notifications');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Compter les notifications non lues
  Future<void> countUnreadNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/unread/count'));
      if (response.statusCode == 200) {
        unreadCount.value = json.decode(response.body)['unread_count'];
      } else {
        throw Exception('Failed to fetch unread count');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
