import 'package:citizeneye/logic/controllers/post_view_controller.dart';
import 'package:citizeneye/ui/components/petition_card_component.dart';
import 'package:citizeneye/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:citizeneye/widgets/loading_spinner.dart';
import 'package:get/get.dart';

class PostList extends StatelessWidget {
  final PostViewController viewModel;

  const PostList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading.value) {
        return const Center(child: LoadingScreen());
      }

      if (viewModel.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                viewModel.errorMessage.value,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onRefresh,
                child: const Text('Rafraichir'),
              ),
            ],
          ),
        );
      }

      if (viewModel.petitions.isEmpty) {
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
                onPressed: viewModel.fetchPetitions,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: viewModel.petitions.length,
          itemBuilder: (context, index) {
            final petition = viewModel.petitions.reversed.toList()[index];
            return PetitionCard(petition: petition);
          },
        ),
      );
    });
  }

  Future<void> _onRefresh() async {
    await viewModel.refresher();
  }
}
