import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/cart_controller.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/views/widgets/pet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petController = Get.find<PetController>();
      if (petController.pets.isEmpty) {
        petController.fetchPetsByStatus([PetStatus.available]);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
    return basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final petController = Get.find<PetController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Logo and Search
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.pets,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Product or Brand',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            Get.toNamed(AppRoutes.petList);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                // Cart icon
                Obx(() {
                  final itemCount = cartController.itemCount;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black87,
                        ),
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              itemCount > 9 ? '9+' : '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Promotional Banner
                  _buildPromotionalBanner(context),
                  
                  const SizedBox(height: 24),
                  
                  // Trending Now Section
                  _buildTrendingSection(context, petController, cartController),
                  
                  const SizedBox(height: 24),
                  
                  // Browse Pet Types
                  _buildBrowsePetTypes(context),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4ECDC4),
                const Color(0xFF44A08D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 20,
                top: 20,
                bottom: 20,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pets,
                      size: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 20,
                bottom: 20,
                right: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SPECIAL',
                        style: TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pet Food',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Up to 40% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context, PetController petController, CartController cartController) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.petList),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B4EFF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final pets = petController.pets.take(4).toList();
          
          if (pets.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SizedBox(
            height: 280,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final price = _calculatePetPrice(pet);
                
                return Obx(() {
                  final isInCart = cartController.isPetInCart(pet.id ?? 0);
                  final cartItem = cartController.getCartItem(pet.id ?? 0);
                  final quantity = cartItem?.quantity ?? 0;

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: PetCard(
                      name: pet.name ?? 'Unknown',
                      category: pet.category?.name,
                      status: pet.status?.name,
                      photoUrls: pet.photoUrls ?? [],
                      heroTag: 'trending-pet-${pet.id}',
                      price: price,
                      isInCart: isInCart,
                      cartQuantity: quantity,
                      onTap: () {
                        petController.selectPet(pet);
                        Get.toNamed(
                          AppRoutes.petDetail.replaceAll(':id', '${pet.id}'),
                        );
                      },
                      onAddToCart: () {
                        cartController.addToCart(pet, customPrice: price);
                      },
                      onIncreaseQuantity: () {
                        cartController.updateQuantity(pet.id ?? 0, quantity + 1);
                      },
                      onDecreaseQuantity: () {
                        cartController.updateQuantity(pet.id ?? 0, quantity - 1);
                      },
                      onRemoveFromCart: () {
                        cartController.removeFromCart(pet.id ?? 0);
                      },
                    ),
                  );
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBrowsePetTypes(BuildContext context) {
    final categories = [
      {'name': 'Dog', 'icon': Icons.pets, 'route': AppRoutes.petList},
      {'name': 'Cat', 'icon': Icons.pets, 'route': AppRoutes.petList},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Browse pet types',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.petList),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B4EFF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories.map((category) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: category == categories.last ? 0 : 12,
                  ),
                  child: InkWell(
                    onTap: () => Get.toNamed(category['route'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.shade100,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              size: 40,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
