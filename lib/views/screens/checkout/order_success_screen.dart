import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/models/order.dart';
import 'package:atomepet/views/widgets/app_button.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:intl/intl.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Success message
              Text(
                'Order Placed Successfully!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for your purchase. Your order has been confirmed.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Order details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      'Order ID',
                      '#${order.id}',
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Pet ID',
                      '#${order.petId}',
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Quantity',
                      '${order.quantity}',
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Status',
                      order.status?.name.toUpperCase() ?? 'PLACED',
                      valueColor: _getStatusColor(order.status),
                    ),
                    if (order.shipDate != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        context,
                        'Est. Delivery',
                        DateFormat('MMM dd, yyyy').format(order.shipDate!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Action buttons
              AppButton(
                text: 'View Orders',
                icon: Icons.receipt_long,
                onPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                  Get.toNamed(AppRoutes.orderHistory);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Continue Shopping',
                icon: Icons.shopping_bag,
                isOutlined: true,
                onPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus? status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.approved:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
