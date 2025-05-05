import 'package:json_annotation/json_annotation.dart';
import 'package:intermediate_flutter/model/detail_story.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';

part 'get_detail_story_response.g.dart';

@JsonSerializable()
class GetDetailStoryRepsonse {
  bool error;
  String message;
  DetailStory story;

  GetDetailStoryRepsonse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory GetDetailStoryRepsonse.fromRawJson(Map<String, dynamic> json) =>
      _$GetDetailStoryRepsonseFromJson(json);

  Map<String, dynamic> toRawJson() => _$GetDetailStoryRepsonseToJson(this);

  factory GetDetailStoryRepsonse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json).getErrorMessage();
    } else {
      return _$GetDetailStoryRepsonseFromJson(json);
    }
  }

  factory GetDetailStoryRepsonse.failure(String message) =>
      GetDetailStoryRepsonse(
        error: true,
        message: message,
        story: DetailStory(
          id: '',
          description: '',
          createdAt: DateTime.now(),
          name: '',
          photoUrl: '',
          lat: 0,
          lon: 0,
        ),
      );

  factory GetDetailStoryRepsonse.success(DetailStory story) =>
      GetDetailStoryRepsonse(
        error: false,
        message: 'Success',
        story: story,
      );

  Map<String, dynamic> toJson() => _$GetDetailStoryRepsonseToJson(this);
}
