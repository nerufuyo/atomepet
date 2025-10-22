// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num?)?.toInt(),
      petId: (json['petId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      shipDate: json['shipDate'] == null
          ? null
          : DateTime.parse(json['shipDate'] as String),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status'],
          unknownValue: OrderStatus.placed),
      complete: json['complete'] as bool?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('petId', instance.petId);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('shipDate', instance.shipDate?.toIso8601String());
  writeNotNull('status', _$OrderStatusEnumMap[instance.status]);
  writeNotNull('complete', instance.complete);
  return val;
}

const _$OrderStatusEnumMap = {
  OrderStatus.placed: 'placed',
  OrderStatus.approved: 'approved',
  OrderStatus.delivered: 'delivered',
};
