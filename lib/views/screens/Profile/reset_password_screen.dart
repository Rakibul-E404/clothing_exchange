import 'package:clothing_exchange/images/assets_path.dart';
import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/Services/api_auth.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../../../utils/colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() => _isLoading = true);

      final result = await AuthService().resetPassword(
        email: widget.email,
        newPassword: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        otp: widget.otp,
      );

      setState(() => _isLoading = false);

      if (result.containsKey('error')) {
        Get.snackbar(
          'Error',
          result['error'],
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else {
        _showSuccessBottomSheet();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'Failed to reset password. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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
                "Return to the login page to enter your account with your new password.",
                textAlign: TextAlign.center,
                style: AppTextFont.regular(16, AppColors.primary_text_color),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                text: 'Back To Sign In',
                onPressed: () {
                  Get.back(); // Close the bottom sheet
                  Get.offAll(() => SigninScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "Reset Password",
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
                        'Enter a New Password',
                        style: AppTextFont.regular(14, AppColors.primary_text_color),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Password',
                      style: AppTextFont.regular(18, AppColors.primary_text_color),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: 'Enter Password',
                      svgIconPath: AppAssets.passwordIcon,
                      obscureText: true,
                      controller: _passwordController,
                      hoverColor: AppColors.hover_color,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a password';
                        if (value.length < 8) return 'Password must be at least 8 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Confirm Password',
                      style: AppTextFont.regular(18, AppColors.primary_text_color),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      svgIconPath: AppAssets.passwordIcon,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      controller: _confirmPasswordController,
                      hoverColor: AppColors.hover_color,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          text: _isLoading ? 'Please wait...' : 'Reset Password',
                          onPressed: _isLoading ? null : _handlePasswordReset,
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
            ),
          ),

          // Loading Indicator on top
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
}

