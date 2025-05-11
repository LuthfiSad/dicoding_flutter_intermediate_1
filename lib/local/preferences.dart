import 'package:shared_preferences/shared_preferences.dart';
import 'package:intermediate_flutter/model/response/login_result.dart';

class Preferences {
  final String stateKey = 'state';
  final String userTokenKey = 'userTokenKey';
  final String localeKey = 'locale';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userTokenKey) ?? false;
  }

  Future<LoginResult?> saveUser(LoginResult userToken) {
    final prefs = SharedPreferences.getInstance();

    return prefs.then(
      (value) {
        value.setString(userTokenKey, userToken.token);
        return userToken;
      },
    );
  }

  Future<String?> getUserToken() {
    final prefs = SharedPreferences.getInstance();
    return prefs.then(
      (value) {
        final token = value.getString(userTokenKey);
        if (token != null) {
          return token;
        }
        return null;
      },
    );
  }

  Future<bool> removeUser() {
    final prefs = SharedPreferences.getInstance();

    return prefs.then(
      (value) {
        return value.remove(userTokenKey);
      },
    );
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(localeKey, locale);
  }

  Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(localeKey) ?? 'en';
  }
}
