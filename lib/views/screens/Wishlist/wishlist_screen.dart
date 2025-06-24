import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import '../../../controllers/favoriteController.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../models/favorite_item_model.dart';
import '../Chat/chat_list_screen.dart';
import '../Product/create_post_screen.dart';
import '../Product/product_details_screen.dart';
import '../Profile/profile_screen.dart';
import '../Home/home_screen.dart';

class WishlistScreen extends StatelessWidget {
  // Use the correct controller name - either WishlistController or rename your controller to FavoriteController
  // final WishlistController favoriteController = Get.find<WishlistController>();
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final RxInt currentIndex = 1.obs;

  WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('checking the wishlist');

    // Fetch favorites when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      favoriteController.fetchFavorites();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wishlist'),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final items = favoriteController.favoriteItems;
        debugPrint('Favorite items count: ${items.length}');

        // Debug print each item
        for (var item in items) {
          debugPrint('Item title: ${item.title}');
          debugPrint('Item description: ${item.description}');
        }

        return items.isEmpty
            ? _buildEmptyWishlist(context)
            : _buildWishlistContent(items);
      }),
    );
  }

  void _onItemTapped(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.find<HomeController>().fetchProducts();
        Get.offAll(() => HomeScreen());
        break;
      case 1:
        Get.offAll(() => WishlistScreen());
        break;
      case 2:
        Get.offAll(() => const CreatePostPage());
        break;
      case 3:
        Get.offAll(() => ChatListScreen());
        break;
      case 4:
        Get.offAll(() => const ProfileScreen());
        break;
    }
  }

  Widget _buildWishlistContent(List<FavoriteItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final imageUrl = 'https://d7001.sobhoy.com/${item.image}';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            title: Text(
              item.title.isNotEmpty ? item.title.toUpperCase() : 'No Title',
              // Add fallback for title
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age: ${item.age}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Description: ${item.description}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(CupertinoIcons.delete_simple, color: Colors.red),
              onPressed: () async {
                // Make sure your controller has this method
                await favoriteController.removeFavorite(item.productId);
                Get.snackbar(
                  'Removed',
                  'Product Removed From Wishlist',

                );
              },
            ),
            onTap: () {
              // Navigate to ProductDetailsScreen
              Get.to(
                () => ProductDetailsScreen(
                  title: item.title,
                  productId: item.productId,
                  age: item.age,
                  size: item.size,
                  gender: item.gender,
                  location: item.location,
                  imageUrl: imageUrl,
                  description: item.description,
                ),
              );
            },
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
          const SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: CustomElevatedButton(
              elevation: 0,
              text: "Add now",
              textStyle: AppTextFont.regular(
                15,
                AppColors.secondary_text_color,
              ),
              onPressed: () => Get.offAll(() => MainBottomNavScreen()),
              borderRadius: 30,
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
    String iconPath,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          currentIndex.value == index
              ? AppColors.secondaryColor
              : AppColors.onSecondary,
          BlendMode.srcIn,
        ),
        width: 35,
        height: 35,
      ),
      activeIcon: CircleAvatar(
        backgroundColor: AppColors.icon_bg_circleAvater_color,
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.secondaryColor,
            BlendMode.srcIn,
          ),
          width: 35,
          height: 35,
        ),
      ),
      label: label,
    );
  }
}
