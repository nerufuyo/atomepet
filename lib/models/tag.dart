import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag extends Equatable {
  final int? id;
  final String? name;

  const Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  Tag copyWith({int? id, String? name}) {
    return Tag(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}
