import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/screens/Product/product_details_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debug logging

import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';

class ProductHistoryScreen extends StatefulWidget {
  const ProductHistoryScreen({super.key});

  @override
  _ProductHistoryScreenState createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends State<ProductHistoryScreen> {
  // Base URL for your API and image paths
  // final String baseUrl = 'https://d7001.sobhoy.com';
  // final String apiUrl = 'https://d7001.sobhoy.com/api/v1/products/history';

  // This will hold the fetched product data
  List<dynamic> productHistory = [];

  // Future to track the API call
  late Future<void> _fetchFuture;

  // Retrieve token from shared preferences
  Future<String?> _getToken() async {
    return SharedPrefHelper().getData(AppConstants.token);
  }

  // Fetch product data from the API with authentication
  Future<void> fetchProductHistory() async {
    try {
      final token = await _getToken();
      if (kDebugMode) {
        print('Retrieved token: $token');
      }
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }
debugPrint("===> ${AppUrl.productHistory}");
// debugPrint("===> ${baseUrl}");

      final response = await http.get(
        Uri.parse(AppUrl.productHistory),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (kDebugMode) {
        print('API Response: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          productHistory = responseData['data']['attributes'] ?? [];
        });
      } else {
        throw Exception('Failed to load product history: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching product history: $e');
      }
      throw Exception('Error fetching product history: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFuture = fetchProductHistory(); // Initialize the future in initState
  }

  @override
  Widget build(BuildContext context) {
    // Common text styles
    final titleStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: Colors.black87,
    );

    final ageStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      color: Colors.black54,
    );

    final descriptionStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 11,
      color: Colors.black45,
    );

    // Delete callback
    void onDelete() {
      Get.back();
      // Add your delete logic here, e.g., call a delete API
      if (kDebugMode) {
        print('Delete action triggered');
      }
      setState(() => _fetchFuture = fetchProductHistory()); // Refresh list
    }

    Widget productItem({
      required String imageUrl,
      required String title,
      required String age,
      required String description,
      required String badgeText,
      required Color badgeColor,
      required String exchangeUserName,
      required String exchangeUserPhone,
      required String exchangeUserLocation,
      required String exchangeUserImagePath,
    }) {

      final fullProductImageUrl = imageUrl.isNotEmpty
          // ? (imageUrl.startsWith('http') ? imageUrl : '${AppUrl.baseUrl}/$imageUrl')
          ? (imageUrl.startsWith('http') ? imageUrl : '${AppUrl.imageBaseUrl}/$imageUrl')
          : 'https://via.placeholder.com/100'; // Fallback placeholder

      // Construct full user image URL
      final fullUserImageUrl = exchangeUserImagePath.isNotEmpty &&
          exchangeUserImagePath != 'assets/user_profile_image.png'
          ? (exchangeUserImagePath.startsWith('http')
          ? exchangeUserImagePath
          // : '$baseUrl/$exchangeUserImagePath')
          : '${AppUrl.imageBaseUrl}/$exchangeUserImagePath')
          : exchangeUserImagePath; // Keep asset path if placeholder

      if (kDebugMode) {
        print('Product Image URL: $fullProductImageUrl');
        print('User Image URL: $fullUserImageUrl');
      }

      return GestureDetector(
        onTap: () {
          Get.to(
                () => ProductDetailsHistoryScreen(
              productImagePath: fullProductImageUrl,
              title: title,
              age: age,
              description: description,
              onDelete: onDelete,
              exchangeUserImagePath: fullUserImageUrl,
              exchangeUserName: exchangeUserName,
              exchangeUserPhone: exchangeUserPhone,
              exchangeUserLocation: exchangeUserLocation,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEBD9C9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container (using network image)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    fullProductImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        print('Product image load error: $error');
                      }
                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Details column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and badge row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: titleStyle),
                        if (badgeText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Age: $age', style: ageStyle),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: descriptionStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'My Product History',
          style: AppTextFont.bold(16, AppColors.primary_text_color),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: FutureBuilder<void>(
          future: _fetchFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _fetchFuture = fetchProductHistory()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (productHistory.isEmpty) {
              return const Center(child: Text('No product history found.'));
            } else {
              return ListView.builder(
                itemCount: productHistory.length,
                itemBuilder: (context, index) {
                  final product = productHistory[index];
                  return productItem(
                    imageUrl: product['image'] ?? '',
                    title: product['title'] ?? 'No Title',
                    age: product['age'] ?? 'N/A',
                    description: product['description'] ?? 'No Description',
                    badgeText: product['status'] ?? '',
                    badgeColor: (product['status'] ?? '') == 'available'
                        ? Colors.green
                        : Colors.red,
                    exchangeUserName: product['author']?['name'] ?? 'Unknown',
                    exchangeUserPhone: product['author']?['phone'] ?? 'N/A',
                    exchangeUserLocation: product['location'] ?? 'N/A',
                    exchangeUserImagePath: product['author']?['image'] ?? 'assets/user_profile_image.png',
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}


