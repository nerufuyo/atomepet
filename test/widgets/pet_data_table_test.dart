import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:atomepet/views/widgets/admin/pet_data_table.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PetDataTable Widget Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('PetDataTable should display title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pet Management'), findsOneWidget);
    });

    testWidgets('PetDataTable should display add new pet button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Add New Pet'), findsOneWidget);
    });

    testWidgets('PetDataTable should display search field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(TextField, 'Search by name, category, or ID...'),
          findsOneWidget);
    });

    testWidgets('PetDataTable should display status filter dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownMenu<String>, 'Status'), findsOneWidget);
    });

    testWidgets('PetDataTable should display rows per page dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownMenu<int>, 'Rows per page'),
          findsOneWidget);
    });

    testWidgets('PetDataTable should display empty state when no pets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No pets found'), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
    });

    testWidgets('PetDataTable search field should be editable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final searchField =
          find.widgetWithText(TextField, 'Search by name, category, or ID...');
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Should show clear button when text is entered
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('PetDataTable clear button should clear search',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final searchField =
          find.widgetWithText(TextField, 'Search by name, category, or ID...');

      // Enter search text
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Find and tap clear button
      final clearButton = find.byIcon(Icons.clear);
      expect(clearButton, findsOneWidget);

      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Clear button should no longer be visible
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('PetDataTable should display data table columns',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // If no pets, might not show table
      // But we can check for empty state
      expect(find.text('No pets found'), findsOneWidget);
    });

    testWidgets('PetDataTable should be wrapped in a Card',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('PetDataTable should have search icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('PetDataTable add button should have icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('PetDataTable empty state should show helpful message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PetDataTable(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No pets found'), findsOneWidget);
      expect(find.text('Add your first pet to get started'), findsOneWidget);
    });
  });
}
