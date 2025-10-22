import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'order.g.dart';

enum OrderStatus { placed, approved, delivered }

@JsonSerializable()
class Order extends Equatable {
  final int? id;
  final int? petId;
  final int? quantity;
  final DateTime? shipDate;
  @JsonKey(unknownEnumValue: OrderStatus.placed)
  final OrderStatus? status;
  final bool? complete;

  const Order({
    this.id,
    this.petId,
    this.quantity,
    this.shipDate,
    this.status,
    this.complete,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith({
    int? id,
    int? petId,
    int? quantity,
    DateTime? shipDate,
    OrderStatus? status,
    bool? complete,
  }) {
    return Order(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      quantity: quantity ?? this.quantity,
      shipDate: shipDate ?? this.shipDate,
      status: status ?? this.status,
      complete: complete ?? this.complete,
    );
  }

  @override
  List<Object?> get props => [id, petId, quantity, shipDate, status, complete];
}
