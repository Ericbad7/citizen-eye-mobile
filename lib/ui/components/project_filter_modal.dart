import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/controllers/project_view_controller.dart';

class ProjectFilterModal extends GetView<ProjectViewController> {
  const ProjectFilterModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec bouton fermer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrer les projets',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => Get.back(),
                color: Colors.blueGrey[400],
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),

          // Contenu des filtres
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() => _buildFilterCard(
                        icon: Icons.attach_money,
                        title: 'Gros budget',
                        subtitle: 'Projets avec budget élevé',
                        value: controller.bigBudget.value,
                        onChanged: (v) =>
                            controller.updateFilters(bigBudget: v),
                      )),
                  const SizedBox(height: 12),
                  Obx(() => _buildFilterCard(
                        icon: Icons.timer,
                        title: 'Délai restant > 75%',
                        subtitle: 'Projets avec beaucoup de temps restant',
                        value: controller.deadline75Percent.value,
                        onChanged: (v) =>
                            controller.updateFilters(deadline75Percent: v),
                      )),
                  const SizedBox(height: 12),
                  Obx(() => _buildDropdownCard(
                        icon: Icons.favorite,
                        title: 'Réactions',
                        value: controller.reactionFilter.value,
                        items: const [
                          DropdownMenuItem(
                              value: 'none', child: Text('Aucune préférence')),
                          DropdownMenuItem(
                              value: 'most', child: Text('Plus de réactions')),
                          DropdownMenuItem(
                              value: 'least',
                              child: Text('Moins de réactions')),
                        ],
                        onChanged: (v) =>
                            controller.updateFilters(reactionFilter: v!),
                      )),
                  const SizedBox(height: 12),
                  Obx(() => _buildFilterCard(
                        icon: Icons.warning,
                        title: 'Avec incidents',
                        subtitle: 'Projets ayant eu des incidents',
                        value: controller.hasIncident.value,
                        onChanged: (v) =>
                            controller.updateFilters(hasIncident: v),
                      )),
                ],
              ),
            ),
          ),

          // Bouton Appliquer
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Appliquer les filtres',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[600]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey[400],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue[600],
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard({
    required IconData icon,
    required String title,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[600]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items,
              underline: Container(),
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
