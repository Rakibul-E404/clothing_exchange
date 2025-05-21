import 'dart:convert';
import 'dart:developer';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
import 'package:clothing_exchange/models/product_model.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxList<Product> productList = <Product>[].obs;

  @override
  Future<void> onInit() async {
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      final response = await http.get(
        Uri.parse(AppUrl.allProduct),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('API Response: ${response.body}');
      final jsonMap = jsonDecode(response.body);
      final List<dynamic> productListJson =
          jsonMap['data']['attributes']['data'];

      productList.value =
          productListJson.map<Product>((json) {
            final product = Product.fromJson(json);
            log(
              'Loaded Product show: ${product.title} | Age: ${product.age} | Size: ${product.size} | Gender: ${product.gender}',
            );
            return product;
          }).toList();

      log('Total products loaded: ${productList.length}');
    } catch (e) {
      // checking for error
      log('Error fetching products: $e');
    }
  }
}
