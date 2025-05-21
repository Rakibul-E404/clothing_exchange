import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@gmail.com',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Our Support Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We\'re here to help with any questions or issues you may have.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            CustomOutlinedButton(
              svgIcon: 'assets/icons/gmail_icon.svg',
              text: 'support@gmail.com',
              onPressed: _launchEmail,
              backgroundColor: Colors.white,
              borderColor: AppColors.secondaryColor,
              textColor: AppColors.secondaryColor,
              iconColor: AppColors.secondaryColor,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: const [
                  FAQItem(
                    question: 'How do I exchange an item?',
                    answer: 'Go to your inbox, select the item you want to exchange, and propose an exchange to the owner.',
                  ),
                  FAQItem(
                    question: 'What if I receive a damaged item?',
                    answer: 'Contact support immediately with photos of the damaged item for assistance.',
                  ),
                  FAQItem(
                    question: 'How long does shipping usually take?',
                    answer: 'Shipping times vary but typically take 3-5 business days after both parties confirm the exchange.',
                  ),
                ],
              ),
            ),
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