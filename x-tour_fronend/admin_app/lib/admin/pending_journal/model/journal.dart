import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:x_tour/admin/user/model/user.dart';

part 'journal.g.dart';

@JsonSerializable()
class Journal extends Equatable {
  @JsonKey(name: "_id", includeIfNull: false)
  String? id;

  @JsonKey(name: "creator_id", includeIfNull: false)
  User? creator;

  String title;

  String link;

  @JsonKey(includeIfNull: false)
  String? image;

  String description;

  Journal({
    this.id,
    this.creator,
    required this.title,
    required this.link,
    this.image,
    required this.description,
  });

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
  Map<String, dynamic> toJson() => _$JournalToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [id, creator, title, link, image, description];
}
