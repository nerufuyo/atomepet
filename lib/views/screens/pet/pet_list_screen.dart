import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/views/widgets/pet_card.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/widgets/shimmer_loading.dart';
import 'package:atomepet/views/widgets/animated_widgets.dart';
import 'package:atomepet/routes/app_routes.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('pets'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
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
              if (controller.isLoading.value && controller.pets.isEmpty) {
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
                  controller.pets.isEmpty) {
                return ErrorView(
                  message: controller.error.value,
                  onRetry: () =>
                      controller.fetchPetsByStatus([PetStatus.available]),
                );
              }

              if (controller.pets.isEmpty) {
                return EmptyState(
                  icon: Icons.pets,
                  title: 'no_data'.tr,
                  message: 'No pets found',
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
                  itemCount: controller.pets.length,
                  itemBuilder: (context, index) {
                    final pet = controller.pets[index];
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
          final result = await Get.toNamed(AppRoutes.petForm);
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
