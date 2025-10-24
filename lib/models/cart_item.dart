import 'package:atomepet/models/pet.dart';

class CartItem {
  final Pet pet;
  int quantity;
  final double price;

  CartItem({
    required this.pet,
    this.quantity = 1,
    required this.price,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    Pet? pet,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      pet: pet ?? this.pet,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet': pet.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
