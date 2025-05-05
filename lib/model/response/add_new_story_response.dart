import 'package:json_annotation/json_annotation.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';

part 'add_new_story_response.g.dart';

@JsonSerializable()
class AddNewStoryRepsonse {
  bool error;
  String message;

  AddNewStoryRepsonse({
    required this.error,
    required this.message,
  });

  factory AddNewStoryRepsonse.fromRawJson(Map<String, dynamic> json) =>
      _$AddNewStoryRepsonseFromJson(json);

  Map<String, dynamic> toRawJson() => _$AddNewStoryRepsonseToJson(this);

  factory AddNewStoryRepsonse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json);
    } else {
      return _$AddNewStoryRepsonseFromJson(json);
    }
  }

  factory AddNewStoryRepsonse.failure(String message) => AddNewStoryRepsonse(
        error: true,
        message: message,
      );

  factory AddNewStoryRepsonse.success() => AddNewStoryRepsonse(
        error: false,
        message: 'Success',
      );

  Map<String, dynamic> toJson() => _$AddNewStoryRepsonseToJson(this);
}
