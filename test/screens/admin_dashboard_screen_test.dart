import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:atomepet/views/screens/admin/admin_dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminDashboardScreen Widget Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('AdminDashboardScreen should display dashboard title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('AdminDashboardScreen should display navigation items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // On mobile, should have bottom navigation
      expect(find.byType(NavigationBar), findsAny);
    });

    testWidgets('AdminDashboardScreen should display statistics cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Total Pets'), findsOneWidget);
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Sold'), findsOneWidget);
    });

    testWidgets('AdminDashboardScreen should display quick actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Add New Pet'), findsOneWidget);
      expect(find.text('View All Pets'), findsOneWidget);
      expect(find.text('View Orders'), findsOneWidget);
      expect(find.text('Manage Users'), findsOneWidget);
    });

    testWidgets('AdminDashboardScreen should switch between tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find navigation bar
      final navBar = find.byType(NavigationBar);
      if (navBar.evaluate().isNotEmpty) {
        // Tap on Pet Management tab (index 1)
        final petManagementTab = find.descendant(
          of: navBar,
          matching: find.byIcon(Icons.pets),
        );

        if (petManagementTab.evaluate().isNotEmpty) {
          await tester.tap(petManagementTab);
          await tester.pumpAndSettle();

          // Should display pet management content
          expect(find.text('Pet Management'), findsAny);
        }
      }
    });

    testWidgets('AdminDashboardScreen should display app name in sidebar',
        (WidgetTester tester) async {
      // Set a wide screen size to show sidebar
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('AtomePet'), findsOneWidget);
      expect(find.text('Admin Panel'), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('AdminDashboardScreen should show navigation rail on wide screen',
        (WidgetTester tester) async {
      // Set a wide screen size
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have NavigationRail instead of bottom navigation
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('AdminDashboardScreen should display statistics with zero pets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Statistics should show 0 when no pets exist
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('AdminDashboardScreen quick action should be tappable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap "View All Pets" quick action
      final viewAllPetsButton = find.text('View All Pets');
      expect(viewAllPetsButton, findsOneWidget);

      await tester.tap(viewAllPetsButton);
      await tester.pumpAndSettle();

      // Should navigate to Pet Management tab
      expect(find.text('Pet Management'), findsAny);
    });

    testWidgets('AdminDashboardScreen should display correct icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.dashboard), findsWidgets);
      expect(find.byIcon(Icons.pets), findsWidgets);
      expect(find.byIcon(Icons.shopping_bag), findsWidgets);
      expect(find.byIcon(Icons.people), findsWidgets);
    });

    testWidgets('AdminDashboardScreen should have vertical divider on wide screen',
        (WidgetTester tester) async {
      // Set a wide screen size
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(VerticalDivider), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('AdminDashboardScreen statistics should use correct colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find statistics cards icons
      expect(find.byIcon(Icons.check_circle), findsWidgets);
      expect(find.byIcon(Icons.pending), findsWidgets);
      expect(find.byIcon(Icons.sell), findsWidgets);
    });
  });
}
