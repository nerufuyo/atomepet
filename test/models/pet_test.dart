import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/category.dart';
import 'package:atomepet/models/tag.dart';

void main() {
  group('Pet Model Tests', () {
    test('Pet fromJson should create valid Pet object', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Fluffy',
        'status': 'available',
        'photoUrls': ['https://example.com/photo1.jpg'],
        'category': {'id': 1, 'name': 'Dogs'},
        'tags': [
          {'id': 1, 'name': 'friendly'},
          {'id': 2, 'name': 'vaccinated'}
        ],
      };

      // Act
      final pet = Pet.fromJson(json);

      // Assert
      expect(pet.id, 1);
      expect(pet.name, 'Fluffy');
      expect(pet.status, PetStatus.available);
      expect(pet.photoUrls.length, 1);
      expect(pet.photoUrls.first, 'https://example.com/photo1.jpg');
      expect(pet.category?.name, 'Dogs');
      expect(pet.tags?.length, 2);
      expect(pet.tags?.first.name, 'friendly');
    });

    test('Pet toJson should create valid JSON', () {
      // Arrange
      final pet = Pet(
        id: 1,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo1.jpg'],
        category: const Category(id: 1, name: 'Dogs'),
        tags: const [
          Tag(id: 1, name: 'friendly'),
          Tag(id: 2, name: 'vaccinated'),
        ],
      );

      // Act
      final json = pet.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'Fluffy');
      expect(json['status'], 'available');
      expect(json['photoUrls'], ['https://example.com/photo1.jpg']);
      expect(json['category'], isNotNull);
      expect(json['category'], isA<Category>());
      expect(json['tags'], isNotNull);
      expect(json['tags'], isA<List>());
      expect(json['tags'].length, 2);
    });

    test('Pet copyWith should create new instance with updated values', () {
      // Arrange
      final pet = Pet(
        id: 1,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo1.jpg'],
      );

      // Act
      final updatedPet = pet.copyWith(
        name: 'Fluffy Jr.',
        status: PetStatus.sold,
      );

      // Assert
      expect(updatedPet.id, 1);
      expect(updatedPet.name, 'Fluffy Jr.');
      expect(updatedPet.status, PetStatus.sold);
      expect(updatedPet.photoUrls, ['https://example.com/photo1.jpg']);
      // Original should remain unchanged
      expect(pet.name, 'Fluffy');
      expect(pet.status, PetStatus.available);
    });

    test('Pet equality should work correctly', () {
      // Arrange
      final pet1 = Pet(
        id: 1,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo1.jpg'],
      );

      final pet2 = Pet(
        id: 1,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo1.jpg'],
      );

      final pet3 = Pet(
        id: 2,
        name: 'Fluffy',
        status: PetStatus.available,
        photoUrls: ['https://example.com/photo1.jpg'],
      );

      // Assert
      expect(pet1, equals(pet2));
      expect(pet1, isNot(equals(pet3)));
    });

    test('PetStatus enum should have correct values', () {
      expect(PetStatus.available.name, 'available');
      expect(PetStatus.pending.name, 'pending');
      expect(PetStatus.sold.name, 'sold');
    });

    test('Pet with null optional fields should work', () {
      // Arrange & Act
      final pet = Pet(
        name: 'Fluffy',
        photoUrls: [],
      );

      // Assert
      expect(pet.id, isNull);
      expect(pet.category, isNull);
      expect(pet.tags, isNull);
      expect(pet.status, isNull);
      expect(pet.name, 'Fluffy');
      expect(pet.photoUrls, isEmpty);
    });

    test('Pet fromJson with missing optional fields should work', () {
      // Arrange
      final json = {
        'name': 'Fluffy',
        'photoUrls': [],
      };

      // Act
      final pet = Pet.fromJson(json);

      // Assert
      expect(pet.name, 'Fluffy');
      expect(pet.id, isNull);
      expect(pet.category, isNull);
      expect(pet.tags, isNull);
    });
  });
}
