import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';

import '../../../controllers/favoriteController.dart';
import '../../../models/favorite_item_model.dart';

class WishlistScreen extends StatelessWidget {
  // final FavoriteController favoriteController = Get.find();
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wishlist'),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final items = favoriteController.favoriteItems;
        return items.isEmpty
            ? _buildEmptyWishlist(context)
            : _buildWishlistContent(items);
      }),
    );
  }

  Widget _buildWishlistContent(List<FavoriteItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
              item.title,
              style: AppTextFont.bold(16, AppColors.secondary_text_color),
            ),
            subtitle: Text(
              'Age: ${item.age}',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () async {
                await favoriteController.removeFavorite(item.favoriteId);
              },
            ),
          ),
        );
      },
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
              textStyle: AppTextFont.regular(
                15,
                AppColors.secondary_text_color,
              ),
              onPressed: () => Get.back(),
              borderRadius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
