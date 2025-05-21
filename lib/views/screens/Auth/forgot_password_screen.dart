import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Services/api_auth.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../../../utils/colors.dart';
import 'verify_email_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
    final AuthService authService = AuthService();

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.forgotPassword(email);
      Get.snackbar('Success', 'OTP sent to your email');
      Get.to(() => VerifyEmailScreen(email: email, fromForgotPassword: true));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter your registered email to receive a verification code.',
              style: AppTextFont.regular(16, AppColors.secondaryColor),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: isLoading ? null : sendOtp,
              text: isLoading ? 'Sending...' : 'Send OTP',
            ),
          ],
        ),
      ),
    );
  }
}
