/**
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
}*/





///
///
///
/// todo: upper is ok and makign the profile id open
///
///
///





import 'package:clothing_exchange/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Utils/Services/user_service.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../views/screens/Auth/signin_screen.dart';

class ProfileScreenController extends GetxController {
  var userName = 'Unknown User'.obs;
  var userProfileImage = ''.obs;
  var isLoading = true.obs;

  // Add userId observable
  var userId = ''.obs;

  // Session cache flags
  bool _hasSessionData = false;
  bool _isInitialLoad = true;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    // You can add any additional initialization here if needed
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserName = prefs.getString('userName');
      final storedUserProfileImage = prefs.getString('userProfileImage');
      final storedUserId = prefs.getString('userId');
      final storedToken = prefs.getString(AppConstants.token);

      print('📱 Loading user data from SharedPreferences:');
      print('   - UserName: $storedUserName');
      print('   - UserImage: $storedUserProfileImage');
      print('   - UserId: $storedUserId');
      print('   - Token exists: ${storedToken != null}');

      // Load from SharedPreferences first (for immediate display)
      if (storedUserName != null && storedUserName.isNotEmpty) {
        userName.value = storedUserName;
      }

      if (storedUserProfileImage != null && storedUserProfileImage.isNotEmpty) {
        userProfileImage.value = storedUserProfileImage;
      }

      if (storedUserId != null && storedUserId.isNotEmpty) {
        userId.value = storedUserId;
        _hasSessionData = true;
        print('✅ Loaded userId from SharedPreferences: $storedUserId');
      }

      // Only show loading on first app launch
      if (_isInitialLoad) {
        isLoading.value = false;
        _isInitialLoad = false;
      }

      // Always fetch fresh data from API (silently in background)
      await _fetchFreshDataSilently(prefs);

    } catch (e) {
      print('❌ Error in loadUserData: $e');
      if (_isInitialLoad) {
        isLoading.value = false;
        _isInitialLoad = false;
      }
    }
  }

  // Silently fetch fresh data without showing loading
// In your ProfileScreenController, update the _fetchFreshDataSilently method:

  Future<void> _fetchFreshDataSilently(SharedPreferences prefs) async {
    try {
      print('🔄 Silently fetching fresh user data from API...');
      final userService = UserService();
      final userData = await userService.fetchUserProfile();

      if (userData != null) {
        print('✅ Received user data from API: $userData');

        // Extract data - NOW INCLUDING ID!
        final newName = userData['name']?.toString();
        final newImage = userData['image']?.toString();
        final newUserId = userData['id']?.toString(); // ID is now available!
        final newEmail = userData['email']?.toString();
        final newPhone = userData['phone']?.toString();

        print('📦 Extracted data:');
        print('   - User ID: $newUserId');
        print('   - Name: $newName');
        print('   - Email: $newEmail');
        print('   - Image: $newImage');

        // Update userName if changed
        if (newName != null && newName.isNotEmpty) {
          if (userName.value != newName) {
            userName.value = newName;
            await prefs.setString('userName', newName);
            print('   - Updated userName: $newName');
          }
        }

        // Update userProfileImage if changed
        if (newImage != null && newImage.isNotEmpty) {
          if (userProfileImage.value != newImage) {
            userProfileImage.value = newImage;
            await prefs.setString('userProfileImage', newImage);
            print('   - Updated userProfileImage: $newImage');
          }
        }

        // Update userId - NOW IT WILL WORK!
        if (newUserId != null && newUserId.isNotEmpty) {
          if (userId.value != newUserId) {
            userId.value = newUserId;
            await prefs.setString('userId', newUserId);
            print('   ✅ Updated userId: $newUserId');
          }
        } else {
          print('⚠️ No user ID found in API response');
        }

        // Mark as having session data
        _hasSessionData = true;

      } else {
        print('⚠️ No user data received from API');

        if (!_hasSessionData) {
          userName.value = 'Unknown User';
          userProfileImage.value = '';
          userId.value = '';
        }
      }
    } catch (e) {
      print('❌ Error in _fetchFreshDataSilently: $e');
      if (!_hasSessionData) {
        userName.value = 'Unknown User';
        userProfileImage.value = '';
        userId.value = '';
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
      size: 50,
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
    print('🔄 Manually refreshing user data...');
    // Don't show loading for manual refresh
    final prefs = await SharedPreferences.getInstance();
    await _fetchFreshDataSilently(prefs);
  }

  // Method to check for updates silently (called from ProfileScreen)
  Future<void> checkForUpdates() async {
    if (_hasSessionData) {
      print('🔍 Checking for updates...');
      final prefs = await SharedPreferences.getInstance();
      await _fetchFreshDataSilently(prefs);
    }
  }

  // Method to force refresh with loading (only when needed)
  Future<void> forceRefreshWithLoading() async {
    print('🔄 Force refreshing with loading...');
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    // Clear cached data
    await prefs.remove('userName');
    await prefs.remove('userProfileImage');
    await prefs.remove('userId');

    _hasSessionData = false;
    _isInitialLoad = true;

    // Fetch fresh data
    await loadUserData();
  }

  // Method to update profile image
  Future<void> updateProfileImage(String newImagePath) async {
    print('📸 Updating profile image to: $newImagePath');
    userProfileImage.value = newImagePath;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileImage', newImagePath);
  }

  // Method to update user name
  Future<void> updateUserName(String newUserName) async {
    print('👤 Updating user name to: $newUserName');
    userName.value = newUserName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newUserName);
  }

  // Method to update both user name and image from PersonalInformationScreen
  Future<void> updateUserData({String? newUserName, String? newImagePath}) async {
    print('📝 Updating user data:');
    print('   - New Name: $newUserName');
    print('   - New Image: $newImagePath');

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
    print('🔄 Updating from Personal Information:');
    print('   - New Name: $newUserName');
    print('   - New Image: $newImagePath');

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

    // Force UI update
    update();
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

  // Getter methods
  String getUserName() {
    return userName.value;
  }

  String getUserProfileImage() {
    return userProfileImage.value;
  }

  String getUserId() {
    return userId.value;
  }

  bool isUserLoggedIn() {
    return userId.value.isNotEmpty;
  }

  // Method to check if user data is loaded
  bool isDataLoaded() {
    return !isLoading.value && _hasSessionData;
  }

  // Method to clear user data (useful for testing)
  Future<void> clearUserData() async {
    print('🗑️ Clearing all user data...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userProfileImage');
    await prefs.remove('userId');

    userName.value = 'Unknown User';
    userProfileImage.value = '';
    userId.value = '';
    _hasSessionData = false;
  }

  // Debug method to print current state
  void debugPrintUserData() {
    print('\n=== PROFILE CONTROLLER DEBUG ===');
    print('User ID: ${userId.value}');
    print('User Name: ${userName.value}');
    print('User Image: ${userProfileImage.value}');
    print('Is Loading: ${isLoading.value}');
    print('Has Session Data: $_hasSessionData');
    print('Is Initial Load: $_isInitialLoad');
    print('================================\n');
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
    print('🚪 Performing logout...');

    try {
      // Clear user data from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userName');
      await prefs.remove('userProfileImage');
      await prefs.remove('userId');

      // Clear token from SharedPrefHelper
      await SharedPrefHelper().removeData(AppConstants.token);

      // Verify token is removed
      final token = await SharedPrefHelper().getData(AppConstants.token);
      print('🔍 Token after removal: $token');

      // Reset controller values
      userName.value = 'Unknown User';
      userProfileImage.value = '';
      userId.value = '';
      isLoading.value = false;
      _hasSessionData = false;
      _isInitialLoad = true;

      print('✅ Logout successful');
      debugPrintUserData();

      // Navigate to signin screen
      Get.offAll(() => SigninScreen());

    } catch (e) {
      print('❌ Error during logout: $e');
      Fluttertoast.showToast(
        msg: "Error during logout: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}