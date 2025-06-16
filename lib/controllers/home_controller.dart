import 'dart:convert';
import 'dart:developer';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
import 'package:clothing_exchange/models/product_model.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final RxList<Product> productList = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    await fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
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
        final jsonMap = jsonDecode(response.body);
        final List<dynamic> productListJson = jsonMap['data']['attributes']['data'];

        productList.value = productListJson.map<Product>((json) {
          final product = Product.fromJson(json);
          log('Loaded Product: ${product.title} | Age: ${product.age}');
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
}