import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatelessWidget {
  final RxList<Map<String, String>> favoriteProducts;

  WishlistScreen({super.key, required this.favoriteProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wishlist'),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        return favoriteProducts.isEmpty
            ? _buildEmptyWishlist(context)
            : _buildWishlistContent();
      }),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_wishlist_image.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: CustomElevatedButton(
              elevation: 0,
              text: "Add Now",
              textStyle: AppTextFont.regular(15, AppColors.secondary_text_color),
              onPressed: () => Get.back(),
              borderRadius: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return ListView.builder(
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text(
              product['title']!,
              style: AppTextFont.bold(16, AppColors.primaryColor),
            ),
            subtitle: Text(
              'Age: ${product['age']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () {
                favoriteProducts.removeAt(index);
              },
            ),
          ),
        );
      },
    );
  }
}
