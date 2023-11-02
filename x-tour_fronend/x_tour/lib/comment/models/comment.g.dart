// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['_id'] as String?,
      user: json['commenterId'] == null
          ? null
          : User.fromJson(json['commenterId'] as Map<String, dynamic>),
      replyId: json['replyId'] as String?,
      postId: json['postId'] as String?,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('commenterId', instance.user?.toJson());
  val['replyId'] = instance.replyId;
  val['postId'] = instance.postId;
  val['message'] = instance.message;
  return val;
}
