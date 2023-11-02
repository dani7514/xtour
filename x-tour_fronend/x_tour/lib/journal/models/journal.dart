// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../user/models/user.dart';

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

  factory Journal.fromMap(Map<String, dynamic> json) => Journal(
        id: json['_id'] as String?,
        creator: json['creator_id'] == null
            ? null
            : User.fromJson(
                jsonDecode(json['creator_id']) as Map<String, dynamic>),
        title: json['title'] as String,
        link: json['link'] as String,
        image: json['image'] as String?,
        description: json['description'] as String,
      );

  Map<String, dynamic> toMap() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('_id', id);
    writeNotNull('creator_id', jsonEncode(creator));
    val['title'] = title;
    val['link'] = link;
    writeNotNull('image', image);
    val['description'] = description;
    return val;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [id, creator, title, link, image, description];
}
