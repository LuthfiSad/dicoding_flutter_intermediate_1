import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  bool error;
  String message;

  ErrorResponse({
    required this.error,
    required this.message,
  });

  factory ErrorResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  String getErrorMessage() {
    return message;
  }

  bool getErrorStatus() {
    return error;
  }
}
