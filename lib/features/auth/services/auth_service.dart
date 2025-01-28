import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/navigation_service.dart';
import '../models/auth_token.dart';
import '../models/login_response.dart';

class AuthService {
  final BuildContext? context;

  static const _isLoggedInKey = 'is_logged_in';

  AuthService({this.context});

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> saveAuthData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize the login response to JSON
    final jsonString = jsonEncode(loginResponse.toJson());

    // Save the JSON string to SharedPreferences
    await prefs.setString('authData', jsonString);
  }

  /// Retrieve login response from SharedPreferences
  Future<LoginResponse?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string
    final jsonString = prefs.getString('authData');

    if (jsonString != null) {
      // Deserialize the JSON string back to LoginResponse
      return LoginResponse.fromJson(jsonDecode(jsonString));
    }

    return null;
  }

  Future<void> saveAuthToken(AuthToken tokens) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the JSON string to SharedPreferences
    await prefs.setString('accessToken', tokens.accessToken);
    await prefs.setString('refreshToken', tokens.refreshTokens);
  }

  /// Retrieve login response from SharedPreferences
  Future<AuthToken?> getAuthTokens() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && refreshToken != null) {
      // Deserialize the JSON string back to LoginResponse
      return AuthToken(accessToken: accessToken, refreshTokens: refreshToken);
    }

    return null;
  }

  /// Clear login response data from SharedPreferences
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authData');
    await setLoggedIn(false);
  }

  void logout() {
    clearAuthData();
    setLoggedIn(false);
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false, // Remove all previous routes
    );
  }
}
