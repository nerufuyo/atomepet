import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/controllers/sync_controller.dart';
import 'package:atomepet/controllers/theme_controller.dart';
import 'package:atomepet/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final syncController = Get.find<SyncController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  syncController.isOnline.value
                      ? Icons.cloud_done
                      : Icons.cloud_off,
                ),
                onPressed: () {
                  if (syncController.isOnline.value) {
                    syncController.syncAll();
                  }
                },
                tooltip: syncController.isOnline.value
                    ? 'Online - Tap to sync'
                    : 'Offline',
              )),
          Obx(() => IconButton(
                icon: Icon(
                  themeController.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => themeController.toggleTheme(),
              )),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final user = userController.currentUser.value;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'welcome'.tr,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                user?.username ?? 'Guest',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (!userController.isAuthenticated.value)
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.login),
                            child: Text('login'.tr),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 600 ? 3 : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                  _buildActionCard(
                    context,
                    icon: Icons.pets,
                    title: 'pets'.tr,
                    subtitle: 'Browse available pets',
                    onTap: () => Get.toNamed(AppRoutes.petList),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.store,
                    title: 'store'.tr,
                    subtitle: 'View inventory',
                    onTap: () => Get.toNamed(AppRoutes.store),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.shopping_bag,
                    title: 'orders'.tr,
                    subtitle: 'Order history',
                    onTap: () => Get.toNamed(AppRoutes.orderHistory),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.person,
                    title: 'profile'.tr,
                    subtitle: 'Your account',
                    onTap: () => Get.toNamed(AppRoutes.profile),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.admin_panel_settings,
                    title: 'Admin',
                    subtitle: 'Dashboard',
                    onTap: () => Get.toNamed(AppRoutes.admin),
                  ),
                ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
