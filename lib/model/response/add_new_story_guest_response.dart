import 'package:json_annotation/json_annotation.dart';

part 'add_new_story_guest_response.g.dart';

@JsonSerializable()
class AddNewStoryRepsonseGuest {
  bool error;
  String message;

  AddNewStoryRepsonseGuest({
    required this.error,
    required this.message,
  });

  factory AddNewStoryRepsonseGuest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AddNewStoryRepsonseGuestFromJson(json);

  Map<String, dynamic> toJson() => _$AddNewStoryRepsonseGuestToJson(this);

  factory AddNewStoryRepsonseGuest.failure(String message) =>
      AddNewStoryRepsonseGuest(
        error: true,
        message: message,
      );

  bool getSuccess() {
    return !error;
  }

  String getMessage() {
    return message;
  }
}
