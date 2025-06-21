// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:lottie/lottie.dart';
//
// // Controllers
// import 'package:clothing_exchange/controllers/home_controller.dart';
// import 'package:clothing_exchange/controllers/search_controller.dart';
// import 'package:clothing_exchange/controllers/favoriteController.dart';
//
// // Models
// import 'package:clothing_exchange/models/product_model.dart';
//
// // Services
// import 'package:clothing_exchange/utils/services/user_service.dart';
//
// // Utils
// import 'package:clothing_exchange/utils/app_url.dart';
// import 'package:clothing_exchange/utils/colors.dart';
//
// // Screens
// import 'package:clothing_exchange/views/screens/Product/product_details_screen.dart';
// import 'package:clothing_exchange/views/screens/Notification/notification_screen.dart';
// import 'package:clothing_exchange/views/screens/Home/Filter/popup_filter.dart';
//
// // Widgets
// import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
// import 'package:clothing_exchange/views/widget/customTextField.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String? selectedAgeRange;
//   String? selectedSize;
//   String? selectedGender;
//   String userName = '';
//   bool isLoadingUserName = true;
//   String? currentUserId;
//
//   final FavoriteController favoriteController = Get.find<FavoriteController>();
//   final UserService userService = UserService();
//   final TextEditingController _searchController = TextEditingController();
//   final RxList<Product> filteredProducts = <Product>[].obs;
//   final HomeController homeController = Get.put(HomeController());
//   final SearchBoxController searchController = Get.put(SearchBoxController());
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//     ever(homeController.productList, (_) => applyFilters());
//     ever(searchController.searchQuery, (_) => applyFilters()); // Watch search query changes
//   }
//
//   Future<void> _loadUserName() async {
//     final userData = await userService.fetchUserProfile();
//     setState(() {
//       userName = userData?['name'] ?? 'User';
//       currentUserId = userData?['id'];
//       isLoadingUserName = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void applyFilters() {
//     final List<Product> allProducts = homeController.productList;
//
//     // First, filter products based on the search query
//     final List<Product> searchFilteredProducts = allProducts.where((product) {
//       return product.title.toLowerCase().contains(searchController.searchQuery.value.toLowerCase());
//     }).toList();
//
//     // Then, apply age, size, and gender filters to the already filtered products
//     final List<Product> filtered = searchFilteredProducts.where((product) {
//       final bool matchesAge =
//           selectedAgeRange == null ||
//               product.age
//                   .replaceAll(RegExp(r'[^0-9-]'), '')
//                   .contains(selectedAgeRange!.replaceAll(RegExp(r'[^0-9-]'), ''));
//
//       final bool matchesSize =
//           selectedSize == null ||
//               product.size.toLowerCase().startsWith(selectedSize!.toLowerCase()[0]);
//
//       final bool matchesGender =
//           selectedGender == null ||
//               product.gender.toLowerCase() == selectedGender!.toLowerCase() ||
//               product.gender.toLowerCase() ==
//                   '${selectedGender!.toLowerCase()}s' ||
//               (selectedGender == 'boys' && product.gender.toLowerCase() == 'boy') ||
//               (selectedGender == 'girls' && product.gender.toLowerCase() == 'girl');
//
//       return matchesAge && matchesSize && matchesGender;
//     }).toList();
//
//     // Update the filtered products list
//     filteredProducts.value = filtered;
//   }
//
//   List<Product> getDisplayProducts() {
//     return filteredProducts.isEmpty && searchController.searchQuery.isNotEmpty
//         ? [] // If there are no filtered products and the search query is active, return an empty list
//         : filteredProducts;
//   }
//
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => FilterBottomSheet(
//         selectedAgeRange: selectedAgeRange,
//         selectedSize: selectedSize,
//         selectedGender: selectedGender,
//         onApply: (age, size, gender) {
//           setState(() {
//             selectedAgeRange = age;
//             selectedSize = size;
//             selectedGender = gender;
//             applyFilters();
//           });
//         },
//       ),
//     );
//   }
//
//   Widget _buildProductCard(Product product) {
//     final RxBool isFavorite = favoriteController.isFavorite(product.id).obs;
//     final fullImageUrl = '${AppUrl.imageBaseUrl}${product.image}';
//
//     return GestureDetector(
//       onTap: () => Get.to(() => ProductDetailsScreen(
//         title: product.title,
//         age: product.age,
//         size: product.size,
//         gender: product.gender,
//         location: product.location,
//         imageUrl: fullImageUrl,
//         description: product.description,
//         productId: product.id,
//       )),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: CachedNetworkImage(
//                       imageUrl: fullImageUrl,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(color: Colors.white),
//                       ),
//                       errorWidget: (context, url, error) => Container(
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.error, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Age: ${product.age}',
//                         style: const TextStyle(fontSize: 12),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: IconButton(
//                 icon: Icon(
//                   product.wishlistStatus ? Icons.favorite : Icons.favorite_border,
//                   color: product.wishlistStatus ? Colors.red : AppColors.secondaryColor,
//                 ),
//                 onPressed: () async {
//                   if (favoriteController.isLoading.value == true) {
//                     return;
//                   }
//                   product.wishlistStatus
//                       ? await favoriteController.removeFavorite(product.id)
//                       : await favoriteController.addFavorite(product.id);
//                   setState(() {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmerGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.8,
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 15,
//       ),
//       itemCount: 6,
//       itemBuilder: (_, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(child: Container(color: Colors.white)),
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 16,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(height: 8),
//                       Container(width: 100, height: 14, color: Colors.white),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildProductGrid(List<Product> products) {
//     return Column(
//       children: [
//         if (searchController.searchQuery.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Text(
//               'Search results for "${searchController.searchQuery.value}"',
//               style: const TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           ),
//         if (selectedAgeRange != null ||
//             selectedSize != null ||
//             selectedGender != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Text(
//               'Filters: ${selectedAgeRange ?? ''} ${selectedSize ?? ''} ${selectedGender ?? ''}',
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//         Obx(() {
//           if (homeController.isLoading.value &&
//               homeController.productList.isEmpty) {
//             return _buildShimmerGrid();
//           }
//           return products.isEmpty
//               ? Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
//                 const SizedBox(height: 10),
//                 Text(
//                   searchController.searchQuery.isNotEmpty
//                       ? 'No products found for "${searchController.searchQuery.value}"'
//                       : 'No products match your filters',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           )
//               : GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.8,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//             ),
//             itemCount: products.length,
//             itemBuilder: (_, index) => _buildProductCard(products[index]),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.onSecondary,
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () => _showFilterBottomSheet(context),
//             child: SvgPicture.asset(
//               'assets/icons/filter_icon.svg',
//               width: 30,
//               height: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
//               decoration: const BoxDecoration(
//                 color: AppColors.secondaryColor,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(15),
//                   bottomRight: Radius.circular(15),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       isLoadingUserName
//                           ? SizedBox(
//                         height: 60,
//                         width: 60,
//                         child: Lottie.asset(
//                           'assets/animations/loading.json',
//                           fit: BoxFit.contain,
//                         ),
//                       )
//                           : Text(
//                         'Hi, $userName',
//                         style: AppTextFont.bold(24, AppColors.onSecondary),
//                       ),
//                       GestureDetector(
//                         onTap: () => Get.to(() => const NotificationScreen()),
//                         child: SvgPicture.asset(
//                           'assets/icons/notification_icon.svg',
//                           width: 35,
//                           height: 35,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Swap or exchange your child\'s products here',
//                     style: AppTextFont.regular(16, AppColors.onSecondary),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Search Box
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextField(
//                         controller: _searchController,
//                         borderRadius: 10,
//                         hintText: 'Find your favorite item here...',
//                         svgIconPath: 'assets/icons/search_icon.svg',
//                         hoverColor: AppColors.primaryColor,
//                         keyboardType: TextInputType.text,
//                         onChanged: (value) {
//                           searchController.searchQuery.value = value;
//                           applyFilters();
//                         },
//                       ),
//                     ),
//                     if (_searchController.text.isNotEmpty)
//                       IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           _searchController.clear();
//                           searchController.searchQuery.value = '';
//                           applyFilters();
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Product List
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildSectionTitle('Recently Uploaded'),
//                     _buildProductGrid(getDisplayProducts()),
//                     const SizedBox(height: 16),
//                     _buildSectionTitle('All Items'),
//                     _buildProductGrid(getDisplayProducts()),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//





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
import 'package:clothing_exchange/views/screens/Notification/notification_screen.dart';
import 'package:clothing_exchange/views/screens/Home/Filter/popup_filter.dart';

// Widgets
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/widget/customTextField.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedAgeRange;
  String? selectedSize;
  String? selectedGender;
  String userName = '';
  bool isLoadingUserName = true;
  String? currentUserId;

  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final UserService userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  final RxList<Product> filteredProducts = <Product>[].obs;
  final HomeController homeController = Get.put(HomeController());
  final SearchBoxController searchController = Get.put(SearchBoxController());

  @override
  void initState() {
    super.initState();
    _loadUserName();
    ever(homeController.productList, (_) => applyFilters());
    ever(searchController.searchQuery, (_) => applyFilters()); // Watch search query changes
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

    // First, filter products based on the search query
    final List<Product> searchFilteredProducts = allProducts.where((product) {
      return product.title.toLowerCase().contains(searchController.searchQuery.value.toLowerCase());
    }).toList();

    // Then, apply age, size, and gender filters to the already filtered products
    final List<Product> filtered = searchFilteredProducts.where((product) {
      final bool matchesAge =
          selectedAgeRange == null ||
              product.age
                  .replaceAll(RegExp(r'[^0-9-]'), '')
                  .contains(selectedAgeRange!.replaceAll(RegExp(r'[^0-9-]'), ''));

      final bool matchesSize =
          selectedSize == null ||
              product.size.toLowerCase().startsWith(selectedSize!.toLowerCase()[0]);

      final bool matchesGender =
          selectedGender == null ||
              product.gender.toLowerCase() == selectedGender!.toLowerCase() ||
              product.gender.toLowerCase() ==
                  '${selectedGender!.toLowerCase()}s' ||
              (selectedGender == 'boys' && product.gender.toLowerCase() == 'boy') ||
              (selectedGender == 'girls' && product.gender.toLowerCase() == 'girl');

      debugPrint(product.createdAt.toString());
      return matchesAge && matchesSize && matchesGender;
    }).toList();

    // Update the filtered products list
    filteredProducts.value = filtered;
  }

  // Filter for recently uploaded products (last 24 hours)
  List<Product> getRecentlyUploadedProducts() {
    final currentTime = DateTime.now();

    final twentyFourHoursAgo = currentTime.subtract(Duration(hours: 24));

    debugPrint('${twentyFourHoursAgo}');
    return homeController.productList.where((product) {
      final DateTime createdAt = DateTime.parse(product.createdAt.toString());
      return createdAt.isAfter(twentyFourHoursAgo);
    }).toList();
  }

  List<Product> getDisplayProducts() {
    return filteredProducts.isEmpty && searchController.searchQuery.isNotEmpty
        ? [] // If there are no filtered products and the search query is active, return an empty list
        : filteredProducts;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
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
      onTap: () => Get.to(() => ProductDetailsScreen(
        title: product.title,
        age: product.age,
        size: product.size,
        gender: product.gender,
        location: product.location,
        imageUrl: fullImageUrl,
        description: product.description,
        productId: product.id,
      )),
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
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
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
              child: IconButton(
                icon: Icon(
                  product.wishlistStatus ? Icons.favorite : Icons.favorite_border,
                  color: product.wishlistStatus ? Colors.red : AppColors.secondaryColor,
                ),
                onPressed: () async {
                  if (favoriteController.isLoading.value == true) {
                    return;
                  }
                  product.wishlistStatus
                      ? await favoriteController.removeFavorite(product.id)
                      : await favoriteController.addFavorite(product.id);
                  setState(() {});
                },
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
                          searchController.searchQuery.value = value;
                          applyFilters();
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchController.searchQuery.value = '';
                          applyFilters();
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
                    _buildProductGrid(getRecentlyUploadedProducts()), // Show only recent products
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
    );
  }
}
