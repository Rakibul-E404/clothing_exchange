import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../views/fonts_style/fonts_style.dart';

class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'By creating an account, I accept the ',
              style: AppTextFont.regular(12, AppColors.primary_text_color),
              children: [
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Terms & Conditions
                    },
                ),
                const TextSpan(text: ' & '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Privacy Policy
                    },
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}