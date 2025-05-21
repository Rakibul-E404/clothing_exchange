import 'package:clothing_exchange/images/assets_path.dart';
import 'package:clothing_exchange/views/screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../../../utils/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          _buildChangePasswordForm(context),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF806107),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Text(
                    "Change Password",
                    style: AppTextFont.bold(23, AppColors.primary_text_color),
                  ),
                  Positioned(
                    bottom: -4,
                    left: 0,
                    child: Container(
                      width: 60,
                      height: 3,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Text(
                'Enter your current and new password',
                style: AppTextFont.regular(14, AppColors.primary_text_color),
              ),
            ),
            const SizedBox(height: 30),

            // Old Password Field
            Text(
              'Current Password',
              style: AppTextFont.regular(18, AppColors.primary_text_color),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'Enter Current Password',
              svgIconPath: AppAssets.passwordIcon,
              obscureText: true,
              controller: _oldPasswordController,
              hoverColor: AppColors.hover_color,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your current password';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // New Password Field
            Text(
              'New Password',
              style: AppTextFont.regular(18, AppColors.primary_text_color),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'Enter New Password',
              svgIconPath: AppAssets.passwordIcon,
              obscureText: true,
              controller: _newPasswordController,
              hoverColor: AppColors.hover_color,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a new password';
                if (value.length < 8) return 'Password must be at least 8 characters';
                if (value == _oldPasswordController.text) return 'New password must be different from current password';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Confirm New Password Field
            Text(
              'Confirm New Password',
              style: AppTextFont.regular(18, AppColors.primary_text_color),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              svgIconPath: AppAssets.passwordIcon,
              hintText: 'Confirm New Password',
              obscureText: true,
              controller: _confirmPasswordController,
              hoverColor: AppColors.hover_color,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Change Password Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Change Password',
                  onPressed: _handlePasswordChange,
                  color: AppColors.custom_Elevated_Button_Color,
                  textColor: AppColors.Custom_Outlined_Button_Text_Color,
                  borderRadius: 32.0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0.0,
                  textStyle: AppTextFont.regular(18, AppColors.secondary_text_color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/reset_password.jpg',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 25),
            Text(
              "Password Changed!",
              style: AppTextFont.bold(23, AppColors.primary_text_color),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your password has been successfully changed. Please sign in again with your new password.",
                textAlign: TextAlign.center,
                style: AppTextFont.regular(16, AppColors.primary_text_color),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                text: 'Back To Profile',
                onPressed: () {
                  Get.back(); // Close the bottom sheet
                  Get.offAll(() => ProfileScreen());
                },
                color: AppColors.custom_Elevated_Button_Color,
                textColor: AppColors.Custom_Outlined_Button_Text_Color,
                borderRadius: 32.0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0.0,
                textStyle: AppTextFont.regular(18, AppColors.secondary_text_color),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  Future<void> _handlePasswordChange() async {
    // Validate all fields
    if (_oldPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your current password',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text.isEmpty || _newPasswordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'New password must be at least 8 characters',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text == _oldPasswordController.text) {
      Get.snackbar(
        'Error',
        'New password must be different from current password',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);
      _showSuccessBottomSheet();
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'Failed to change password. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }
}