import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/controllers/cart_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/views/widgets/pet_card.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/widgets/shimmer_loading.dart';
import 'package:atomepet/views/widgets/animated_widgets.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:atomepet/views/screens/pet/pet_form_screen.dart';
import 'package:atomepet/bindings/home_binding.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;
  final RxString _selectedCategory = RxString('All');
  final RxString _sortBy = RxString('name'); // 'name', 'price_low', 'price_high'
  Timer? _debounceTimer;

  final List<String> _categories = ['All', 'Dogs', 'Cats', 'Birds', 'Fish', 'Other'];

  @override
  void initState() {
    super.initState();
    // Ensure data is loaded when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<PetController>();
      if (controller.filteredPets.isEmpty && !controller.isLoading.value) {
        controller.fetchPetsByStatus([PetStatus.available]);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  double _calculatePetPrice(Pet pet) {
    double basePrice = 100.0;
    
    switch (pet.category?.name?.toLowerCase()) {
      case 'dogs':
        basePrice = 500.0;
        break;
      case 'cats':
        basePrice = 400.0;
        break;
      case 'birds':
        basePrice = 150.0;
        break;
      case 'fish':
        basePrice = 50.0;
        break;
      default:
        basePrice = 200.0;
    }

    if (pet.status == PetStatus.sold) {
      basePrice = 0.0;
    } else if (pet.status == PetStatus.pending) {
      basePrice *= 0.9;
    }

    return basePrice;
  }

  List<Pet> _getFilteredAndSortedPets(List<Pet> pets) {
    var filtered = pets;

    // Filter by category
    if (_selectedCategory.value != 'All') {
      filtered = filtered.where((pet) => 
        pet.category?.name?.toLowerCase() == _selectedCategory.value.toLowerCase()
      ).toList();
    }

    // Sort
    switch (_sortBy.value) {
      case 'name':
        filtered.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
      case 'price_low':
        filtered.sort((a, b) => _calculatePetPrice(a).compareTo(_calculatePetPrice(b)));
        break;
      case 'price_high':
        filtered.sort((a, b) => _calculatePetPrice(b).compareTo(_calculatePetPrice(a)));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetController>();
    final cartController = Get.find<CartController>();
    final bool isWeb = kIsWeb;

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: _isSearching.value
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search pets...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                    controller.searchPets(value);
                  });
                },
              )
            : Text('pets'.tr),
        actions: [
          IconButton(
                icon: Icon(_isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  if (_isSearching.value) {
                    _searchController.clear();
                    controller.searchPets('');
                  }
                  _isSearching.value = !_isSearching.value;
                },
              ),
          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onSelected: (value) => _sortBy.value = value,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Name (A-Z)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'price_low',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward),
                    SizedBox(width: 8),
                    Text('Price: Low to High'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'price_high',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward),
                    SizedBox(width: 8),
                    Text('Price: High to Low'),
                  ],
                ),
              ),
            ],
          ),
          // Status filter
          PopupMenuButton<PetStatus>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by status',
            onSelected: (status) => controller.filterByStatus(status),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: PetStatus.available,
                child: Text('available'.tr),
              ),
              PopupMenuItem(
                value: PetStatus.pending,
                child: Text('pending'.tr),
              ),
              PopupMenuItem(value: PetStatus.sold, child: Text('sold'.tr)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory.value == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    _selectedCategory.value = category;
                  },
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
          
          Expanded(
            child: Builder(
              builder: (context) {
                if (controller.isLoading.value && controller.filteredPets.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: 6,
                      itemBuilder: (context, index) => const ShimmerPetCard(),
                    ),
                  );
                }

                if (controller.error.value.isNotEmpty &&
                    controller.filteredPets.isEmpty) {
                  return ErrorView(
                    message: controller.error.value,
                    onRetry: () =>
                        controller.fetchPetsByStatus([PetStatus.available]),
                  );
                }

                // Apply category filter and sorting
                final displayPets = _getFilteredAndSortedPets(controller.filteredPets);

                if (displayPets.isEmpty) {
                  return EmptyState(
                    icon: Icons.pets,
                    title: 'no_data'.tr,
                    message: _isSearching.value && _searchController.text.isNotEmpty
                        ? 'No pets found matching "${_searchController.text}"'
                        : _selectedCategory.value != 'All'
                            ? 'No ${_selectedCategory.value.toLowerCase()} available'
                            : 'No pets found',
                    action: ElevatedButton.icon(
                      onPressed: () {
                        _selectedCategory.value = 'All';
                        _searchController.clear();
                        controller.searchPets('');
                        controller.fetchPetsByStatus([PetStatus.available]);
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text('retry'.tr),
                    ),
                  );
                }

                // Trigger rebuild when cart changes by using cart itemCount
                final _ = cartController.itemCount;
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchPetsByStatus([
                      controller.selectedStatus.value,
                    ]);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: displayPets.length,
                    itemBuilder: (context, index) {
                      final pet = displayPets[index];
                      final price = _calculatePetPrice(pet);
                        
                      return buildAnimatedGridItem(
                        context,
                        index,
                        PetCard(
                          name: pet.name ?? 'Unknown',
                          category: pet.category?.name,
                          status: pet.status?.name,
                          photoUrls: pet.photoUrls ?? [],
                          heroTag: 'pet-${pet.id}',
                          price: price,
                          isInCart: cartController.isPetInCart(pet.id ?? 0),
                          onTap: () {
                            controller.selectPet(pet);
                            Get.toNamed(
                              AppRoutes.petDetail.replaceAll(':id', '${pet.id}'),
                            );
                          },
                          onAddToCart: !isWeb && pet.status == PetStatus.available
                              ? () {
                                  cartController.addToCart(pet, customPrice: price);
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isWeb
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Get.to(
                  () => const PetFormScreen(pet: null),
                  binding: HomeBinding(),
                  transition: Transition.rightToLeft,
                );
                if (result == true) {
                  controller.fetchPetsByStatus([PetStatus.available]);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Pet'),
            )
          : null,
    ));
  }
}
