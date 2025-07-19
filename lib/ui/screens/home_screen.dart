import 'package:citizeneye/logic/controllers/project_view_controller.dart';
import 'package:citizeneye/ui/components/home_app_bar_component.dart';
import 'package:citizeneye/ui/components/project_list_component.dart';
import 'package:citizeneye/ui/components/project_filter_modal.dart';
import 'package:citizeneye/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'news_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static const Color primaryColor = Color(0xFF1877F2);
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1D1F23);
  static const Color textSecondary = Color(0xFF65676B);
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final ProjectViewController projectViewController =
      Get.put(ProjectViewController());
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearchVisible = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    projectViewController.filterProjects(_searchController.text);
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        projectViewController.filterProjects('');
        _searchFocusNode.unfocus();
      }
    });
  }

  Future<void> _showFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const ProjectFilterModal(),
      ),
    );
    projectViewController.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.scaffoldBackground,
      body: NestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: innerBoxIsScrolled ? 4 : 0,
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: _isSearchVisible ? kToolbarHeight * 2 + 16 : kToolbarHeight + 16,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                centerTitle: false,
                title: HomeAppBar(), // Simplified HomeAppBar
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchVisible ? Icons.close : FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  onPressed: _toggleSearchBar,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  onPressed: _showFilterModal,
                ),
                const SizedBox(width: 8),
              ],
              bottom: _isSearchVisible
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: SearchBars(
                            key: ValueKey(_isSearchVisible),
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: (value) {
                              projectViewController.filterProjects(value);
                            },
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.newspaper, size: 20),
                      text: 'Actualités',
                    ),
                    Tab(
                      icon: Icon(Icons.assignment, size: 20),
                      text: 'Projets',
                    ),
                  ],
                  labelColor: HomeScreen.primaryColor,
                  unselectedLabelColor: HomeScreen.textSecondary,
                  indicatorColor: HomeScreen.primaryColor,
                  indicatorWeight: 3,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 24),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            const NewsFeedScreen(),
            RefreshIndicator(
              color: HomeScreen.primaryColor,
              onRefresh: () async {
                await projectViewController.fetchProjects();
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    sliver: ProjectList(viewModel: projectViewController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
