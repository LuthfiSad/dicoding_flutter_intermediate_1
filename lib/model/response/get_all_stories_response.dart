import 'package:json_annotation/json_annotation.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';
import 'package:intermediate_flutter/model/story.dart';

part 'get_all_stories_response.g.dart';

@JsonSerializable()
class GetAllStoriesResponse {
  bool error;
  String message;
  List<Story> listStory;

  GetAllStoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetAllStoriesResponse.fromRawJson(Map<String, dynamic> json) =>
      _$GetAllStoriesResponseFromJson(json);

  Map<String, dynamic> toRawJson() => _$GetAllStoriesResponseToJson(this);

  factory GetAllStoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json).getErrorMessage();
    } else {
      return _$GetAllStoriesResponseFromJson(json);
    }
  }

  factory GetAllStoriesResponse.failure(String message) =>
      GetAllStoriesResponse(
        error: true,
        message: message,
        listStory: [],
      );

  factory GetAllStoriesResponse.success(List<Story> listStory) =>
      GetAllStoriesResponse(
        error: false,
        message: 'Success',
        listStory: listStory,
      );

  Map<String, dynamic> toJson() => _$GetAllStoriesResponseToJson(this);
}
