import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/models/cart_item.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/order.dart';
import 'package:atomepet/repositories/store_repository.dart';

class CartController extends GetxController {
  final StoreRepository _storeRepository;

  CartController(this._storeRepository);

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Computed properties
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get tax => subtotal * 0.1; // 10% tax
  
  double get total => subtotal + tax;

  // Add item to cart
  void addToCart(Pet pet, {double? customPrice}) {
    final price = customPrice ?? _calculatePetPrice(pet);
    
    // Check if pet already in cart
    final existingIndex = cartItems.indexWhere((item) => item.pet.id == pet.id);
    
    if (existingIndex != -1) {
      // Increase quantity
      final item = cartItems[existingIndex];
      cartItems[existingIndex] = item.copyWith(quantity: item.quantity + 1);
      
      Get.snackbar(
        'Added to Cart',
        '${pet.name} quantity increased to ${item.quantity + 1}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.shopping_cart),
        duration: const Duration(seconds: 2),
      );
    } else {
      // Add new item
      cartItems.add(CartItem(
        pet: pet,
        quantity: 1,
        price: price,
      ));
      
      Get.snackbar(
        'Added to Cart',
        '${pet.name} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.shopping_cart),
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Remove item from cart
  void removeFromCart(int petId) {
    final item = cartItems.firstWhere((item) => item.pet.id == petId);
    cartItems.removeWhere((item) => item.pet.id == petId);
    
    Get.snackbar(
      'Removed from Cart',
      '${item.pet.name} removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.surfaceVariant,
      colorText: Get.theme.colorScheme.onSurfaceVariant,
      icon: const Icon(Icons.remove_shopping_cart),
      duration: const Duration(seconds: 2),
    );
  }

  // Update quantity
  void updateQuantity(int petId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(petId);
      return;
    }

    final index = cartItems.indexWhere((item) => item.pet.id == petId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
    }
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.surfaceVariant,
      colorText: Get.theme.colorScheme.onSurfaceVariant,
      duration: const Duration(seconds: 2),
    );
  }

  // Calculate pet price (simple logic based on category/status)
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
      basePrice = 0.0; // Sold pets cannot be purchased
    } else if (pet.status == PetStatus.pending) {
      basePrice *= 0.9; // 10% discount for pending
    }

    return basePrice;
  }

  // Place order using Store API
  Future<Order?> placeOrder() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      // Create order with first pet in cart (API limitation)
      final firstPet = cartItems.first.pet;
      final totalQuantity = cartItems.fold(0, (sum, item) => sum + item.quantity);

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch,
        petId: firstPet.id,
        quantity: totalQuantity,
        shipDate: DateTime.now().add(const Duration(days: 7)),
        status: OrderStatus.placed,
        complete: false,
      );

      // Place order via API
      final placedOrder = await _storeRepository.placeOrder(order);

      // Clear cart after successful order
      clearCart();

      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.check_circle),
        duration: const Duration(seconds: 3),
      );

      return placedOrder;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Order Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Check if pet is in cart
  bool isPetInCart(int petId) {
    return cartItems.any((item) => item.pet.id == petId);
  }

  // Get cart item for a pet
  CartItem? getCartItem(int petId) {
    try {
      return cartItems.firstWhere((item) => item.pet.id == petId);
    } catch (e) {
      return null;
    }
  }
}
