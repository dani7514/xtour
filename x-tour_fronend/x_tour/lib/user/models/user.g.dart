// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      follower: (json['follower'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      fullName: json['fullName'] as String?,
      posts:
          (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList(),
      penddingPosts: (json['penddingPosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bookmarkPosts: (json['bookmarkPosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profilePicture: json['profilePicture'] as String?,
      journals: (json['journals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pendingJournal: (json['pendingJournal'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      role: (json['role'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('password', instance.password);
  writeNotNull('username', instance.username);
  writeNotNull('fullName', instance.fullName);
  writeNotNull('following', instance.following);
  writeNotNull('follower', instance.follower);
  writeNotNull('posts', instance.posts);
  writeNotNull('penddingPosts', instance.penddingPosts);
  writeNotNull('journals', instance.journals);
  writeNotNull('pendingJournal', instance.pendingJournal);
  writeNotNull('bookmarkPosts', instance.bookmarkPosts);
  writeNotNull('profilePicture', instance.profilePicture);
  writeNotNull('role', instance.role);
  return val;
}
