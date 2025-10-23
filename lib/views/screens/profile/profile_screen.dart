import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/controllers/theme_controller.dart';
import 'package:atomepet/views/widgets/app_button.dart';
import 'package:atomepet/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr), centerTitle: true),
      body: Obx(() {
        final user = userController.currentUser.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildProfileHeader(context, user?.username),
              const SizedBox(height: 32),
              _buildUserInfo(context, userController),
              const SizedBox(height: 24),
              _buildSettingsSection(context, themeController),
              const SizedBox(height: 24),
              _buildLogoutSection(context, userController),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String? username) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              username?.substring(0, 1).toUpperCase() ?? 'U',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          username ?? 'User',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, UserController controller) {
    final user = controller.currentUser.value;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            context,
            icon: Icons.badge,
            title: 'Full Name',
            subtitle: (user?.firstName?.isNotEmpty == true || user?.lastName?.isNotEmpty == true)
                ? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim()
                : 'Not provided',
          ),
          _buildDivider(context),
          _buildInfoTile(
            context,
            icon: Icons.email,
            title: 'Email',
            subtitle: user?.email ?? 'Not provided',
          ),
          _buildDivider(context),
          _buildInfoTile(
            context,
            icon: Icons.phone,
            title: 'Phone',
            subtitle: user?.phone ?? 'Not provided',
          ),
          _buildDivider(context),
          _buildInfoTile(
            context,
            icon: Icons.verified_user,
            title: 'Account Status',
            subtitle: user?.userStatus == 1 ? 'Active' : 'Inactive',
            trailing: user?.userStatus == 1
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : const Icon(Icons.cancel, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'settings'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => SwitchListTile(
              secondary: Icon(
                themeController.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: Text(
                themeController.isDarkMode.value
                    ? 'dark_mode'.tr
                    : 'light_mode'.tr,
              ),
              subtitle: const Text('Toggle app theme'),
              value: themeController.isDarkMode.value,
              onChanged: (value) => themeController.toggleTheme(),
            ),
          ),
          _buildDivider(context),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr),
            subtitle: Text(
              Get.locale?.languageCode == 'es' ? 'Español' : 'English',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Toggle between English and Spanish
              if (Get.locale?.languageCode == 'en') {
                Get.updateLocale(const Locale('es', 'ES'));
              } else {
                Get.updateLocale(const Locale('en', 'US'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, UserController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppButton(
        text: 'logout'.tr,
        icon: Icons.logout,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text('logout'.tr),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('cancel'.tr),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text('logout'.tr),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 72,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }
}
