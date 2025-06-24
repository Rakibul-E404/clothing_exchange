import 'package:clothing_exchange/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Utils/Services/user_service.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../views/screens/Auth/signin_screen.dart';

class ProfileScreenController extends GetxController {
  var userName = 'Unknown User'.obs;
  var userProfileImage = ''.obs;
  var isLoading = true.obs;

  // Session cache flags
  bool _hasSessionData = false;
  bool _isInitialLoad = true;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserName = prefs.getString('userName');
    final storedUserProfileImage = prefs.getString('userProfileImage');

    // Load from SharedPreferences first (for immediate display)
    if (storedUserName != null && storedUserProfileImage != null) {
      userName.value = storedUserName;
      userProfileImage.value = storedUserProfileImage;
      _hasSessionData = true;

      // Only show loading on first app launch
      if (_isInitialLoad) {
        isLoading.value = false;
        _isInitialLoad = false;
      }
    }

    // Always fetch fresh data from API (silently in background)
    await _fetchFreshDataSilently(prefs);
  }

  // Silently fetch fresh data without showing loading
  Future<void> _fetchFreshDataSilently(SharedPreferences prefs) async {
    try {
      final userService = UserService();
      final userData = await userService.fetchUserProfile();

      if (userData != null && userData['name'] != null) {
        final newName = userData['name'];
        final newImage = userData['image'] ?? '';

        // Check if data has changed
        bool dataChanged = false;

        if (userName.value != newName) {
          userName.value = newName;
          await prefs.setString('userName', newName);
          dataChanged = true;
        }

        if (userProfileImage.value != newImage) {
          userProfileImage.value = newImage;
          await prefs.setString('userProfileImage', newImage);
          dataChanged = true;
        }

        // Mark as having session data
        _hasSessionData = true;

        // Only set loading to false if this was the initial load
        if (_isInitialLoad) {
          isLoading.value = false;
          _isInitialLoad = false;
        }

      } else if (!_hasSessionData) {
        // Only set default values if we don't have any cached data
        userName.value = 'Unknown User';
        userProfileImage.value = '';
        if (_isInitialLoad) {
          isLoading.value = false;
          _isInitialLoad = false;
        }
      }
    } catch (e) {
      // If API fails but we have cached data, continue with cached data
      if (!_hasSessionData) {
        userName.value = 'Unknown User';
        userProfileImage.value = '';
      }

      if (_isInitialLoad) {
        isLoading.value = false;
        _isInitialLoad = false;
      }
    }
  }

  // Method to build the profile image widget
  Widget buildProfileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Obx(() => _buildImageContent()),
      ),
    );
  }

  // Private method to build the image content
  Widget _buildImageContent() {
    if (userProfileImage.value.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: '${AppUrl.imageBaseUrl}${userProfileImage.value}',
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (context, url, error) => _buildImageError(),
      );
    } else {
      return _buildImageError();
    }
  }

  // Method to build image placeholder
  Widget _buildImagePlaceholder() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
      ),
    );
  }

  // Method to build image error/default state
  Widget _buildImageError() {
    return Icon(
      Icons.person,
      size: 32,
      color: Colors.grey[600],
    );
  }

  // Method to get the full image URL
  String getFullImageUrl() {
    if (userProfileImage.value.isNotEmpty) {
      return '${AppUrl.imageBaseUrl}${userProfileImage.value}';
    }
    return '';
  }

  // Method to check if user has profile image
  bool hasProfileImage() {
    return userProfileImage.value.isNotEmpty;
  }

  // Method to refresh user data
  Future<void> refreshUserData() async {
    // Don't show loading for manual refresh
    final prefs = await SharedPreferences.getInstance();
    await _fetchFreshDataSilently(prefs);
  }

  // Method to check for updates silently (called from ProfileScreen)
  Future<void> checkForUpdates() async {
    if (_hasSessionData) {
      final prefs = await SharedPreferences.getInstance();
      await _fetchFreshDataSilently(prefs);
    }
  }

  // Method to force refresh with loading (only when needed)
  Future<void> forceRefreshWithLoading() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    // Clear cached data
    await prefs.remove('userName');
    await prefs.remove('userProfileImage');

    _hasSessionData = false;
    _isInitialLoad = true;

    // Fetch fresh data
    await loadUserData();
  }

  // Method to update profile image
  Future<void> updateProfileImage(String newImagePath) async {
    userProfileImage.value = newImagePath;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileImage', newImagePath);
  }

  // Method to update user name
  Future<void> updateUserName(String newUserName) async {
    userName.value = newUserName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newUserName);
  }

  // Method to update both user name and image from PersonalInformationScreen
  Future<void> updateUserData({String? newUserName, String? newImagePath}) async {
    final prefs = await SharedPreferences.getInstance();

    if (newUserName != null && newUserName.isNotEmpty) {
      userName.value = newUserName;
      await prefs.setString('userName', newUserName);
    }

    if (newImagePath != null && newImagePath.isNotEmpty) {
      userProfileImage.value = newImagePath;
      await prefs.setString('userProfileImage', newImagePath);
    }

    // Mark that we have session data
    _hasSessionData = true;

    // Force UI update
    update();
  }

  // Method to update from PersonalInformationScreen (immediate update)
  void updateFromPersonalInfo({String? newUserName, String? newImagePath}) {
    if (newUserName != null && newUserName.isNotEmpty) {
      userName.value = newUserName;
    }

    if (newImagePath != null && newImagePath.isNotEmpty) {
      userProfileImage.value = newImagePath;
    }

    // Mark that we have session data
    _hasSessionData = true;

    // Save to SharedPreferences asynchronously
    _saveToPreferences(newUserName, newImagePath);
  }

  // Private method to save to SharedPreferences
  Future<void> _saveToPreferences(String? userName, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();

    if (userName != null && userName.isNotEmpty) {
      await prefs.setString('userName', userName);
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      await prefs.setString('userProfileImage', imagePath);
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
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    Get.back();
                    await _performLogout();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Private method to handle logout logic
  Future<void> _performLogout() async {
    // Clear user data from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userProfileImage');

    // Clear token
    await SharedPrefHelper().removeData(AppConstants.token);

    // Verify token is removed
    final token = await SharedPrefHelper().getData(AppConstants.token);
    if (token == null) {
      // Reset controller values and session flags
      userName.value = 'Unknown User';
      userProfileImage.value = '';
      isLoading.value = false;
      _hasSessionData = false;
      _isInitialLoad = true;

      // Navigate to signin screen
      Get.offAll(() => SigninScreen());
    }
  }
}