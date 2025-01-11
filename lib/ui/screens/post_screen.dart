import 'package:citizeneye/logic/controllers/post_view_controller.dart';
import 'package:citizeneye/ui/components/home_app_bar_component.dart';
import 'package:citizeneye/ui/components/post_list_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final PostViewController postViewController;

  @override
  void initState() {
    super.initState();
    postViewController = Get.put(
      PostViewController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        icon: const Icon(Icons.all_inbox_rounded),
        onSearchPressed: postViewController.fetchPetitions,
      ),
      body: Column(
        children: [
          Expanded(
            child: PostList(viewModel: postViewController),
          ),
        ],
      ),
    );
  }
}
