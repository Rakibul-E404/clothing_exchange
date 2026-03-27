

import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Utils/Services/chat_service.dart';
import '../../../Utils/colors.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../widget/CustomOutlinedButton.dart';
import '../../widget/customElevatedButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widget/customTextField.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String productId;
  final String age;
  final String size;
  final String gender;
  final String location;
  final String imageUrl;
  final String description;

  ProductDetailsScreen({
    super.key,
    required this.title,
    required this.age,
    required this.size,
    required this.gender,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.productId,
  });

  final MessageController _chetCtrl = MessageController();

  // Try to find existing controller, if not found, create a new one
  late final ProfileScreenController _profileCtrl = Get.isRegistered<ProfileScreenController>()
      ? Get.find<ProfileScreenController>()
      : Get.put(ProfileScreenController());

  // Method to get current user ID from ProfileScreenController
  Future<String?> _getCurrentUserId() async {
    try {
      print('🔍 Attempting to get user ID from ProfileController...');

      // First check if controller already has userId
      String? userId = _profileCtrl.userId.value;

      if (userId.isNotEmpty) {
        print('✅ Found user ID from ProfileController: $userId');
        return userId;
      }

      // Try using getter method
      userId = _profileCtrl.getUserId();
      if (userId.isNotEmpty) {
        print('✅ Found user ID from getter: $userId');
        return userId;
      }

      // If not in controller, check SharedPreferences
      print('⚠️ No user ID in ProfileController, checking SharedPreferences...');
      await SharedPrefHelper.init();
      userId = await SharedPrefHelper().getString('userId');

      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences: $userId');
        // Update controller with this ID
        _profileCtrl.userId.value = userId;
        return userId;
      }

      // If still not found, wait a moment for API call to complete
      print('⏳ Waiting for API call to complete...');
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check again after delay
      userId = _profileCtrl.userId.value;
      if (userId.isNotEmpty) {
        print('✅ Found user ID after delay: $userId');
        return userId;
      }

      // One final check from SharedPreferences
      userId = await SharedPrefHelper().getString('userId');
      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences after delay: $userId');
        _profileCtrl.userId.value = userId;
        return userId;
      }

      print('❌ No user ID found anywhere');
      return null;
    } catch (e) {
      print('❌ Error getting user ID: $e');
      return null;
    }
  }

  // Method to get auth token
  Future<String?> _getAuthToken() async {
    try {
      await SharedPrefHelper.init();
      final token = await SharedPrefHelper().getString(AppConstants.token);
      print('🔑 Token exists: ${token != null}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showReportDialog(context, productId);
            },
            icon: const Icon(Icons.report_gmailerrorred),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Image not available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Product Details
            _buildDetailRow('Age', age),
            _buildDetailRow('Size', size),
            _buildDetailRow('Gender', gender),
            _buildDetailRow('Location', location),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 64),

            // Exchange Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                      () => _chetCtrl.conversationCreateLoading.value
                      ? const CircularProgressIndicator()
                      : CustomElevatedButton(
                    textStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold),
                    borderRadius: 30,
                    text: 'Exchange Product',
                    onPressed: () async {
                      print('🔄 Starting exchange process for product: $productId');
                      _chetCtrl.conversationExchangeCreate(productId);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }

  void _showReportDialog(BuildContext context, String productId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final isSubmitting = false.obs;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report an Issue with This Product",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Let us know your issue, and we'll help resolve it as soon as possible.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              CustomTextField(
                controller: titleController,
                hintText: 'Subject',
                borderRadius: 30,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Type Here',
                borderRadius: 20,
                // maxLines: 4,
              ),
              const SizedBox(height: 24),
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomOutlinedButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel',
                    ),
                    const SizedBox(width: 8),
                    isSubmitting.value
                        ? const SizedBox(
                      height: 40,
                      width: 40,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : CustomElevatedButton(
                      text: "Submit",
                      borderRadius: 30,
                      onPressed: () async {
                        // Validate fields
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        isSubmitting.value = true;

                        try {
                          // Get current user ID
                          final userId = await _getCurrentUserId();

                          print('🔍 Debug - Final User ID: $userId');

                          if (userId == null || userId.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please login first to report",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          // Get auth token
                          final token = await _getAuthToken();

                          if (token == null || token.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Session expired. Please login again.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          print('📤 Submitting report for product: $productId');
                          print('📤 Report data:');
                          print('   - reportBy: $userId');
                          print('   - title: ${titleController.text.trim()}');
                          print('   - description: ${descriptionController.text.trim()}');

                          final response = await http.post(
                            Uri.parse('https://api.bearemountclothing.co.uk/api/v1/report/$productId'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              "reportBy": userId,
                              "title": titleController.text.trim(),
                              "description": descriptionController.text.trim(),
                            }),
                          );

                          print('📥 Response status: ${response.statusCode}');
                          print('📥 Response body: ${response.body}');

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Fluttertoast.showToast(
                              msg: "Report submitted successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            Get.back(); // Close dialog
                          } else {
                            String errorMsg = "Failed to submit report";
                            try {
                              final errorResponse = json.decode(response.body);
                              if (errorResponse['message'] != null) {
                                errorMsg = errorResponse['message'];
                              } else if (errorResponse['error'] != null) {
                                errorMsg = errorResponse['error'];
                              }
                            } catch (_) {}

                            Fluttertoast.showToast(
                              msg: errorMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } catch (e) {
                          print('❌ Error in report submission: $e');
                          Fluttertoast.showToast(
                            msg: "Error: ${e.toString()}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } finally {
                          isSubmitting.value = false;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}