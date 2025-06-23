import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/controllers/wishlist_controller.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:clothing_exchange/views/screens/Product/create_post_screen.dart';
import 'package:clothing_exchange/views/screens/Profile/profile_screen.dart';
import 'package:clothing_exchange/views/screens/Wishlist/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Utils/colors.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();


  final List<Widget> _screens = [
    HomeScreen(),
    WishlistScreen(),
    CreatePostPage(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.favorite_border,
    Icons.add_circle_outline,
    CupertinoIcons.chat_bubble_text,
    CupertinoIcons.person,
  ];

  final List<IconData> _filledIcons = [
    Icons.home_filled,
    Icons.favorite,
    Icons.add_circle,
    CupertinoIcons.chat_bubble_text_fill,
    CupertinoIcons.person_fill,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        itemCount: _screens.length,
        itemBuilder: (context, index) {
          return _screens[index];
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.bottom_navigation_bg_color,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {

            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Get.find<HomeController>().fetchProducts();
                }
                if (index == 1) {
                  Get.find<WishlistController>().fetchFavorites();
                }
                // _pageController.animateToPage(
                //   index,
                //   duration: const Duration(milliseconds: 500),
                //   curve: Curves.easeInOut,
                // );

                _pageController.jumpToPage(index);
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bottom_navigation_bg_color,
                  boxShadow: [
                    BoxShadow(
                      offset:
                          selectedIndex == index ? Offset(0, 5) : Offset(0, 0),
                      color: AppColors.primaryColor,
                    ),
                  ],
                  border: Border.all(
                    color:
                        selectedIndex == index
                            // ? Colors.black
                            ? AppColors.secondaryColor
                            : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  selectedIndex == index ? _filledIcons[index] : _icons[index],
                  // color: Colors.black87,
                  color: AppColors.secondaryColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}





