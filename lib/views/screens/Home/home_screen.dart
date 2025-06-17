import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

// Controllers
import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/controllers/search_controller.dart';
import 'package:clothing_exchange/controllers/favoriteController.dart';

// Models
import 'package:clothing_exchange/models/product_model.dart';

// Services
import 'package:clothing_exchange/utils/services/user_service.dart';

// Utils
import 'package:clothing_exchange/utils/app_url.dart';
import 'package:clothing_exchange/utils/colors.dart';

// Screens
import 'package:clothing_exchange/views/screens/Product/product_details_screen.dart';
import 'package:clothing_exchange/views/screens/Product/create_post_screen.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Profile/profile_screen.dart';
import 'package:clothing_exchange/views/screens/Notification/notification_screen.dart';
import 'package:clothing_exchange/views/screens/Home/Filter/popup_filter.dart';
import 'package:clothing_exchange/views/screens/Wishlist/wishlist_screen.dart';

// Widgets
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customTextField.dart';

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
  String userName = '';
  bool isLoadingUserName = true;
  String? currentUserId;

  final FavoriteController favoriteController = Get.put(FavoriteController());
  final UserService userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  final RxList<Product> filteredProducts = <Product>[].obs;
  final HomeController homeController = Get.put(HomeController());
  final SearchBoxController searchController = Get.put(SearchBoxController());

  @override
  void initState() {
    super.initState();
    _loadUserName();
    // homeController.fetchProducts();
    ever(homeController.productList, (_) => applyFilters());
  }

  Future<void> _loadUserName() async {
    final userData = await userService.fetchUserProfile();
    setState(() {
      userName = userData?['name'] ?? 'User';
      currentUserId = userData?['id'];
      isLoadingUserName = false;
    });
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

  Widget _buildProductCard(Product product) {
    final RxBool isFavorite = favoriteController.isFavorite(product.id).obs;
    final fullImageUrl = '${AppUrl.imageBaseUrl}${product.image}';

    return GestureDetector(
      onTap:
          () => Get.to(
            () => ProductDetailsScreen(
              title: product.title,
              age: product.age,
              size: product.size,
              gender: product.gender,
              location: product.location,
              imageUrl: fullImageUrl,
              description: product.description,
              productId: product.id,
              // price: '',
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: fullImageUrl,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.grey),
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
                        product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Age: ${product.age}',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Obx(
                () => IconButton(
                  icon: Icon(
                    // isFavorite.value ? Icons.favorite : Icons.favorite_border,
                    product.wishlistStatus
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        isFavorite.value
                            ? Colors.red
                            : AppColors.secondaryColor,
                  ),
                  onPressed: () async {
                    // isFavorite.toggle();
                    await favoriteController.addFavorite(product.id) ;
                    // product.wishlistStatus
                    //     ? await favoriteController.removeFavorite(product.id)
                    //     : await favoriteController.addFavorite(product.id);

                    // try {
                    //   if (isFavorite.value) {
                    //     await favoriteController.addFavorite(product.id);
                    //   } else {
                    //     final favItem = favoriteController
                    //         .getFavoriteItemByProductId(product.id);
                    //     if (favItem != null) {
                    //       await favoriteController.removeFavorite(
                    //         favItem.favoriteId,
                    //       );
                    //     }
                    //   }
                    // } catch (e) {
                    //   isFavorite.toggle();
                    //   Get.snackbar('Error', 'Failed to update favorite');
                    // }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (_, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Container(color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        Obx(() {
          if (homeController.isLoading.value &&
              homeController.productList.isEmpty) {
            return _buildShimmerGrid();
          }
          return products.isEmpty
              ? Padding(
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
              : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: products.length,
                itemBuilder: (_, index) => _buildProductCard(products[index]),
              );
        }),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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

  BottomNavigationBarItem _buildNavBarItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          _currentIndex == labelToIndex(label)
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

  int labelToIndex(String label) {
    switch (label) {
      case 'Home':
        return 0;
      case 'Wishlist':
        return 1;
      case 'Post':
        return 2;
      case 'Chat':
        return 3;
      case 'Profile':
        return 4;
      default:
        return 0;
    }
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
                      isLoadingUserName
                          ? SizedBox(
                            height: 60,
                            width: 60,
                            child: Lottie.asset(
                              'assets/animations/loading.json',
                              fit: BoxFit.contain,
                            ),
                          )
                          : Text(
                            'Hi, $userName',
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSectionTitle('Recently Uploaded'),
                    _buildProductGrid(getDisplayProducts()),
                    const SizedBox(height: 16),
                    _buildSectionTitle('All Items'),
                    _buildProductGrid(getDisplayProducts()),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
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
              Get.find<FavoriteController>().fetchFavorites();
              Get.to(() => WishlistScreen());
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

