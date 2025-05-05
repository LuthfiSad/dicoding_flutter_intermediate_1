import 'package:json_annotation/json_annotation.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromRawJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toRawJson() => _$RegisterResponseToJson(this);

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['error'] == true) {
        throw ErrorResponse.fromJson(json).getErrorMessage();
      } else {
        return _$RegisterResponseFromJson(json);
      }
    } catch (e) {
      return _$RegisterResponseFromJson({
        'error': true,
        'message': 'Parse error',
      });
    }
  }

  factory RegisterResponse.failure(String message) => RegisterResponse(
        error: true,
        message: message,
      );

  factory RegisterResponse.success() => RegisterResponse(
        error: false,
        message: 'Success',
      );

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
