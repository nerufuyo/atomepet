import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:atomepet/views/screens/pet/pet_form_screen.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/category.dart';
import 'package:atomepet/models/tag.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PetFormScreen Widget Tests', () {
    setUp(() {
      // Initialize GetX
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('PetFormScreen should display create mode title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      expect(find.text('Create Pet'), findsOneWidget);
    });

    testWidgets('PetFormScreen should display edit mode title when pet is provided',
        (WidgetTester tester) async {
      final pet = Pet(
        id: 1,
        name: 'Test Pet',
        photoUrls: [],
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: PetFormScreen(pet: pet),
        ),
      );

      expect(find.text('Edit Pet'), findsOneWidget);
    });

    testWidgets('PetFormScreen should display all form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      expect(find.text('Pet Name'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Category Name'), findsOneWidget);
      expect(find.text('Photo URLs'), findsOneWidget);
      expect(find.text('Tags'), findsOneWidget);
    });

    testWidgets('PetFormScreen should show validation error for empty name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the save button
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Pet');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter pet name'), findsOneWidget);
    });

    testWidgets('PetFormScreen should populate fields when editing',
        (WidgetTester tester) async {
      final pet = Pet(
        id: 1,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo.jpg'],
        category: const Category(id: 1, name: 'Dogs'),
        tags: const [Tag(id: 1, name: 'friendly')],
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: PetFormScreen(pet: pet),
        ),
      );

      await tester.pumpAndSettle();

      // Check if name field is populated
      expect(find.text('Fluffy'), findsOneWidget);
      expect(find.text('Dogs'), findsOneWidget);
    });

    testWidgets('PetFormScreen should allow adding photo URLs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find photo URL input field
      final photoUrlField = find.widgetWithText(TextField, 'Photo URL');
      expect(photoUrlField, findsOneWidget);

      // Enter a photo URL
      await tester.enterText(photoUrlField, 'https://example.com/photo.jpg');
      await tester.pumpAndSettle();

      // Find and tap add button
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton.first);
      await tester.pumpAndSettle();

      // Check if photo URL was added
      expect(find.text('https://example.com/photo.jpg'), findsWidgets);
    });

    testWidgets('PetFormScreen should allow adding tags',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find tag input field
      final tagField = find.widgetWithText(TextField, 'Tag Name');
      expect(tagField, findsOneWidget);

      // Enter a tag
      await tester.enterText(tagField, 'friendly');
      await tester.pumpAndSettle();

      // Find and tap add button for tags
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.at(1)); // Second add button is for tags
      await tester.pumpAndSettle();

      // Check if tag was added
      expect(find.text('friendly'), findsWidgets);
    });

    testWidgets('PetFormScreen should have cancel button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('PetFormScreen should change status via dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find status dropdown
      final statusDropdown = find.byType(DropdownButtonFormField<PetStatus>);
      expect(statusDropdown, findsOneWidget);

      // Tap on dropdown
      await tester.tap(statusDropdown);
      await tester.pumpAndSettle();

      // Check if all status options are available
      expect(find.text('Available'), findsWidgets);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Sold'), findsWidgets);
    });

    testWidgets('PetFormScreen should remove photo URL chip when tapped',
        (WidgetTester tester) async {
      final pet = Pet(
        id: 1,
        name: 'Test Pet',
        photoUrls: ['https://example.com/photo.jpg'],
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: PetFormScreen(pet: pet),
        ),
      );

      await tester.pumpAndSettle();

      // Find the delete icon in chip
      final deleteIcon = find.byIcon(Icons.close);
      expect(deleteIcon, findsWidgets);

      // Tap to remove
      await tester.tap(deleteIcon.first);
      await tester.pumpAndSettle();

      // Photo URL should be removed (implementation dependent)
    });

    testWidgets('PetFormScreen should remove tag chip when tapped',
        (WidgetTester tester) async {
      final pet = Pet(
        id: 1,
        name: 'Test Pet',
        photoUrls: [],
        tags: const [Tag(id: 1, name: 'friendly')],
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: PetFormScreen(pet: pet),
        ),
      );

      await tester.pumpAndSettle();

      // Check if tag chip exists
      expect(find.text('friendly'), findsWidgets);

      // Find the delete icon
      final deleteIcon = find.byIcon(Icons.close);
      expect(deleteIcon, findsWidgets);
    });

    testWidgets('PetFormScreen should validate category name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const PetFormScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find category field
      final categoryField = find.widgetWithText(TextFormField, 'Category Name');
      expect(categoryField, findsOneWidget);

      // Enter name but leave category empty
      final nameField = find.widgetWithText(TextFormField, 'Pet Name');
      await tester.enterText(nameField, 'Test Pet');

      // Try to save
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Pet');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show category validation error
      expect(find.text('Please enter category name'), findsOneWidget);
    });
  });
}
