import 'package:citizeneye/data/models/alert_model.dart';
import 'package:citizeneye/logic/viewmodels/alert_viewmodel.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final AlertViewModel alertViewModel = Get.put(AlertViewModel(Get.find()));

  @override
  void initState() {
    super.initState();
    alertViewModel.fetchAlerts();
  }

  Future<void> _refreshAlerts() async => await alertViewModel.fetchAlerts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🚨 Alertes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    if (alertViewModel.isLoading.value) {
      return const Center(child: LoadingScreen());
    }

    if (alertViewModel.alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Aucune alerte disponible.',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAlerts,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: alertViewModel.alerts.length,
        itemBuilder: (context, index) =>
            _buildAlertCard(alertViewModel.alerts[index], index),
      ),
    );
  }

  Widget _buildAlertCard(AlertModel alert, int index) {
    return Dismissible(
      key: Key(alert.id.toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => _handleDismiss(direction, alert, index),
      background: _buildSwipeBackground(
          Colors.green, Icons.check, Alignment.centerLeft),
      secondaryBackground: _buildSwipeBackground(
          Colors.red, Icons.delete, Alignment.centerRight),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: const Icon(Icons.warning, color: Colors.blue, size: 28),
          ),
          title: Text(
            alert.reason ?? "Alerte",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: _buildAlertDetails(alert),
          trailing: IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.grey),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildAlertDetails(AlertModel alert) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTruncatedDetailText(
              "📄 Description: ${alert.description ?? 'N/A'}"),
          _buildDetailText("👤 Utilisateur: ${alert.userName ?? 'Inconnu'}"),
          _buildDetailText("📂 Projet: ${alert.projectName ?? 'Non spécifié'}"),
        ],
      ),
    );
  }

  Widget _buildTruncatedDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  Widget _buildSwipeBackground(
      Color color, IconData icon, Alignment alignment) {
    return Container(
      color: color,
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  void _handleDismiss(DismissDirection direction, AlertModel alert, int index) {
    if (direction == DismissDirection.endToStart) {
      alertViewModel.deleteAlert(alert.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Alerte supprimée', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent),
      );
    }
    setState(() => alertViewModel.alerts.removeAt(index));
  }
}
