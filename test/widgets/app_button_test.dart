import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/views/widgets/app_button.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('AppButton displays text correctly', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Test Button';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('AppButton calls onPressed when tapped',
        (WidgetTester tester) async {
      // Arrange
      var wasPressed = false;
      void onPressed() => wasPressed = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: onPressed,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });

    testWidgets('AppButton displays icon when provided',
        (WidgetTester tester) async {
      // Arrange
      const iconData = Icons.add;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              icon: iconData,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(iconData), findsOneWidget);
    });

    testWidgets('AppButton shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppButton is disabled when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      var wasPressed = false;
      void onPressed() => wasPressed = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: onPressed,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, false);
    });

    testWidgets('AppButton displays outlined style when isOutlined is true',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              isOutlined: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('AppButton displays elevated style by default',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
