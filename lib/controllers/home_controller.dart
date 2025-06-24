import 'dart:convert';
import 'dart:developer';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
import 'package:clothing_exchange/models/product_model.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final RxList<Product> productList = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    await fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      // productList.clear();
      isLoading(true);
      errorMessage('');

      final token = SharedPrefHelper().getData(AppConstants.token);
      final response = await http.get(
        Uri.parse(AppUrl.allProduct),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('API Response: ${response.body}');

      if (response.statusCode == 200) {
        print('oksjdksjdskd');
        final jsonMap = jsonDecode(response.body);
        debugPrint(jsonMap.toString());
        final List<dynamic> productListJson =
            jsonMap['data']['attributes']['data'];
        debugPrint(productListJson.length.toString());
        productList.value =
            productListJson.map<Product>((json) {
              final product = Product.fromJson(json);
              log('Loaded Product: ${product.title} | id: ${product.id}');
              return product;
            }).toList();
      } else {
        errorMessage('Failed to load products (${response.statusCode})');
      }
    } catch (e) {
      log('Error fetching products: $e');
      errorMessage('Error loading products: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  addWishList(String productId, int index) async {
    var token = await SharedPrefHelper().getData(AppConstants.token);

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.wishlistEndPoint}/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // removeFavorite(productId) ;
      if (response.statusCode == 200 || response.statusCode == 201) {
        productList[index].wishlistStatus = !productList[index].wishlistStatus;
        productList.refresh();
      }
    } catch (e) {
      print('Error>>>>>>>>>>>>.$e');
      Get.snackbar('Error', e.toString());
      isLoading.value = false;
      return false;
    }
  }
}
