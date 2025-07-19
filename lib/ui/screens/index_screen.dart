import 'dart:ui';
import 'package:citizeneye/ui/screens/home_screen.dart';
import 'package:citizeneye/ui/screens/post_screen.dart';
import 'package:citizeneye/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _selectedIndex = 0;
  late LiquidController _liquidController;
  late PageController _pageController;

  final List<Widget> _pages = const [
    HomeScreen(),
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _liquidController = LiquidController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: _pages,
        ),
        bottomNavigationBar: _FancyBottomBar(
          items: [
            _FancyBottomBarItem(
              icon: FontAwesomeIcons.house,
              activeIcon: FontAwesomeIcons.houseChimney,
              title: 'Accueil',
            ),
            _FancyBottomBarItem(
              icon: FontAwesomeIcons.solidNewspaper,
              activeIcon: FontAwesomeIcons.newspaper,
              title: 'Actualités',
            ),
            _FancyBottomBarItem(
              icon: FontAwesomeIcons.user,
              activeIcon: FontAwesomeIcons.solidUser,
              title: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedColor: Theme.of(context).colorScheme.primary,
          unselectedColor: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
          backgroundColor: isDarkMode
              ? Colors.grey[900]!.withOpacity(0.8)
              : Colors.white.withOpacity(0.8),
        ));
  }
}

class _FancyBottomBar extends StatelessWidget {
  final List<_FancyBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;

  const _FancyBottomBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 20,
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _FancyBottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;

  const _FancyBottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
  });
}
