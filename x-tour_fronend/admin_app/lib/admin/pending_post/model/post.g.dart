// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Posts _$PostsFromJson(Map<String, dynamic> json) => Posts(
      id: json['_id'] as String?,
      story: json['story'] as String,
      description: json['description'] as String,
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      creatorId: json['creatorId'] == null
          ? null
          : User.fromJson(json['creatorId'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PostsToJson(Posts instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['story'] = instance.story;
  val['description'] = instance.description;
  writeNotNull('likes', instance.likes?.map((e) => e.toJson()).toList());
  writeNotNull('creatorId', instance.creatorId?.toJson());
  writeNotNull('images', instance.images);
  writeNotNull('comments', instance.comments);
  return val;
}
