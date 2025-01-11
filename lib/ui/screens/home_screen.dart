import 'package:citizeneye/logic/controllers/project_view_controller.dart';
import 'package:citizeneye/ui/components/home_app_bar_component.dart';
import 'package:citizeneye/ui/components/project_list_component.dart';
import 'package:citizeneye/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchVisible = false;

  late final ProjectViewController projectViewController;

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    projectViewController = Get.put(
      ProjectViewController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSearchPressed: _toggleSearchBar,
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBars(),
            ),
          Expanded(
            child: ProjectList(viewModel: projectViewController),
          ),
        ],
      ),
    );
  }
}
