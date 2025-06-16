import 'dart:async';
import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/Services/api_auth.dart';
import '../../../utils/colors.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../Profile/reset_password_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final bool fromForgotPassword;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.fromForgotPassword = false,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _oneTimeCodeController = TextEditingController();
  final AuthService _authService = AuthService();
  int _counter = 25;
  Timer? _timer;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _counter = 25;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _oneTimeCodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _oneTimeCodeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter the verification code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.verifyEmail(widget.email, code);

      if (result.containsKey('error')) {
        Get.snackbar('Error', result['error']);
      } else {
        // Success path
        if (widget.fromForgotPassword) {
          Get.off(() => ResetPasswordScreen(email: widget.email, otp: code));
        } else {
          Get.snackbar('Success', 'Signup Successful');
          Get.off(() => SigninScreen());
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed. Please try again.',);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
    });

    try {
      await _authService.forgotPassword(widget.email);
      Get.snackbar('Success', 'Verification code resent to ${widget.email}');
      _startTimer();
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend code. Please try again.');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter the verification code sent to ${widget.email}',
              style: AppTextFont.regular(16, AppColors.secondaryColor),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _oneTimeCodeController,
              hintText: 'Verification Code',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              text: _isLoading ? 'Verifying...' : 'Verify',
            ),
            const SizedBox(height: 20),
            if (_counter > 0)
              Text('Resend code in $_counter seconds'),
            if (_counter == 0)
              TextButton(
                onPressed: _isResending ? null : _resendCode,
                child: _isResending
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Resend Code'),
              ),
          ],
        ),
      ),
    );
  }
}
