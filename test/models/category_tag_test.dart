import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/models/category.dart';
import 'package:atomepet/models/tag.dart';

void main() {
  group('Category Model Tests', () {
    test('Category fromJson should create valid Category object', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Dogs',
      };

      // Act
      final category = Category.fromJson(json);

      // Assert
      expect(category.id, 1);
      expect(category.name, 'Dogs');
    });

    test('Category toJson should create valid JSON', () {
      // Arrange
      const category = Category(id: 1, name: 'Dogs');

      // Act
      final json = category.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'Dogs');
    });

    test('Category equality should work correctly', () {
      // Arrange
      const category1 = Category(id: 1, name: 'Dogs');
      const category2 = Category(id: 1, name: 'Dogs');
      const category3 = Category(id: 2, name: 'Dogs');

      // Assert
      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });

    test('Category with null fields should work', () {
      // Arrange & Act
      const category = Category();

      // Assert
      expect(category.id, isNull);
      expect(category.name, isNull);
    });
  });

  group('Tag Model Tests', () {
    test('Tag fromJson should create valid Tag object', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'friendly',
      };

      // Act
      final tag = Tag.fromJson(json);

      // Assert
      expect(tag.id, 1);
      expect(tag.name, 'friendly');
    });

    test('Tag toJson should create valid JSON', () {
      // Arrange
      const tag = Tag(id: 1, name: 'friendly');

      // Act
      final json = tag.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'friendly');
    });

    test('Tag equality should work correctly', () {
      // Arrange
      const tag1 = Tag(id: 1, name: 'friendly');
      const tag2 = Tag(id: 1, name: 'friendly');
      const tag3 = Tag(id: 2, name: 'friendly');

      // Assert
      expect(tag1, equals(tag2));
      expect(tag1, isNot(equals(tag3)));
    });

    test('Tag with null fields should work', () {
      // Arrange & Act
      const tag = Tag();

      // Assert
      expect(tag.id, isNull);
      expect(tag.name, isNull);
    });

    test('Multiple tags can be created', () {
      // Arrange & Act
      const tags = [
        Tag(id: 1, name: 'friendly'),
        Tag(id: 2, name: 'vaccinated'),
        Tag(id: 3, name: 'trained'),
      ];

      // Assert
      expect(tags.length, 3);
      expect(tags[0].name, 'friendly');
      expect(tags[1].name, 'vaccinated');
      expect(tags[2].name, 'trained');
    });
  });
}
