import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: '_id', includeIfNull: false)
  String? id;

  @JsonKey(includeIfNull: false)
  String? password;

  String username;

  @JsonKey(includeIfNull: false)
  String? fullName;

  @JsonKey(includeIfNull: false)
  List<String>? following;

  @JsonKey(includeIfNull: false)
  List<String>? follower;

  @JsonKey(includeIfNull: false)
  List<String>? posts;

  @JsonKey(includeIfNull: false)
  List<String>? penddingPosts;

  @JsonKey(includeIfNull: false)
  List<String>? journals;

  @JsonKey(includeIfNull: false)
  List<String>? pendingJournal;

  @JsonKey(includeIfNull: false)
  List<String>? bookmarkPosts;

  String? profilePicture;

  User(
      {this.id,
      required this.username,
      this.password,
      this.following,
      this.follower,
      this.posts,
      this.penddingPosts,
      this.bookmarkPosts,
      this.profilePicture,
      this.journals,
      this.pendingJournal});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  User copyWith(
      {username,
      password,
      following,
      follower,
      posts,
      penddingPosts,
      bookmarkPosts,
      profilePicture,
      journals,
      pendingJournal}) {
    return User(
        id: id,
        username: username ?? this.username,
        password: password ?? this.password,
        following: following ?? this.following,
        follower: follower ?? this.follower,
        posts: posts ?? this.posts,
        penddingPosts: penddingPosts ?? this.penddingPosts,
        bookmarkPosts: bookmarkPosts ?? this.bookmarkPosts,
        profilePicture: profilePicture ?? this.profilePicture,
        journals: journals ?? this.journals,
        pendingJournal: pendingJournal ?? this.pendingJournal);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props =>
      [id, password, following, follower, posts, bookmarkPosts, profilePicture];
}
