import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/favorite_item_model.dart';

class WishlistController extends GetxController {
  var favoriteItems = <FavoriteItem>[].obs;

  Future<void> fetchFavorites() async {
    final response = await http.get(Uri.parse('https://d7001.sobhoy.com/api/v1/favorite'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List attributes = data['data']['attributes'];
      favoriteItems.value = attributes.map((item) => FavoriteItem.fromJson(item)).toList();
    } else {
      Get.snackbar("Error", "Failed to load wishlist");
    }
  }
}
