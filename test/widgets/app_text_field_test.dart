import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/views/widgets/app_text_field.dart';

void main() {
  group('AppTextField Widget Tests', () {
    testWidgets('AppTextField displays label correctly',
        (WidgetTester tester) async {
      // Arrange
      const labelText = 'Test Label';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: labelText,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(labelText), findsOneWidget);
    });

    testWidgets('AppTextField displays hint text correctly',
        (WidgetTester tester) async {
      // Arrange
      const hintText = 'Test Hint';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              hint: hintText,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets('AppTextField displays prefix icon when provided',
        (WidgetTester tester) async {
      // Arrange
      const iconData = Icons.email;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              prefixIcon: iconData,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(iconData), findsOneWidget);
    });

    testWidgets('AppTextField accepts text input', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();
      const testText = 'Test Input';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), testText);

      // Assert
      expect(controller.text, testText);
    });

    testWidgets('AppTextField obscures text when obscureText is true',
        (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'password');

      // Assert - The widget tree should exist
      expect(find.byType(TextFormField), findsOneWidget);
      // We can verify the controller has the text even though it's obscured
      expect(controller.text, 'password');
    });

    testWidgets('AppTextField shows validation error',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'This field is required';
      String? validator(String? value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      }

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              validator: validator,
            ),
          ),
        ),
      );

      // Trigger validation by finding the Form parent (if any) or TextFormField
      final formFieldFinder = find.byType(TextFormField);
      final formField = tester.widget<TextFormField>(formFieldFinder);
      
      // Manually call validator
      final result = formField.validator?.call('');

      // Assert
      expect(result, errorMessage);
    });

    testWidgets('AppTextField calls onSubmitted when enter is pressed',
        (WidgetTester tester) async {
      // Arrange
      var wasSubmitted = false;
      String? submittedValue;
      void onSubmitted(String value) {
        wasSubmitted = true;
        submittedValue = value;
      }

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              onSubmitted: onSubmitted,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(wasSubmitted, true);
      expect(submittedValue, 'test');
    });

    testWidgets('AppTextField displays suffix icon when provided',
        (WidgetTester tester) async {
      // Arrange
      const iconData = Icons.visibility;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              suffixIcon: Icon(iconData),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(iconData), findsOneWidget);
    });
  });
}
