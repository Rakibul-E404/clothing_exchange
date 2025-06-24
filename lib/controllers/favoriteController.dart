import 'dart:convert';
import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/favorite_item_model.dart';
import '../Utils/helper_shared_pref.dart';
import '../Utils/app_constants.dart';

class FavoriteController extends GetxController {
  var favoriteItems = <FavoriteItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchFavorites();
    super.onInit();
  }

  final String baseUrl =
      'https://d7001.sobhoy.com/api/v1/favorite'; // replace with your URL

  Future<String?> _getToken() async {
    return SharedPrefHelper().getData(AppConstants.token);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchFavorites() async {
    debugPrint('Fetcging Fav');
    isLoading.value = true;
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data.toString());
        final List attributes = data['data']['attributes'];
        favoriteItems.value =
            attributes.map((item) => FavoriteItem.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch favorites');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }

  addFavorite(String productId) async {
    isLoading.value = true;
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/$productId'),
        headers: headers,
      );
      debugPrint('===========>');
      debugPrint('$baseUrl/$productId');
      debugPrint('${response.body.toString()}');
      debugPrint('${response.statusCode.toString()}');

      // removeFavorite(productId) ;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.find<HomeController>().fetchProducts();
        // await fetchFavorites();
        debugPrint('${favoriteItems.length}');
        isLoading.value = false;
        return true;
      } else if (response.statusCode == 400) {
        Get.snackbar('Error', 'Product Already Added !!!');
        isLoading.value = false;
        return false;
      } else {
        Get.snackbar('Error', 'Failed to add favorite');
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> removeFavorite(String favoriteId) async {
    isLoading.value = true;
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$favoriteId'),
        headers: headers,
      );
      debugPrint('====DELETE Product');
      debugPrint(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 204) {
        favoriteItems.removeWhere((item) => item.productId == favoriteId);
        isLoading.value = false;
        Get.find<HomeController>().fetchProducts();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to remove favorite');
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      isLoading.value = false;
      return false;
    }
  }

  bool isFavorite(String productId) {
    return favoriteItems.any((item) => item.productId == productId);
  }

  FavoriteItem? getFavoriteItemByProductId(String productId) {
    try {
      return favoriteItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}
