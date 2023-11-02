import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../user/models/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment extends Equatable {
  @JsonKey(name: "_id", includeIfNull: false)
  String? id;

  @JsonKey(name: "commenterId", includeIfNull: false)
  User? user;

  String? replyId;
  String? postId;

  String message;

  Comment(
      {this.id, this.user, this.replyId, this.postId, required this.message});
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [id, user, replyId, postId, message];
}
