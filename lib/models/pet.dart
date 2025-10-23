import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:atomepet/models/category.dart';
import 'package:atomepet/models/tag.dart';

part 'pet.g.dart';

enum PetStatus { available, pending, sold }

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Pet extends Equatable {
  final int? id;
  final String? name;
  final Category? category;
  final List<String>? photoUrls;
  final List<Tag>? tags;
  @JsonKey(unknownEnumValue: PetStatus.available)
  final PetStatus? status;

  const Pet({
    this.id,
    this.name,
    this.category,
    this.photoUrls,
    this.tags,
    this.status,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  Pet copyWith({
    int? id,
    String? name,
    Category? category,
    List<String>? photoUrls,
    List<Tag>? tags,
    PetStatus? status,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      photoUrls: photoUrls ?? this.photoUrls,
      tags: tags ?? this.tags,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, name, category, photoUrls, tags, status];
}
