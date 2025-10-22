import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String? category;
  final String? status;
  final List<String> photoUrls;
  final VoidCallback? onTap;
  final String? heroTag;

  const PetCard({
    super.key,
    required this.name,
    this.category,
    this.status,
    required this.photoUrls,
    this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: photoUrls.isNotEmpty
                  ? Hero(
                      tag: heroTag ?? photoUrls.first,
                      child: CachedNetworkImage(
                        imageUrl: photoUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
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
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (category != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      category!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (status != null) ...[
                    const SizedBox(height: 8),
                    _buildStatusChip(context),
                  ],
                ],
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
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status!.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
