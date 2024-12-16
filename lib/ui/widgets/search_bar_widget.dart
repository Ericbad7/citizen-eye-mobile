import 'package:flutter/material.dart';

class SearchBars extends StatefulWidget {
  const SearchBars({super.key});

  @override
  State<SearchBars> createState() => _SearchBarsState();
}

class _SearchBarsState extends State<SearchBars> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;
  List<String> _selectedFilters = []; // List to store selected filters

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un projet par titre, zone, catégorie...',
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              suffixIcon: _isTyping
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.blue),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isTyping = false;
                          _selectedFilters.clear(); // Clear selected filters
                        });
                      },
                    )
                  : null,
            ),
            style: const TextStyle(color: Colors.black),
            onChanged: (text) {
              setState(() {
                _isTyping = text.isNotEmpty;
              });
            },
          ),
        ),
        // Filter options below the search bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterOption("Titre"),
              _buildFilterOption("Zone"),
              _buildFilterOption("Catégorie"),
              _buildFilterOption("Date"),
              _buildFilterOption("Popularité"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOption(String title) {
    bool isSelected =
        _selectedFilters.contains(title); // Check if filter is selected

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedFilters.remove(title); // Remove filter if already selected
          } else {
            _selectedFilters.add(title); // Add filter if not selected
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.3)
              : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.blue), // Text color
            ),
            // Show clear icon if the filter is selected
            if (isSelected)
              IconButton(
                icon: const Icon(Icons.clear,
                    color: Colors.blue, size: 16), // Clear icon
                onPressed: () {
                  setState(() {
                    _selectedFilters
                        .remove(title); // Remove the selected filter
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
