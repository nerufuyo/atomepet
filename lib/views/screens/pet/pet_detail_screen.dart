import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/widgets/app_button.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetController>();

    return Scaffold(
      body: Obx(() {
        final pet = controller.selectedPet.value;

        if (pet == null) {
          return const LoadingIndicator(message: 'Loading pet details...');
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: pet.photoUrls.isNotEmpty
                    ? PageView.builder(
                        itemCount: pet.photoUrls.length,
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: index == 0
                                ? 'pet-${pet.id}'
                                : 'pet-${pet.id}-$index',
                            child: CachedNetworkImage(
                              imageUrl: pet.photoUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant,
                                child: const Icon(Icons.pets, size: 80),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.pets, size: 80),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pet.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildStatusChip(context, pet.status?.name),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (pet.category != null) ...[
                      _buildInfoRow(
                        context,
                        icon: Icons.category,
                        label: 'pet_category'.tr,
                        value: pet.category!.name ?? 'N/A',
                      ),
                      const SizedBox(height: 12),
                    ],
                    _buildInfoRow(
                      context,
                      icon: Icons.badge,
                      label: 'ID',
                      value: '${pet.id ?? 'N/A'}',
                    ),
                    if (pet.tags != null && pet.tags!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'pet_tags'.tr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pet.tags!
                            .map((tag) => Chip(label: Text(tag.name ?? '')))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'edit_pet'.tr,
                            icon: Icons.edit,
                            isOutlined: true,
                            onPressed: () {
                              // TODO: Navigate to edit screen
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'delete_pet'.tr,
                            icon: Icons.delete,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            textColor: Theme.of(context).colorScheme.onError,
                            onPressed: () => _showDeleteConfirmation(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'available':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'sold':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status?.toUpperCase() ?? 'N/A',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final controller = Get.find<PetController>();
    final pet = controller.selectedPet.value;

    if (pet?.id == null) return;

    Get.dialog(
      AlertDialog(
        title: Text('delete_pet'.tr),
        content: Text('Are you sure you want to delete ${pet!.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePet(pet.id!);
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
