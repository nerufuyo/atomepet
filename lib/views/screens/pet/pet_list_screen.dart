import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => _isSearching.value
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
                  // Filter pets locally based on search term
                  controller.searchPets(value);
                },
              )
            : Text('pets'.tr)),
        actions: [
          Obx(() => IconButton(
                icon: Icon(_isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  if (_isSearching.value) {
                    _searchController.clear();
                    controller.searchPets('');
                  }
                  _isSearching.value = !_isSearching.value;
                },
              )),
          PopupMenuButton<PetStatus>(
            icon: const Icon(Icons.filter_list),
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
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredPets.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
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

              if (controller.filteredPets.isEmpty) {
                return EmptyState(
                  icon: Icons.pets,
                  title: 'no_data'.tr,
                  message: _isSearching.value && _searchController.text.isNotEmpty
                      ? 'No pets found matching "${_searchController.text}"'
                      : 'No pets found',
                  action: ElevatedButton.icon(
                    onPressed: () =>
                        controller.fetchPetsByStatus([PetStatus.available]),
                    icon: const Icon(Icons.refresh),
                    label: Text('retry'.tr),
                  ),
                );
              }

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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: controller.filteredPets.length,
                  itemBuilder: (context, index) {
                    final pet = controller.filteredPets[index];
                    return buildAnimatedGridItem(
                      context,
                      index,
                      PetCard(
                        name: pet.name ?? 'Unknown',
                        category: pet.category?.name,
                        status: pet.status?.name,
                        photoUrls: pet.photoUrls ?? [],
                        heroTag: 'pet-${pet.id}',
                        onTap: () {
                          controller.selectPet(pet);
                          Get.toNamed(
                            AppRoutes.petDetail.replaceAll(':id', '${pet.id}'),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print('Add Pet button clicked - navigating to PetFormScreen');
          final result = await Get.to(
            () => const PetFormScreen(pet: null),
            binding: HomeBinding(),
            transition: Transition.rightToLeft,
          );
          print('Add Pet navigation result: $result');
          if (result == true) {
            controller.fetchPetsByStatus([PetStatus.available]);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }
}
