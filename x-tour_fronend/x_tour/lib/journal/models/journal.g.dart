// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journal _$JournalFromJson(Map<String, dynamic> json) => Journal(
      id: json['_id'] as String?,
      creator: json['creator_id'] == null
          ? null
          : User.fromJson(json['creator_id'] as Map<String, dynamic>),
      title: json['title'] as String,
      link: json['link'] as String,
      image: json['image'] as String?,
      description: json['description'] as String,
    );

Map<String, dynamic> _$JournalToJson(Journal instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('creator_id', instance.creator);
  val['title'] = instance.title;
  val['link'] = instance.link;
  writeNotNull('image', instance.image);
  val['description'] = instance.description;
  return val;
}
