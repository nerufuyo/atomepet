import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/routes/app_routes.dart';

class ExploreCategoriesScreen extends StatefulWidget {
  const ExploreCategoriesScreen({super.key});

  @override
  State<ExploreCategoriesScreen> createState() => _ExploreCategoriesScreenState();
}

class _ExploreCategoriesScreenState extends State<ExploreCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'color': Colors.grey.shade100,
      'textColor': Colors.grey.shade800,
    },
    {
      'name': 'Dog',
      'color': const Color(0xFFFFF3E0),
      'textColor': Colors.orange.shade800,
    },
    {
      'name': 'Cat',
      'color': const Color(0xFFF3E5F5),
      'textColor': Colors.purple.shade800,
    },
    {
      'name': 'Small Animal',
      'color': const Color(0xFFE8F5E9),
      'textColor': Colors.green.shade800,
    },
    {
      'name': 'Bird',
      'color': const Color(0xFFE3F2FD),
      'textColor': Colors.blue.shade800,
    },
  ];

  final List<Map<String, dynamic>> _categoryCards = [
    {
      'title': 'Dog Food',
      'icon': Icons.fastfood,
      'color': const Color(0xFF8D6E63),
      'bgColor': const Color(0xFFD7CCC8),
    },
    {
      'title': 'Dog Treats',
      'icon': Icons.cake,
      'color': const Color(0xFFF9A825),
      'bgColor': const Color(0xFFFFF9C4),
    },
    {
      'title': 'Dog Treatment',
      'icon': Icons.medical_services,
      'color': const Color(0xFFE91E63),
      'bgColor': const Color(0xFFF8BBD0),
    },
    {
      'title': 'Dog Grooming',
      'icon': Icons.spa,
      'color': const Color(0xFF9C27B0),
      'bgColor': const Color(0xFFE1BEE7),
    },
    {
      'title': 'Dog Toys',
      'icon': Icons.toys,
      'color': const Color(0xFF00BCD4),
      'bgColor': const Color(0xFFB2EBF2),
    },
    {
      'title': 'Dog Accessories',
      'icon': Icons.shopping_bag,
      'color': const Color(0xFF8BC34A),
      'bgColor': const Color(0xFFDCEDC8),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Product or Brand',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Get.toNamed(AppRoutes.petList);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['name'];
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        category['name'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? category['textColor'] as Color
                              : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category['name'] as String;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: category['color'] as Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? (category['textColor'] as Color).withOpacity(0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Category Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _categoryCards.length,
                itemBuilder: (context, index) {
                  final card = _categoryCards[index];
                  
                  return InkWell(
                    onTap: () {
                      // Navigate to pet list with category filter
                      Get.toNamed(AppRoutes.petList);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: card['bgColor'] as Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              card['icon'] as IconData,
                              size: 40,
                              color: card['color'] as Color,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            card['title'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: card['color'] as Color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
