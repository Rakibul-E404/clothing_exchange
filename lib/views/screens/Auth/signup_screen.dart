import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/Services/api_auth.dart';
import '../Terms and Privacy/privacy_policy_screen.dart';
import '../Terms and Privacy/terms_&_conditions.dart';
import '../../../utils/colors.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import 'verify_email_screen.dart'; // Import VerifyEmailScreen

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  bool _isTermsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final AuthService _authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    // Check if terms are accepted
    if (!_isTermsAccepted) {
      Get.snackbar('Error', 'Please accept the terms and conditions.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

debugPrint('1');
    // Get the input values
    String username = _usernameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Check if all fields are filled
    if (username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Call the registration service
    var result = await _authService.registerUser(
      username, email, phone, password, confirmPassword,
    );

    // Handle any errors from the registration process
    if (result.containsKey('error')) {
      return ;
      // Get.snackbar('Error', result['error'], snackPosition: SnackPosition.BOTTOM);
    } else {
      // If successful, navigate to email verification screen
      Get.to(VerifyEmailScreen(email: _emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Sign up with Email",
                        style: AppTextFont.bold(23, AppColors.primary_text_color),
                      ),
                      Positioned(
                        bottom: -4,
                        right: 0,
                        child: Container(
                          width: 60,
                          height: 3,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Welcome! Please enter your details.',
                    style: AppTextFont.regular(14, AppColors.primary_text_color),
                  ),
                ),
                const SizedBox(height: 40),
                Text('User Name', style: AppTextFont.regular(18, AppColors.primary_text_color)),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Username',
                  svgIconPath: 'assets/icons/profile_icon.svg',
                  controller: _usernameController,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                Text('Your Email', style: AppTextFont.regular(18, AppColors.primary_text_color)),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Email',
                  svgIconPath: 'assets/icons/gmail_icon.svg',
                  controller: _emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                Text('Phone Number', style: AppTextFont.regular(18, AppColors.primary_text_color)),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Phone Number',
                  svgIconPath: 'assets/icons/global_icon.svg',
                  controller: _phoneController,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                Text('Password', style: AppTextFont.regular(18, AppColors.primary_text_color)),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Password',
                  svgIconPath: 'assets/icons/password_icon.svg',
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.text,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text('Confirm Password', style: AppTextFont.regular(18, AppColors.primary_text_color)),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Confirm Password',
                  svgIconPath: 'assets/icons/password_icon.svg',
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  keyboardType: TextInputType.text,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _isTermsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                          });
                        },
                        activeColor: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _isTermsAccepted = !_isTermsAccepted;
                          setState(() {});
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'By creating an account, I accept the ',
                            style: AppTextFont.regular(12, AppColors.primary_text_color),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(TermsAndConditionsScreen());
                                  },
                              ),
                              TextSpan(
                                text: ' & ',
                                style: AppTextFont.regular(12, AppColors.primary_text_color),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(PrivacyPolicyScreen());
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: AppTextFont.regular(12, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    text: 'Sign Up',
                    onPressed: () {

                      _register();
                    },
                    color: _isTermsAccepted
                        ? AppColors.custom_Elevated_Button_Color
                        : AppColors.custom_Elevated_Button_Color.withOpacity(0.6),
                    textColor: AppColors.Custom_Outlined_Button_Text_Color,
                    borderRadius: 32.0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0.0,
                    textStyle: AppTextFont.regular(18, AppColors.secondary_text_color),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.to(SigninScreen());
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Have an account? ",
                        style: AppTextFont.regular(16, AppColors.primary_text_color),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: AppColors.Custom_Outlined_Button_Text_Color,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
