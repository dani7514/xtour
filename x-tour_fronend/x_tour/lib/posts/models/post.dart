// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../user/models/user.dart';
import 'package:x_tour/comment/models/comment.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Posts extends Equatable {
  @JsonKey(name: "_id", includeIfNull: false)
  String? id;

  String story;

  String description;

  @JsonKey(includeIfNull: false)
  List<User>? likes;

  @JsonKey(includeIfNull: false)
  User? creatorId;

  @JsonKey(includeIfNull: false)
  List<String>? images;

  @JsonKey(includeIfNull: false)
  List<Comment>? comments;

  Posts(
      {this.id,
      required this.story,
      required this.description,
      this.likes,
      this.creatorId,
      this.images,
      this.comments});

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);
  Map<String, dynamic> toJson() => _$PostsToJson(this);

  factory Posts.fromMap(Map<String, dynamic> json) => Posts(
        id: json['_id'] as String?,
        story: json['story'] as String,
        description: json['description'] as String,
        likes: (json['likes'] as List<dynamic>?)
            ?.map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
        creatorId: json['creatorId'] == null
            ? null
            : User.fromJson(json['creatorId'] as Map<String, dynamic>),
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        comments: (json['comments'] as List<dynamic>?)
            ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  Map<String, dynamic> toMap() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('_id', id);
    val['story'] = story;
    val['description'] = description;
    writeNotNull('likes', likes?.map((e) => e.toJson()).toList());
    writeNotNull('creatorId', creatorId?.toJson());
    writeNotNull('images', images);
    writeNotNull('comments', comments?.map((e) => e.toJson()).toList());
    return val;
  }

  Posts copyWith({story, description, likes, creator, images, comments}) {
    return Posts(
        id: id,
        story: story ?? this.story,
        description: description ?? this.description,
        likes: likes ?? this.likes,
        creatorId: creator ?? this.creatorId,
        images: images ?? this.images,
        comments: comments ?? this.comments);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [id, story, description, likes, creatorId, images];
}
