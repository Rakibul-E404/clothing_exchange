import 'package:clothing_exchange/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String age;
  final String size;
  final String gender;
  final String location;
  final String imageUrl;
  final String price;

  const ProductDetailsScreen({
    super.key,
    required this.title,
    required this.age,
    required this.size,
    required this.gender,
    required this.location,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Image not available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),

            // Details
            _buildDetailRow('Age', age),
            _buildDetailRow('Size', size),
            _buildDetailRow('Gender', gender),
            _buildDetailRow('Location', location),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'This is a placeholder description for the product. You can update this field to show detailed product information later.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }
}

