import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: '_id', includeIfNull: false)
  String? id;

  @JsonKey(includeIfNull: false)
  String? password;

  @JsonKey(includeIfNull: false)
  String? username;

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

  @JsonKey(includeIfNull: false)
  String? profilePicture;

  @JsonKey(includeIfNull: false)
  List<String>? role;

  User(
      {this.id,
      this.username,
      this.password,
      this.following,
      this.follower,
      this.fullName,
      this.posts,
      this.penddingPosts,
      this.bookmarkPosts,
      this.profilePicture,
      this.journals,
      this.pendingJournal,
      this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  User copyWith(
      {username,
      password,
      following,
      follower,
      posts,
      fullName,
      penddingPosts,
      bookmarkPosts,
      profilePicture,
      journals,
      pendingJournal,
      role}) {
    return User(
        id: id,
        username: username ?? this.username,
        password: password ?? this.password,
        following: following ?? this.following,
        follower: follower ?? this.follower,
        fullName: fullName ?? this.fullName,
        posts: posts ?? this.posts,
        penddingPosts: penddingPosts ?? this.penddingPosts,
        bookmarkPosts: bookmarkPosts ?? this.bookmarkPosts,
        profilePicture: profilePicture ?? this.profilePicture,
        journals: journals ?? this.journals,
        pendingJournal: pendingJournal ?? this.pendingJournal,
        role: role ?? this.role);
  }

  Map<String, dynamic> toMap() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is List) {
          value = jsonEncode(value);
        }
        val[key] = value;
      }
    }

    writeNotNull('_id', id);
    writeNotNull('password', password);
    writeNotNull('username', username);
    writeNotNull('fullName', fullName);
    writeNotNull('following', following);
    writeNotNull('follower', follower);
    writeNotNull('posts', posts);
    writeNotNull('penddingPosts', penddingPosts);
    writeNotNull('journals', journals);
    writeNotNull('pendingJournal', pendingJournal);
    writeNotNull('bookmarkPosts', bookmarkPosts);
    writeNotNull('profilePicture', profilePicture);
    writeNotNull('role', role);
    return val;
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['_id'] as String?,
        username: json['username'] as String?,
        password: json['password'] as String?,
        following: (jsonDecode(json['following']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        follower: (jsonDecode(json['follower']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        fullName: json['fullName'] as String?,
        posts: (jsonDecode(json['posts']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        penddingPosts: (jsonDecode(json['penddingPosts']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        bookmarkPosts: (jsonDecode(json['bookmarkPosts']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        profilePicture: json['profilePicture'] as String?,
        journals: (jsonDecode(json['journals']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        pendingJournal: (jsonDecode(json['pendingJournal']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        role: (jsonDecode(json['role']) as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props =>
      [id, password, following, follower, posts, bookmarkPosts, profilePicture];
}
