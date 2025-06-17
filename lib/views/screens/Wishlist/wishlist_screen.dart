import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import '../../../controllers/favoriteController.dart';
import '../../../models/favorite_item_model.dart';
import '../Chat/chat_list_screen.dart';
import '../Product/create_post_screen.dart';
import '../Profile/profile_screen.dart';
import '../Home/home_screen.dart';

class WishlistScreen extends StatelessWidget {
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final RxInt currentIndex = 1.obs; // Set initial index to 1 for Wishlist

  WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('checking the wishlist');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wishlist'),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final items = favoriteController.favoriteItems;
        return items.isEmpty
            ? _buildEmptyWishlist(context)
            : _buildWishlistContent(items);
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.bottom_navigation_bg_color,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex.value,
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: AppColors.onSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) => _onItemTapped(index),
          items: [
            _buildNavBarItem('assets/icons/home_icon.svg', 'Home', 0),
            _buildNavBarItem('assets/icons/wishlist_icon.svg', 'Wishlist', 1),
            _buildNavBarItem('assets/icons/post_icon.svg', 'Post', 2),
            _buildNavBarItem('assets/icons/chat_icon.svg', 'Chat', 3),
            _buildNavBarItem('assets/icons/profile_icon.svg', 'Profile', 4),
          ],
        ),
      ),
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
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(
              item.title,
              style: AppTextFont.bold(16, AppColors.secondary_text_color),
            ),
            subtitle: Text(
              'Age: ${item.age}',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
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
          const SizedBox(height: 50),
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
