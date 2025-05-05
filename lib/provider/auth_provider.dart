import 'package:flutter/material.dart';
import 'package:intermediate_flutter/api/api_service.dart';
import 'package:intermediate_flutter/database/preferences.dart';
import 'package:intermediate_flutter/model/response/login_response.dart';
import 'package:intermediate_flutter/model/response/login_result.dart';
import 'package:intermediate_flutter/model/response/logout_response.dart';
import 'package:intermediate_flutter/model/response/register_response.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Preferences _preferences = Preferences();

  LoginResult? _userToken;
  bool _isFetching = false;
  bool _isLogin = false;
  bool _isPasswordVisible = true;

  bool get isLogin => _isLogin;
  bool get isFetching => _isFetching;
  bool get isPasswordVisible => _isPasswordVisible;
  LoginResult? get userToken => _userToken;

  void setIsLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  void setIsPasswordVisible(bool isPasswordVisible) {
    _isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }

  Future<LoginResponse> login(String email, String password) async {
    _isFetching = true;
    notifyListeners();
    var response = await _apiService.login(email, password);
    // set user token

    if (response.error == false) {
      await _preferences.saveUser(response.loginResult);
      _userToken = response.loginResult;
      _isFetching = false;
      return LoginResponse.success(response.loginResult);
    }

    _isFetching = false;
    return LoginResponse.failure(response.message);
  }

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    _isFetching = true;
    notifyListeners();
    var response = await _apiService.register(name, email, password);

    if (response.error == false) {
      _isFetching = false;
      return RegisterResponse.success();
    }

    _isFetching = false;
    return RegisterResponse.failure(response.message);
  }

  Future<LogoutResponse> logout() async {
    try {
      _isFetching = true;
      await _preferences.removeUser();
      _userToken = null;
      notifyListeners();
      return LogoutResponse.success();
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      throw LogoutResponse.failure(e.toString());
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
