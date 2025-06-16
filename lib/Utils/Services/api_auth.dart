import 'dart:convert';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Register User
  Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) async {
    try {
      if (password != confirmPassword) {
        return {'error': 'Passwords do not match'};
      }

      final response = await http.post(
        Uri.parse(AppUrl.authRegister),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );
      debugPrint('2');
      debugPrint(response.body);


      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('3');
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);

        final pop = jsonDecode(response.body);
        Get.snackbar('Error', pop['message'], snackPosition: SnackPosition.BOTTOM);
        return {'error': errorResponse['message'] ?? 'Failed to register'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Sign In User
  signInApi(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.authLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseString = jsonDecode(response.body);

        final accessToken =
            responseString['data']['attributes']['tokens']['access']['token'];
        // debugPrint('printing from controller === > ${accessToken}');
        SharedPrefHelper().saveData(AppConstants.token, accessToken);
        // debugPrint('checking the token  === > ${SharedPrefHelper().getData(AppConstants.token)}');

        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {'error': errorResponse['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Verify Email
  Future<Map<String, dynamic>> verifyEmail(
    String email,
    String oneTimeCode,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'oneTimeCode': oneTimeCode}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {'error': errorResponse['message'] ?? 'Failed to verify email'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // ForgotPassword
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse(AppUrl.forgotPassword);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to send OTP');
    }
  }

  // Reset Password

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  }) async {
    try {
      if (newPassword != confirmPassword) {
        return {'error': 'Passwords do not match'};
      }

      final response = await http.post(
        Uri.parse(AppUrl.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': newPassword}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {
          'error': errorResponse['message'] ?? 'Failed to reset password',
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
