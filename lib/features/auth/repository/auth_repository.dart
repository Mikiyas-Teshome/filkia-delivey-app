import 'package:dio/dio.dart';

import '../../../common/exceptions/unauthrised_exception.dart';
import '../../../common/network/dio_client.dart';
import '../models/auth_token.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(
    DioClient dio,
  ) : _dio = dio.dio;

  /// Perform login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login', // Replace with your backend login endpoint
        data: {
          "email": email,
          "password": password,
          "verificationMethod": "OTP",
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.userType != 'Driver') {
          throw Exception(
              'You are not allowed to login in this app, please use download and use the ${loginResponse.userType} app!');
        }
        await AuthService().saveAuthData(loginResponse);
        await AuthService().saveAuthToken(AuthToken(
            accessToken: loginResponse.accessToken,
            refreshTokens: loginResponse.refreshToken));
        await AuthService().setLoggedIn(true);

        return loginResponse; // Contains accessToken, vendorData, etc.
      } else if (response.statusCode == 403 &&
          response.statusMessage == "EmailUnverifiedException") {
        // print('Failed to login: ${response.data}');
        throw Exception('${response.statusMessage}');
      } else {
        // print('Failed to login: ${response.data}');
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'An error occurred during OTP verification');
    }
  }

  Future<void> signup(
      {required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required String password,
      required String licenseNumber,
      required String licenseExpiry,
      required String vehicleType,
      required String vehiclePlate,
      required String address,
      required String city,
      required String state,
      required String zipCode,
      required double latitude,
      required double longitude}) async {
    try {
      final response = await _dio.post(
        'auth/register/driver', // Replace with your backend endpoint
        data: {
          "firstName": firstName.trim(),
          "lastName": lastName.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "licenseNumber": licenseNumber.trim(),
          "licenseExpiry": licenseExpiry.trim(),
          "vehicleType": vehicleType.trim(),
          "vehiclePlate": vehiclePlate.trim(),
          "address": address.trim(),
          "city": city.trim(),
          "state": state.trim(),
          "zipCode": zipCode.trim(),
          "phone": phone.trim(),
          "verificationMethod": "OTP",
          "latitude": latitude,
          "longitude": longitude
        },
      );

      if (response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      print("here is the ewrror $e");
      throw Exception(
          e.response?.data['message'] ?? 'Something went wrong during signup');
    }
  }

  Future<void> resendEmail({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/resendEmail', // Replace with your backend endpoint
        data: {"email": email.trim(), "verificationMethod": "OTP"},
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Email Resend failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'An error occurred during OTP verification');
    }
  }

  Future<void> verifyEmailByOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/verifyEmail', // Replace with your backend endpoint
        data: {
          "email": email.trim(),
          "Otp": otp.trim(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'OTP Verification failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'An error occurred during OTP verification');
    }
  }

  Future<AuthToken> refreshAccessToken({required String refreshToken}) async {
    try {
      print('[AuthRepository] Attempting to refresh access token...');
      print('[AuthRepository] Refresh token being used: $refreshToken');

      // Make the refresh token request
      final response = await _dio.post(
        "/auth/refresh",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      print(
          '[AuthRepository] Refresh token response received: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse and save the new tokens
        final tokens = AuthToken.fromJson(response.data);
        await AuthService().saveAuthToken(tokens);
        print(
            '[AuthRepository] Token refresh successful. New tokens: ${tokens.toString()}');
        return tokens;
      } else {
        print(
            '[AuthRepository] Failed to refresh token. Status code: ${response.statusCode}, Response: ${response.data}');
        throw UnauthorizedException(
          response.data['message'] ?? 'Failed to refresh token.',
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print('[AuthRepository] DioException during token refresh: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Refresh token is invalid or expired.');
      }
      throw Exception('Error refreshing token: ${e.message}');
    } catch (e) {
      // Handle other types of errors
      print('[AuthRepository] Unexpected error during token refresh: $e');
      throw Exception('Unexpected error during token refresh: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgotPassword',
        data: {"email": email.trim()},
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Forgot password failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'An error occurred during OTP verification');
    }
  }
}
