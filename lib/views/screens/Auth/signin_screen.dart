import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../images/assets_path.dart';
import '../../../utils/Services/api_auth.dart';
import '../../../utils/colors.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../Home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkForStoredCredentials();
  }

  // Function to check if credentials are stored
  Future<void> _checkForStoredCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail != null && storedPassword != null) {
      _emailController.text = storedEmail;
      _passwordController.text = storedPassword;
    }
  }

  // Function to store the user's credentials
  Future<void> _storeCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future<void> _signInUi() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signInApi(email, password);

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        Get.snackbar(
          'Login Failed',
          response['error'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        _userId = response['userId'];
        print('Logged in userId: $_userId');

        // Store credentials after successful login
        _storeCredentials(email, password);
        Get.find<HomeController>().fetchProducts();
        Get.offAll(() => MainBottomNavScreen());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'An error occurred during login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "Sign in to your account",
                              style: AppTextFont.bold(
                                23,
                                AppColors.primary_text_color,
                              ),
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
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Welcome! Sign in to your account to continue.',
                          style: AppTextFont.regular(
                            14,
                            AppColors.primary_text_color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Your Email',
                        style: AppTextFont.regular(
                          18,
                          AppColors.primary_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Enter Email',
                        svgIconPath: 'assets/icons/gmail_icon.svg',
                        obscureText: false,
                        hoverColor: AppColors.hover_color,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Password',
                        style: AppTextFont.regular(
                          18,
                          AppColors.primary_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Enter Password',
                        svgIconPath: AppAssets.passwordIcon,
                        obscureText: !_isPasswordVisible,
                        hoverColor: AppColors.hover_color,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.secondaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: Text(
                            'Forgot Password?',
                            style: AppTextFont.regular(
                              18,
                              AppColors.primary_text_color,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      _isLoading
                          ? Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Lottie.asset(
                                'assets/animations/loading.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                          : SizedBox(
                            width: double.infinity,
                            child: CustomElevatedButton(
                              text: 'Sign In',
                              onPressed: _isLoading ? null : _signInUi,
                              color: AppColors.custom_Elevated_Button_Color,
                              textColor:
                                  AppColors.Custom_Outlined_Button_Text_Color,
                              borderRadius: 32.0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0.0,
                              textStyle: AppTextFont.regular(
                                18,
                                AppColors.secondary_text_color,
                              ),
                              child: null,
                            ),
                          ),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTextFont.regular(
                                16,
                                AppColors.primary_text_color,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => SignUPScreen());
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                              ),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color:
                                      AppColors
                                          .Custom_Outlined_Button_Text_Color,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
