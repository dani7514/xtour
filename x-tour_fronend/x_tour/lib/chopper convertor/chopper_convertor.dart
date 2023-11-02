import 'package:chopper/chopper.dart';
import 'dart:convert';

import 'package:x_tour/journal/models/journal.dart';
import 'package:x_tour/posts/models/post.dart';

import '../comment/models/comment.dart';
import '../user/models/user.dart';

class ChopperConvetor extends JsonConverter {
  final Map<Type, Function> jsonToTypeFactoryMap = {
    Journal: Journal.fromJson,
    Posts: Posts.fromJson,
    User: User.fromJson,
    Comment: Comment.fromJson,
    Map<String, dynamic>: (e) => e
  };

  ChopperConvetor();

  @override
  Request convertRequest(Request request) {
    var body = request.body;
    try {
      body = request.body.toJson() as Map<String, dynamic>;
    } catch (_) {}
    return super.convertRequest(request.copyWith(body: body));
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return response.copyWith(
      body: fromJsonData<BodyType, InnerType>(
          response.body, jsonToTypeFactoryMap[InnerType] ?? (e) => e),
    );
  }

  T fromJsonData<T, InnerType>(String jsonData, Function jsonParser) {
    var jsonMap = json.decode(jsonData);

    if (jsonMap is List) {
      return jsonMap
          .map((item) => jsonParser(item as Map<String, dynamic>) as InnerType)
          .toList() as T;
    }

    return jsonParser(jsonMap);
  }
}
