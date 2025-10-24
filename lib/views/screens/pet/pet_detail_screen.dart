import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/controllers/cart_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/widgets/app_button.dart';
import 'package:atomepet/views/screens/pet/pet_form_screen.dart';
import 'package:atomepet/bindings/home_binding.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetController>();
    final cartController = Get.find<CartController>();
    final bool isWeb = kIsWeb;

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
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Get.to(
                      () => PetFormScreen(pet: pet),
                      binding: HomeBinding(),
                      transition: Transition.rightToLeft,
                    );
                    if (result == true) {
                      controller.fetchPetById(pet.id!);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: (pet.photoUrls?.isNotEmpty ?? false)
                    ? PageView.builder(
                        itemCount: pet.photoUrls?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: index == 0
                                ? 'pet-${pet.id}'
                                : 'pet-${pet.id}-$index',
                            child: CachedNetworkImage(
                              imageUrl: pet.photoUrls![index],
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
                            pet.name ?? 'Unknown Pet',
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
                    // Different buttons for web (admin) vs mobile (purchase)
                    if (isWeb) ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'edit_pet'.tr,
                              icon: Icons.edit,
                              isOutlined: true,
                              onPressed: () async {
                                final result = await Get.to(
                                  () => PetFormScreen(pet: pet),
                                  binding: HomeBinding(),
                                  transition: Transition.rightToLeft,
                                );
                                if (result == true) {
                                  controller.fetchPetById(pet.id!);
                                }
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
                    ] else ...[
                      // Mobile: Purchase button
                      _buildPurchaseSection(context, pet, cartController),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPurchaseSection(BuildContext context, Pet pet, CartController cartController) {
    // Calculate price
    double price = _calculatePetPrice(pet);
    bool canPurchase = pet.status == PetStatus.available;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Price display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Add to Cart button
        Obx(() {
          final isInCart = cartController.isPetInCart(pet.id ?? 0);
          final cartItem = cartController.getCartItem(pet.id ?? 0);

          return AppButton(
            text: isInCart 
                ? 'In Cart (${cartItem?.quantity ?? 0})'
                : (canPurchase ? 'Add to Cart' : 'Not Available'),
            icon: isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
            backgroundColor: canPurchase 
                ? (isInCart 
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary)
                : Theme.of(context).colorScheme.surfaceVariant,
            textColor: canPurchase
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            onPressed: canPurchase
                ? () {
                    cartController.addToCart(pet, customPrice: price);
                  }
                : null,
          );
        }),
        if (!canPurchase) ...[
          const SizedBox(height: 8),
          Text(
            pet.status == PetStatus.sold
                ? 'This pet has already been sold'
                : 'This pet is currently pending',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  double _calculatePetPrice(Pet pet) {
    double basePrice = 100.0;
    
    // Price based on category
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

    // Status affects price
    if (pet.status == PetStatus.sold) {
      basePrice = 0.0;
    } else if (pet.status == PetStatus.pending) {
      basePrice *= 0.9; // 10% discount
    }

    return basePrice;
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
