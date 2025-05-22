import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../../Utils/app_url.dart';
import '../../../utils/colors.dart';
import '../../fonts_style/fonts_style.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';

class PrivacyPolicyData {
  final String content;
  final DateTime updatedAt;

  PrivacyPolicyData({required this.content, required this.updatedAt});
}

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<PrivacyPolicyData> _privacyPolicyFuture;

  @override
  void initState() {
    super.initState();
    _privacyPolicyFuture = fetchPrivacyPolicy();
  }

  Future<PrivacyPolicyData> fetchPrivacyPolicy() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/privacy_policy'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final contentRaw = data['data']?['attributes']?['content'] ??
            data['content'] ??
            data['data']?['content'] ??
            "No content available";

        final updatedAtRaw = data['data']?['attributes']?['updatedAt'] ?? '';

        final unescape = HtmlUnescape();
        final content = unescape.convert(contentRaw);

        DateTime updatedAt = DateTime.tryParse(updatedAtRaw) ?? DateTime.now();

        return PrivacyPolicyData(content: content, updatedAt: updatedAt);
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load privacy policy: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: AppTextFont.regular(10, AppColors.primary_text_color),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: FutureBuilder<PrivacyPolicyData>(
        future: _privacyPolicyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _privacyPolicyFuture = fetchPrivacyPolicy();
                        });
                      },
                      child: const Text('Retry', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final formattedDate = DateFormat('MMM d, yyyy').format(data.updatedAt);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: AppTextFont.regular(24, AppColors.primary_text_color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last Update $formattedDate',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.content,
                    textAlign: TextAlign.justify,
                    style: AppTextFont.regular(16, AppColors.primary_text_color),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
