// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../Utils/app_constants.dart';
// import '../Utils/helper_shared_pref.dart';
// import '../models/favorite_item_model.dart';
//
// class WishlistController extends GetxController {
//   var favoriteItems = <FavoriteItem>[].obs;
//
//   // Function to fetch favorite items from the API
//   Future<void> fetchFavorites() async {
//     final token = SharedPrefHelper().getData(AppConstants.token);
//
//     final response = await http.get(
//       Uri.parse('https://d7001.sobhoy.com/api/v1/favorite'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // Passing token for authentication
//       },
//     );
//
//     debugPrint(response.body.toString()); // Log the response
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);  // Decode the JSON response
//       final List attributes = data['data']['attributes'];  // Extract list of favorites
//       favoriteItems.value =
//           attributes.map((item) => FavoriteItem.fromJson(item)).toList();  // Map to FavoriteItem model
//     } else {
//       Get.snackbar("Error", "Failed to load wishlist");  // Show error message
//     }
//   }
// }
