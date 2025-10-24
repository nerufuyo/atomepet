import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String? category;
  final String? status;
  final List<String> photoUrls;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final String? heroTag;
  final double? price;
  final bool isInCart;

  const PetCard({
    super.key,
    required this.name,
    this.category,
    this.status,
    required this.photoUrls,
    this.onTap,
    this.onAddToCart,
    this.heroTag,
    this.price,
    this.isInCart = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = status?.toLowerCase() == 'available';
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pet Image - Fixed aspect ratio
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Pet Image
                  photoUrls.isNotEmpty
                      ? Hero(
                          tag: heroTag ?? photoUrls.first,
                          child: CachedNetworkImage(
                            imageUrl: photoUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Icon(Icons.pets, size: 48),
                            ),
                          ),
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Center(child: Icon(Icons.pets, size: 48)),
                        ),
                  
                  // Status badge
                  if (status != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildStatusChip(context),
                    ),
                  
                  // In Cart badge
                  if (isInCart)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 16,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Pet Info - Flexible
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet name
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Category
                    if (category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        category!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Price and Add to Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (price != null)
                          Expanded(
                            child: Text(
                              '\$${price!.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (onAddToCart != null && isAvailable)
                          InkWell(
                            onTap: onAddToCart,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isInCart
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isInCart ? Icons.check : Icons.add,
                                size: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status!.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
