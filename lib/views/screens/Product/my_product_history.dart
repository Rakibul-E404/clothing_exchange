import 'package:clothing_exchange/Utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/screens/Product/product_details_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductHistoryScreen extends StatelessWidget {
  const ProductHistoryScreen({super.key});

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

    // Sample data for exchange user info (you can modify as per your model)
    final exchangeUserImagePath = 'assets/user_profile_image.png';
    final exchangeUserName = 'Anika Alom';
    final exchangeUserPhone = '018*********';
    final exchangeUserLocation = 'New York, USA';

    // Delete callback stub (implement as needed)
    void onDelete() {
      Get.back(); // Just going back for now
      // Add your delete logic here
    }

    Widget productItem({
      required String imagePath,
      required String title,
      required String age,
      required String description,
      required String badgeText,
      required Color badgeColor,
    }) {
      return GestureDetector(
        onTap: () {
          Get.to(
                () => ProductDetailsHistoryScreen(
              productImagePath: imagePath,
              title: title,
              age: age,
              description: description,
              onDelete: onDelete,
              exchangeUserImagePath: exchangeUserImagePath,
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
              // Image container
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
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
                        // Show badge only if badgeText is not empty
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
                    Text('Age : $age', style: ageStyle),
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
        leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.arrow_back_ios)),
        title:  Text(
          // 'Product list (03)',
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
        child: ListView(
          children: [
            productItem(
              imagePath: 'assets/99a3bc26-ccf4-44e6-9739-c98b3ac3ab56.png',
              title: 'Formal Suit Set',
              age: '16-18 years',
              description:
              'Gray jeans for girls (10-13 years), gently used for 6 months. Comfortable and stylish, perfect for everyday wear—available for exchange',
              badgeText: 'Pending',
              badgeColor: const Color(0xFFBB9964),
            ),
            productItem(
              imagePath: 'assets/99a3bc26-ccf4-44e6-9739-c98b3ac3ab56.png',
              title: 'High heels',
              age: '11-16 years',
              description:
              'Gray jeans for girls (10-13 years), gently used for 6 months. Comfortable and stylish, perfect for everyday wear—available for exchange',
              badgeText: 'Available',
              badgeColor: const Color(0xFFBB9964),
            ),
            productItem(
              imagePath: 'assets/99a3bc26-ccf4-44e6-9739-c98b3ac3ab56.png',
              title: 'Denim Jacket',
              age: '15-17 years',
              description:
              'Gray jeans for girls (10-13 years), gently used for 6 months. Comfortable and stylish, perfect for everyday wear—available for exchange',
              badgeText: '',
              badgeColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
