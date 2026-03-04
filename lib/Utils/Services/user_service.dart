/**
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';

class UserService {
  // Fetch User Profile
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/users/self/in'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data']?['attributes']?['user'];

        if (user != null) {
          return {
            'name': user['name'] ?? '',
            'email': user['email'] ?? '',
            'phone': user['phone'] ?? '',
            'address': user['address'] ?? '',
            'image': user['image'],
          };
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update User Profile
  Future<bool> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? image,
  }) async {
    final token = SharedPrefHelper().getData(AppConstants.token);
    if (token == null) return false;

    try {
      var uri = Uri.parse('${AppUrl.baseUrl}/users/self/update');
      var request = http.MultipartRequest('PATCH', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['address'] = address;

      if (image != null) {
        final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Fetch Product Details
  Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('https://d7001.sobhoy.com/api/v1/products/single/$productId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final product = data['data']?['attributes'];

        if (product != null) {
          return {
            'title': product['title'],
            'description': product['description'],
            'age': product['age'],
            'size': product['size'],
            'gender': product['gender'],
            'location': product['location'],
            'imageUrl': product['image'],
            'price': 'Price not available', // You can add a price field if available
          };
        }
      }
      return null;
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }
}
*/




///
///
///
/// todo::: upper id ok ...getting the user Id
///
///
///
///




import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';

class UserService {
  // Fetch User Profile - UPDATED to include user ID
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      if (token == null) {
        print('❌ No token found');
        return null;
      }

      print('📤 Fetching user profile from: ${AppUrl.baseUrl}/users/self/in');

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/users/self/in'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Full API response: $data');

        // Extract user data from nested structure
        final user = data['data']?['attributes']?['user'];

        if (user != null) {
          print('✅ User data extracted: $user');

          // Get the user ID - THIS WAS MISSING BEFORE
          final userId = user['id']?.toString();

          print('📦 User ID found: $userId');

          // Return COMPLETE user data including ID
          return {
            'id': userId, // NOW INCLUDING THE USER ID
            'name': user['name'] ?? '',
            'email': user['email'] ?? '',
            'phone': user['phone'] ?? '',
            'address': user['address'] ?? '',
            'image': user['image'] ?? '',
            'dateOfBirth': user['dateOfBirth'],
            'role': user['role'],
            'isSubscribed': user['isSubscribed'] ?? false,
            'follower': user['follower'] ?? 0,
            'following': user['following'] ?? 0,
          };
        } else {
          print('❌ No user data found in response');
        }
      } else {
        print('❌ Failed to fetch user profile: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  // Update User Profile
  Future<bool> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? image,
  }) async {
    final token = SharedPrefHelper().getData(AppConstants.token);
    if (token == null) {
      print('❌ No token found for update');
      return false;
    }

    try {
      var uri = Uri.parse('${AppUrl.baseUrl}/users/self/update');
      var request = http.MultipartRequest('PATCH', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['address'] = address;

      if (image != null) {
        final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        );
        print('📸 Image attached: ${image.path}');
      }

      print('📤 Sending update request...');
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('📥 Update response status: ${response.statusCode}');
      print('📥 Update response body: $respStr');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error updating user profile: $e');
      return false;
    }
  }

  // Fetch Product Details
  Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    try {
      print('📤 Fetching product details for ID: $productId');

      final response = await http.get(
        Uri.parse('https://d7001.sobhoy.com/api/v1/products/single/$productId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 Product response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Product data received');

        final product = data['data']?['attributes'];

        if (product != null) {
          return {
            'title': product['title'],
            'description': product['description'],
            'age': product['age'],
            'size': product['size'],
            'gender': product['gender'],
            'location': product['location'],
            'imageUrl': product['image'],
            'price': 'Price not available',
          };
        }
      }
      return null;
    } catch (e) {
      print('❌ Error fetching product details: $e');
      return null;
    }
  }

  // NEW: Helper method to get current user ID
  Future<String?> getCurrentUserId() async {
    try {
      final userData = await fetchUserProfile();
      if (userData != null && userData['id'] != null) {
        return userData['id'];
      }
      return null;
    } catch (e) {
      print('❌ Error getting current user ID: $e');
      return null;
    }
  }
}