import 'dart:developer';
import 'package:get/get.dart';
import 'package:clothing_exchange/models/product_model.dart';

class SearchBoxController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<Product> searchResults = <Product>[].obs;

  void searchProducts(String query, List<Product> allProducts) {
    searchQuery.value = query.toLowerCase().trim();

    if (searchQuery.isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.value = allProducts.where((product) {
      return product.title.toLowerCase().contains(searchQuery.value);
    }).toList();

    log('Search found ${searchResults.length} products for "$query"');
  }
}
