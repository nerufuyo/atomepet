// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecodeNullable(_$PetStatusEnumMap, json['status'],
          unknownValue: PetStatus.available),
    );

Map<String, dynamic> _$PetToJson(Pet instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('category', instance.category?.toJson());
  val['photoUrls'] = instance.photoUrls;
  writeNotNull('tags', instance.tags?.map((e) => e.toJson()).toList());
  writeNotNull('status', _$PetStatusEnumMap[instance.status]);
  return val;
}

const _$PetStatusEnumMap = {
  PetStatus.available: 'available',
  PetStatus.pending: 'pending',
  PetStatus.sold: 'sold',
};
