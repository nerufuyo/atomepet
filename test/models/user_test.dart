import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User fromJson should create valid User object', () {
      // Arrange
      final json = {
        'id': 1,
        'username': 'testuser',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'password': 'password123',
        'phone': '+1234567890',
        'userStatus': 1,
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john@example.com');
      expect(user.password, 'password123');
      expect(user.phone, '+1234567890');
      expect(user.userStatus, 1);
    });

    test('User toJson should create valid JSON', () {
      // Arrange
      final user = User(
        id: 1,
        username: 'testuser',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        phone: '+1234567890',
        userStatus: 1,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['username'], 'testuser');
      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Doe');
      expect(json['email'], 'john@example.com');
      expect(json['password'], 'password123');
      expect(json['phone'], '+1234567890');
      expect(json['userStatus'], 1);
    });

    test('User copyWith should create new instance with updated values', () {
      // Arrange
      final user = User(
        id: 1,
        username: 'testuser',
        email: 'john@example.com',
        userStatus: 1,
      );

      // Act
      final updatedUser = user.copyWith(
        firstName: 'Jane',
        email: 'jane@example.com',
      );

      // Assert
      expect(updatedUser.id, 1);
      expect(updatedUser.username, 'testuser');
      expect(updatedUser.firstName, 'Jane');
      expect(updatedUser.email, 'jane@example.com');
      expect(updatedUser.userStatus, 1);
      // Original should remain unchanged
      expect(user.firstName, isNull);
      expect(user.email, 'john@example.com');
    });

    test('User equality should work correctly', () {
      // Arrange
      final user1 = User(
        id: 1,
        username: 'testuser',
        email: 'john@example.com',
      );

      final user2 = User(
        id: 1,
        username: 'testuser',
        email: 'john@example.com',
      );

      final user3 = User(
        id: 2,
        username: 'testuser',
        email: 'john@example.com',
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('User with null optional fields should work', () {
      // Arrange & Act
      final user = User(
        username: 'testuser',
      );

      // Assert
      expect(user.username, 'testuser');
      expect(user.id, isNull);
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.email, isNull);
      expect(user.password, isNull);
      expect(user.phone, isNull);
      expect(user.userStatus, isNull);
    });

    test('User fromJson with missing optional fields should work', () {
      // Arrange
      final json = {
        'username': 'testuser',
        'email': 'john@example.com',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.username, 'testuser');
      expect(user.email, 'john@example.com');
      expect(user.id, isNull);
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
    });

    test('User with active status should be valid', () {
      // Arrange & Act
      final user = User(
        username: 'testuser',
        userStatus: 1,
      );

      // Assert
      expect(user.userStatus, 1);
    });

    test('User with inactive status should be valid', () {
      // Arrange & Act
      final user = User(
        username: 'testuser',
        userStatus: 0,
      );

      // Assert
      expect(user.userStatus, 0);
    });
  });
}
