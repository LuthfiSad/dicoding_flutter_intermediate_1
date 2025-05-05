import 'package:json_annotation/json_annotation.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';
import 'package:intermediate_flutter/model/response/login_result.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  bool error;
  String message;
  LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromRawJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toRawJson() => _$LoginResponseToJson(this);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['error'] == true) {
        final errorResponse = ErrorResponse.fromJson(json);
        return _$LoginResponseFromJson({
          'error': errorResponse.error,
          'message': errorResponse.message,
          'loginResult': {
            'userId': '',
            'name': '',
            'token': '',
          }
        });
      } else {
        return _$LoginResponseFromJson(json);
      }
    } catch (e) {
      return _$LoginResponseFromJson({
        'error': true,
        'message': 'Parse error',
        'loginResult': {
          'userId': '',
          'name': '',
          'token': '',
        }
      });
    }
  }

  factory LoginResponse.failure(String message) => LoginResponse(
        error: true,
        message: message,
        loginResult: LoginResult(
          userId: '',
          name: '',
          token: '',
        ),
      );

  factory LoginResponse.success(LoginResult loginResult) => LoginResponse(
        error: false,
        message: '',
        loginResult: loginResult,
      );

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
