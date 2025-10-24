import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PetCard extends StatefulWidget {
  final String name;
  final String? category;
  final String? status;
  final List<String> photoUrls;
  final VoidCallback? onTap;
  final String? heroTag;
  final double? price;
  final bool isInCart;
  final int cartQuantity;
  final VoidCallback? onAddToCart;
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  final VoidCallback? onRemoveFromCart;

  const PetCard({
    super.key,
    required this.name,
    this.category,
    this.status,
    required this.photoUrls,
    this.onTap,
    this.heroTag,
    this.price,
    this.isInCart = false,
    this.cartQuantity = 0,
    this.onAddToCart,
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onRemoveFromCart,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showQuantityControls = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    if (widget.isInCart) {
      _showQuantityControls = true;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isInCart != oldWidget.isInCart) {
      if (widget.isInCart) {
        setState(() => _showQuantityControls = true);
        _controller.forward();
      } else {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() => _showQuantityControls = false);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleQuantityControls() {
    if (!widget.isInCart) {
      widget.onAddToCart?.call();
      return;
    }

    setState(() {
      _showQuantityControls = !_showQuantityControls;
      if (_showQuantityControls) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canAddToCart = widget.status?.toLowerCase() == 'available';
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        onTap: widget.onTap,
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
                  widget.photoUrls.isNotEmpty
                      ? Hero(
                          tag: widget.heroTag ?? widget.photoUrls.first,
                          child: CachedNetworkImage(
                            imageUrl: widget.photoUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade100,
                              child: Icon(
                                Icons.pets, 
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(
                              Icons.pets, 
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                  
                  // Status badge
                  if (widget.status != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildStatusChip(context),
                    ),
                  
                  // Cart badge (top right)
                  if (widget.isInCart)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.cartQuantity}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Pet Info - Flexible
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pet name
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        height: 1.0,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Category
                    if (widget.category != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        widget.category!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 9,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Price and Cart Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.price != null)
                          Flexible(
                            child: Text(
                              '\$${widget.price!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B4EFF),
                                fontSize: 12,
                                height: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        
                        // Cart button
                        if (canAddToCart)
                          _buildCartButton(context),
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

  Widget _buildCartButton(BuildContext context) {
    if (!widget.isInCart) {
      // Show add to cart icon
      return InkWell(
        onTap: () {
          widget.onAddToCart?.call();
          setState(() {
            _showQuantityControls = true;
          });
          _controller.forward();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF6B4EFF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4EFF).withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_shopping_cart,
            size: 14,
            color: Colors.white,
          ),
        ),
      );
    }

    // Show quantity controls or cart icon
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: _showQuantityControls
          ? _buildQuantityControls(context)
          : InkWell(
              onTap: _toggleQuantityControls,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4EFF).withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6B4EFF).withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: widget.onDecreaseQuantity,
            icon: const Icon(Icons.remove, size: 12),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            padding: EdgeInsets.zero,
            color: const Color(0xFF6B4EFF),
            splashRadius: 10,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 16),
            alignment: Alignment.center,
            child: Text(
              '${widget.cartQuantity}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4EFF),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onIncreaseQuantity,
            icon: const Icon(Icons.add, size: 12),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            padding: EdgeInsets.zero,
            color: const Color(0xFF6B4EFF),
            splashRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    switch (widget.status?.toLowerCase()) {
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
        widget.status!.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
