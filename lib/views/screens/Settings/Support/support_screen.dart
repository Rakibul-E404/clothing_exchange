import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchEmail(BuildContext context, String emailAddress) async {
    // Copy email to clipboard
    await Clipboard.setData(ClipboardData(text: emailAddress));
    Get.snackbar('Copied', 'Email address copied to clipboard');

    // Launch email client
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {'subject': 'Clothing Exchange Support'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      Get.snackbar('Error', 'Could not launch email client');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String supportEmail = 'support@gmail.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 40),
            CustomOutlinedButton(
              svgIcon: 'assets/icons/gmail_icon.svg',
              text: supportEmail,
              onPressed: () => _launchEmail(context, supportEmail),
              backgroundColor: Colors.white,
              borderColor: AppColors.secondaryColor,
              textColor: AppColors.secondaryColor,
              iconColor: AppColors.secondaryColor,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

/// todo: need to navigate into gmail app not any email app but current is email app ok. . .