import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/store_controller.dart';
import 'package:atomepet/views/widgets/app_widgets.dart';
import 'package:atomepet/views/widgets/connectivity_banner.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('store'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchInventory(),
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.inventory.isEmpty) {
                return const LoadingIndicator(message: 'Loading inventory...');
              }

              if (controller.error.value.isNotEmpty &&
                  controller.inventory.isEmpty) {
                return ErrorView(
                  message: controller.error.value,
                  onRetry: () => controller.fetchInventory(),
                );
              }

              if (controller.inventory.isEmpty) {
                return EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No Inventory',
                  message: 'No inventory data available',
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchInventory(),
                child: Column(
                  children: [
                    _buildInventoryStats(context, controller),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.inventory.length,
                        itemBuilder: (context, index) {
                          final entry = controller.inventory.entries.elementAt(
                            index,
                          );
                          return _buildInventoryCard(
                            context,
                            status: entry.key,
                            quantity: entry.value,
                          );
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

  Widget _buildInventoryStats(
    BuildContext context,
    StoreController controller,
  ) {
    final totalItems = controller.inventory.values.fold<int>(
      0,
      (sum, qty) => sum + qty,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
            icon: Icons.inventory_2,
            label: 'Total Items',
            value: totalItems.toString(),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          _buildStatItem(
            context,
            icon: Icons.category,
            label: 'Categories',
            value: controller.inventory.length.toString(),
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
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildInventoryCard(
    BuildContext context, {
    required String status,
    required int quantity,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'available':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'sold':
        statusColor = Colors.red;
        statusIcon = Icons.shopping_bag;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          status.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Pet Status'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
