import 'package:json_annotation/json_annotation.dart';

part 'logout_response.g.dart';

@JsonSerializable()
class LogoutResponse {
  bool? error;
  String? message;

  LogoutResponse({this.message, this.error});

  factory LogoutResponse.failure(String message) => _$LogoutResponseFromJson({
        'error': true,
        'message': message,
      });

  factory LogoutResponse.success() => _$LogoutResponseFromJson({
        'error': false,
        'message': 'Success',
      });

  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}
