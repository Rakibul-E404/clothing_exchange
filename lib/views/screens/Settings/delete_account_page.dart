import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../Utils/app_constants.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get token from SharedPrefHelper
      final token = SharedPrefHelper().getData(AppConstants.token);

      if (token == null || token.isEmpty) {
        Get.snackbar(
          "Error",
          "Authentication token not found.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.delete(
        Uri.parse(AppUrl.deleteAccount),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Debug log
      print('DELETE Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          "Success",
          "Your account has been deleted successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear token/session if needed
        SharedPrefHelper().removeData(AppConstants.token);

        // Navigate to login page
        Get.offAll(SigninScreen());
      } else {
        String errorMessage = "Something went wrong.";
        try {
          final data = json.decode(response.body);
          if (data['message'] != null) errorMessage = data['message'];
        } catch (_) {}
        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Delete Account Error: $e');
      Get.snackbar(
        "Error",
        "Failed to delete account. Please check your connection and try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_forever,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "Delete Your Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "After deleting your account, all your data will be permanently lost and cannot be recovered.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // Delete Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _isLoading ? null : _deleteAccount,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Delete Account"),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Get.back(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
