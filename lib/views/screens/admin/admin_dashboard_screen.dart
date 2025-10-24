import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:atomepet/views/widgets/admin/pet_data_table.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      route: '/admin',
    ),
    NavigationItem(
      icon: Icons.pets,
      label: 'Pet Management',
      route: '/admin/pets',
    ),
    NavigationItem(
      icon: Icons.shopping_bag,
      label: 'Orders',
      route: '/admin/orders',
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Users',
      route: '/admin/users',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width >= 1024;
    final isMediumScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          if (isWideScreen || isMediumScreen)
            NavigationRail(
              extended: isWideScreen,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: isWideScreen
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.pets,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'AtomePet',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Admin Panel',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Icon(
                      Icons.pets,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
              trailing: isWideScreen
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildUserSection(theme),
                        ),
                      ),
                    )
                  : null,
              destinations: _navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),

          // Vertical Divider
          if (isWideScreen || isMediumScreen) const VerticalDivider(width: 1),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(theme, isWideScreen),

                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation for mobile
      bottomNavigationBar: (isWideScreen || isMediumScreen)
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isWideScreen) {
    final userController = Get.find<UserController>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(
              _navItems[_selectedIndex].label,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (isWideScreen) ...[
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
              const SizedBox(width: 8),
              Obx(() {
                final user = userController.currentUser.value;
                return PopupMenuButton<void>(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          user?.username?.substring(0, 1).toUpperCase() ?? 'A',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user?.username ?? 'Admin',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  itemBuilder: (context) => <PopupMenuEntry<void>>[
                    PopupMenuItem<void>(
                      child: const Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 12),
                          Text('Profile'),
                        ],
                      ),
                      onTap: () => Get.toNamed(AppRoutes.profile),
                    ),
                    PopupMenuItem<void>(
                      child: const Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                      onTap: () {
                        // TODO: Navigate to settings
                      },
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<void>(
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: theme.colorScheme.error),
                          const SizedBox(width: 12),
                          Text(
                            'Logout',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await userController.logout();
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                );
              }),
            ] else
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // TODO: Show mobile menu
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(ThemeData theme) {
    final userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.currentUser.value;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  user?.username?.substring(0, 1).toUpperCase() ?? 'A',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.username ?? 'Admin',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                user?.email ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await userController.logout();
                  Get.offAllNamed(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildPetManagementContent();
      case 2:
        return _buildOrdersContent();
      case 3:
        return _buildUsersContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final petController = Get.find<PetController>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Dashboard',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your pet store efficiently',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.dashboard_rounded,
                  size: 64,
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Statistics Cards
          Text(
            'Overview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Obx(() {
            final pets = petController.pets;
            final availableCount = pets.where((p) => p.status == PetStatus.available).length;
            final pendingCount = pets.where((p) => p.status == PetStatus.pending).length;
            final soldCount = pets.where((p) => p.status == PetStatus.sold).length;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final crossAxisCount = isWide ? 4 : (constraints.maxWidth >= 600 ? 2 : 1);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  children: [
                    _buildStatCard(
                      theme,
                      'Total Pets',
                      pets.length.toString(),
                      Icons.pets,
                      theme.colorScheme.primary,
                    ),
                    _buildStatCard(
                      theme,
                      'Available',
                      availableCount.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _buildStatCard(
                      theme,
                      'Pending',
                      pendingCount.toString(),
                      Icons.pending,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      theme,
                      'Sold',
                      soldCount.toString(),
                      Icons.sell,
                      Colors.blue,
                    ),
                  ],
                );
              },
            );
          }),
          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildQuickActionCard(
                theme,
                'Add New Pet',
                Icons.add_circle,
                () => Get.toNamed(AppRoutes.petForm),
              ),
              _buildQuickActionCard(
                theme,
                'View All Pets',
                Icons.list,
                () => setState(() => _selectedIndex = 1),
              ),
              _buildQuickActionCard(
                theme,
                'View Orders',
                Icons.shopping_bag,
                () => setState(() => _selectedIndex = 2),
              ),
              _buildQuickActionCard(
                theme,
                'Manage Users',
                Icons.people,
                () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    ThemeData theme,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetManagementContent() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: PetDataTable(),
    );
  }

  Widget _buildOrdersContent() {
    return const Center(
      child: Text('Orders Management - Coming soon'),
    );
  }

  Widget _buildUsersContent() {
    return const Center(
      child: Text('Users Management - Coming soon'),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
