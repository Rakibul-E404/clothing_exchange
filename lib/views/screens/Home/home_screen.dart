import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/controllers/search_controller.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/colors.dart';
import 'package:clothing_exchange/models/product_model.dart';
import 'package:clothing_exchange/views/screens/Product/product_details_screen.dart';
import 'package:clothing_exchange/views/screens/Wishlist/wishlist_screen.dart';
import 'package:clothing_exchange/views/screens/Product/create_post_screen.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Profile/profile_screen.dart';
import 'package:clothing_exchange/views/screens/Notification/notification_screen.dart';
import 'package:clothing_exchange/views/screens/Home/Filter/popup_filter.dart';
import '../../fonts_style/fonts_style.dart';
import '../../widget/customTextField.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? selectedAgeRange;
  String? selectedSize;
  String? selectedGender;

  final TextEditingController _searchController = TextEditingController();
  final RxList<Map<String, String>> favoriteProducts =
      RxList<Map<String, String>>([]);
  final RxList<Product> filteredProducts = <Product>[].obs;

  final HomeController homeController = Get.put(HomeController());
  final SearchBoxController searchController = Get.put(SearchBoxController());

  @override
  void initState() {
    super.initState();
    ever(homeController.productList, (_) => applyFilters());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void applyFilters() {
    final List<Product> allProducts = homeController.productList;

    final List<Product> filtered =
        allProducts.where((product) {
          final bool matchesAge =
              selectedAgeRange == null ||
              product.age
                  .replaceAll(RegExp(r'[^0-9-]'), '')
                  .contains(
                    selectedAgeRange!.replaceAll(RegExp(r'[^0-9-]'), ''),
                  );

          final bool matchesSize =
              selectedSize == null ||
              product.size.toLowerCase().startsWith(
                selectedSize!.toLowerCase()[0],
              );

          final bool matchesGender =
              selectedGender == null ||
              product.gender.toLowerCase() == selectedGender!.toLowerCase() ||
              product.gender.toLowerCase() ==
                  '${selectedGender!.toLowerCase()}s' ||
              (selectedGender == 'boys' &&
                  product.gender.toLowerCase() == 'boy') ||
              (selectedGender == 'girls' &&
                  product.gender.toLowerCase() == 'girl');

          return matchesAge && matchesSize && matchesGender;
        }).toList();

    filteredProducts.value = filtered;
  }

  List<Product> getDisplayProducts() {
    if (searchController.searchQuery.isNotEmpty) {
      return searchController.searchResults;
    }
    return (selectedAgeRange != null ||
            selectedSize != null ||
            selectedGender != null)
        ? filteredProducts
        : homeController.productList;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => FilterBottomSheet(
            selectedAgeRange: selectedAgeRange,
            selectedSize: selectedSize,
            selectedGender: selectedGender,
            onApply: (age, size, gender) {
              setState(() {
                selectedAgeRange = age;
                selectedSize = size;
                selectedGender = gender;
                applyFilters();
              });
            },
          ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(
          AppColors.secondaryColor,
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

  Widget _buildProductCard(
    String title,
    String age,
    String imageUrl,
    Product product,
  ) {
    final bool isFavorite = favoriteProducts.any(
      (p) => p['title'] == title && p['age'] == age,
    );

    return GestureDetector(
      onTap:
          () => Get.to(
            () => ProductDetailsScreen(
              title: title,
              age: age,
              size: product.size,
              gender: product.gender,
              location: product.location,
              imageUrl: '${AppUrl.imageBaseUrl}$imageUrl',
              price: '',
            ),
          ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        '${AppUrl.imageBaseUrl}$imageUrl',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Age: $age'),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.secondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoriteProducts.removeWhere(
                        (p) => p['title'] == title && p['age'] == age,
                      );
                    } else {
                      favoriteProducts.add({'title': title, 'age': age});
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Column(
      children: [
        if (searchController.searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Search results for "${searchController.searchQuery.value}"',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        if (selectedAgeRange != null ||
            selectedSize != null ||
            selectedGender != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Filters: ${selectedAgeRange ?? ''} ${selectedSize ?? ''} ${selectedGender ?? ''}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
                const SizedBox(height: 10),
                Text(
                  searchController.searchQuery.isNotEmpty
                      ? 'No products found for "${searchController.searchQuery.value}"'
                      : 'No products match your filters',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: products.length,
              itemBuilder: (_, index) {
                return _buildProductCard(
                  products[index].title,
                  products[index].age,
                  products[index].image,
                  products[index],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onSecondary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: SvgPicture.asset(
              'assets/icons/filter_icon.svg',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi, user',
                        style: AppTextFont.bold(24, AppColors.onSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const NotificationScreen()),
                        child: SvgPicture.asset(
                          'assets/icons/notification_icon.svg',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swap or exchange your child\'s products here',
                    style: AppTextFont.regular(16, AppColors.onSecondary),
                  ),
                ],
              ),
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _searchController,
                        borderRadius: 10,
                        hintText: 'Find your favorite item here...',
                        svgIconPath: 'assets/icons/search_icon.svg',
                        hoverColor: AppColors.primaryColor,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          searchController.searchProducts(
                            value,
                            (selectedAgeRange != null ||
                                    selectedSize != null ||
                                    selectedGender != null)
                                ? filteredProducts
                                : homeController.productList,
                          );
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchController.searchQuery.value = '';
                          searchController.searchResults.clear();
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Product List
            Expanded(
              child: Obx(() {
                final products = getDisplayProducts();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSectionTitle('Recently Uploaded'),
                      const SizedBox(height: 30),
                      _buildProductGrid(products),
                      const SizedBox(height: 30),
                      _buildSectionTitle('All'),
                      const SizedBox(height: 30),
                      _buildProductGrid(products),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottom_navigation_bg_color,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.onSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          if (_currentIndex == index) return;
          setState(() => _currentIndex = index);
          switch (index) {
            case 1:
              Get.to(() => WishlistScreen(favoriteProducts: favoriteProducts));
              break;
            case 2:
              Get.to(() => const CreatePostPage());
              break;
            case 3:
              Get.to(() => ChatListScreen());
              break;
            case 4:
              Get.to(() => const ProfileScreen());
              break;
            default:
              break;
          }
        },
        items: [
          _buildNavBarItem('assets/icons/home_icon.svg', 'Home'),
          _buildNavBarItem('assets/icons/wishlist_icon.svg', 'Wishlist'),
          _buildNavBarItem('assets/icons/post_icon.svg', 'Post'),
          _buildNavBarItem('assets/icons/chat_icon.svg', 'Chat'),
          _buildNavBarItem('assets/icons/profile_icon.svg', 'Profile'),
        ],
      ),
    );
  }
}

///
///
///
///
///
/// TODO::   set up the fav button
///
///
///
///
