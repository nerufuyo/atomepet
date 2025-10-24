import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atomepet/controllers/cart_controller.dart';
import 'package:atomepet/views/widgets/app_button.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/screens/checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          Obx(() {
            if (cartController.cartItems.isNotEmpty) {
              return TextButton.icon(
                onPressed: () => _showClearConfirmation(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear'),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Your cart is empty',
            message: 'Browse our pet collection and add pets to your cart!',
            action: ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.pets),
              label: const Text('Browse Pets'),
            ),
          );
        }

        return Column(
          children: [
            // Cart items list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _buildCartItem(context, item, cartController);
                },
              ),
            ),
            
            // Cart summary
            _buildCartSummary(context, cartController),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(BuildContext context, cartItem, CartController controller) {
    final pet = cartItem.pet;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (pet.photoUrls?.isNotEmpty ?? false)
                  ? CachedNetworkImage(
                      imageUrl: pet.photoUrls!.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.pets),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.pets),
                    ),
            ),
            const SizedBox(width: 12),
            
            // Pet details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name ?? 'Unknown Pet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (pet.category != null)
                    Text(
                      pet.category!.name ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${cartItem.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'x ${cartItem.quantity}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            controller.updateQuantity(
                              pet.id!,
                              cartItem.quantity - 1,
                            );
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${cartItem.quantity}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.updateQuantity(
                            pet.id!,
                            cartItem.quantity + 1,
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Spacer(),
                      
                      // Remove button
                      IconButton(
                        onPressed: () {
                          controller.removeFromCart(pet.id!);
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '\$${controller.subtotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax (10%)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '\$${controller.tax.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$${controller.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Proceed to Checkout',
              icon: Icons.payment,
              onPressed: () {
                Get.to(
                  () => const CheckoutScreen(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<CartController>().clearCart();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
