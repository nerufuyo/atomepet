import 'package:flutter_test/flutter_test.dart';
import 'package:atomepet/models/order.dart';

void main() {
  group('Order Model Tests', () {
    test('Order fromJson should create valid Order object', () {
      // Arrange
      final json = {
        'id': 1,
        'petId': 123,
        'quantity': 2,
        'shipDate': '2024-01-15T10:30:00.000Z',
        'status': 'approved',
        'complete': true,
      };

      // Act
      final order = Order.fromJson(json);

      // Assert
      expect(order.id, 1);
      expect(order.petId, 123);
      expect(order.quantity, 2);
      expect(order.shipDate, isA<DateTime>());
      expect(order.status, OrderStatus.approved);
      expect(order.complete, true);
    });

    test('Order toJson should create valid JSON', () {
      // Arrange
      final order = Order(
        id: 1,
        petId: 123,
        quantity: 2,
        shipDate: DateTime(2024, 1, 15),
        status: OrderStatus.delivered,
        complete: true,
      );

      // Act
      final json = order.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['petId'], 123);
      expect(json['quantity'], 2);
      expect(json['shipDate'], isA<String>());
      expect(json['status'], 'delivered');
      expect(json['complete'], true);
    });

    test('Order copyWith should create new instance with updated values', () {
      // Arrange
      final order = Order(
        id: 1,
        petId: 123,
        quantity: 2,
        status: OrderStatus.placed,
        complete: false,
      );

      // Act
      final updatedOrder = order.copyWith(
        status: OrderStatus.approved,
        complete: true,
      );

      // Assert
      expect(updatedOrder.id, 1);
      expect(updatedOrder.petId, 123);
      expect(updatedOrder.quantity, 2);
      expect(updatedOrder.status, OrderStatus.approved);
      expect(updatedOrder.complete, true);
      // Original should remain unchanged
      expect(order.status, OrderStatus.placed);
      expect(order.complete, false);
    });

    test('Order equality should work correctly', () {
      // Arrange
      final order1 = Order(
        id: 1,
        petId: 123,
        quantity: 2,
        status: OrderStatus.placed,
      );

      final order2 = Order(
        id: 1,
        petId: 123,
        quantity: 2,
        status: OrderStatus.placed,
      );

      final order3 = Order(
        id: 2,
        petId: 123,
        quantity: 2,
        status: OrderStatus.placed,
      );

      // Assert
      expect(order1, equals(order2));
      expect(order1, isNot(equals(order3)));
    });

    test('OrderStatus enum should have correct values', () {
      expect(OrderStatus.placed.name, 'placed');
      expect(OrderStatus.approved.name, 'approved');
      expect(OrderStatus.delivered.name, 'delivered');
    });

    test('Order with null optional fields should work', () {
      // Arrange & Act
      final order = const Order();

      // Assert
      expect(order.id, isNull);
      expect(order.petId, isNull);
      expect(order.quantity, isNull);
      expect(order.shipDate, isNull);
      expect(order.status, isNull);
      expect(order.complete, isNull);
    });

    test('Order fromJson with unknown status should default to placed', () {
      // Arrange
      final json = {
        'id': 1,
        'petId': 123,
        'status': 'unknown_status',
      };

      // Act
      final order = Order.fromJson(json);

      // Assert
      expect(order.status, OrderStatus.placed);
    });
  });
}
