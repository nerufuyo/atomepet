import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/store_controller.dart';
import 'package:atomepet/models/order.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('order_history'.tr),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const LoadingIndicator(message: 'Loading orders...');
              }

              if (controller.error.value.isNotEmpty &&
                  controller.orders.isEmpty) {
                return ErrorView(
                  message: 'Order history is temporarily unavailable.\n\nThe Petstore API doesn\'t support order listing yet.',
                  onRetry: null, // No retry since API doesn't support this endpoint
                );
              }

              if (controller.orders.isEmpty) {
                return EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'No Orders',
                  message: 'Order history feature is not available in the demo API.\n\nYou can still view and manage pets!',
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchInventory(),
                child: Column(
                  children: [
                    _buildOrderStats(context, controller),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.orders.length,
                        itemBuilder: (context, index) {
                          final order = controller.orders[index];
                          return _buildOrderCard(context, order, controller);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStats(BuildContext context, StoreController controller) {
    final placedOrders = controller
        .getOrdersByStatus(OrderStatus.placed)
        .length;
    final approvedOrders = controller
        .getOrdersByStatus(OrderStatus.approved)
        .length;
    final deliveredOrders = controller
        .getOrdersByStatus(OrderStatus.delivered)
        .length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.pending_actions,
            label: 'Placed',
            value: placedOrders.toString(),
            color: Colors.orange,
          ),
          _buildStatItem(
            context,
            icon: Icons.check_circle,
            label: 'Approved',
            value: approvedOrders.toString(),
            color: Colors.blue,
          ),
          _buildStatItem(
            context,
            icon: Icons.local_shipping,
            label: 'Delivered',
            value: deliveredOrders.toString(),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    StoreController controller,
  ) {
    final statusColor = _getStatusColor(order.status);
    final statusIcon = _getStatusIcon(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          controller.selectOrder(order);
          Get.toNamed(AppRoutes.orderDetail.replaceAll(':id', '${order.id}'));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id ?? 'N/A'}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pet ID: ${order.petId ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status?.name.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    context,
                    icon: Icons.shopping_cart,
                    label: 'Quantity',
                    value: '${order.quantity ?? 0}',
                  ),
                  _buildInfoItem(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Ship Date',
                    value: order.shipDate != null
                        ? DateFormat('MMM dd, yyyy').format(order.shipDate!)
                        : 'N/A',
                  ),
                  _buildInfoItem(
                    context,
                    icon: order.complete == true
                        ? Icons.check_circle
                        : Icons.pending,
                    label: 'Status',
                    value: order.complete == true ? 'Complete' : 'Pending',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus? status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.approved:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(OrderStatus? status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.pending_actions;
      case OrderStatus.approved:
        return Icons.check_circle;
      case OrderStatus.delivered:
        return Icons.local_shipping;
      default:
        return Icons.help_outline;
    }
  }
}
