import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/helper_shared_pref.dart';

class AboutUsData {
  final String content;
  final DateTime updatedAt;

  AboutUsData({required this.content, required this.updatedAt});
}

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late Future<AboutUsData> _aboutUsFuture;

  @override
  void initState() {
    super.initState();
    _aboutUsFuture = fetchAboutUs();
  }

  Future<AboutUsData> fetchAboutUs() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/about/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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

        return AboutUsData(content: content, updatedAt: updatedAt);
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching about us: $e');
      throw Exception('Failed to load content: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About us"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: FutureBuilder<AboutUsData>(
        future: _aboutUsFuture,
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
                          _aboutUsFuture = fetchAboutUs();
                        });
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final formattedDate = DateFormat('MMM d, yyyy').format(data.updatedAt);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Update $formattedDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   data.content,
                  //   textAlign: TextAlign.justify,
                  // ),
                  Html(
                    data: data.content,
                    style: {
                      'p': Style(
                        fontSize: FontSize(16),
                        color: AppColors.primary_text_color,
                        textAlign: TextAlign.justify,
                      ),
                    },
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
