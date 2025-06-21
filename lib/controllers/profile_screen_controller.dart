import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Services/user_service.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../views/screens/Auth/signin_screen.dart';

class ProfileScreenController extends GetxController {
  var userName = 'Unknown User'.obs;
  var userProfileImage = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserName = prefs.getString('userName');
    final storedUserProfileImage = prefs.getString('userProfileImage');

    if (storedUserName != null && storedUserProfileImage != null) {
      userName.value = storedUserName;
      userProfileImage.value = storedUserProfileImage;
      isLoading.value = false;
    } else {
      final userService = UserService();
      final userData = await userService.fetchUserProfile();
      if (userData != null && userData['name'] != null) {
        userName.value = userData['name'];
        userProfileImage.value = userData['image'];
        isLoading.value = false;
        // Store the data locally
        prefs.setString('userName', userName.value);
        prefs.setString('userProfileImage', userProfileImage.value);
      } else {
        userName.value = 'Unknown User';
        userProfileImage.value = '';
        isLoading.value = false;
      }
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Confirm Logout",
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    Get.back();
                    await SharedPrefHelper().removeData(AppConstants.token);
                    final token =
                    await SharedPrefHelper().getData(AppConstants.token);
                    if (token == null) {
                      Get.offAll(() => SigninScreen());
                    }
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}