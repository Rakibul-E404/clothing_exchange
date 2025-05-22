// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:clothing_exchange/Utils/app_constants.dart';
// import 'package:clothing_exchange/Utils/app_url.dart';
// import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
// import 'dart:io';
//
// class UserService {
//   Future<Map<String, dynamic>?> fetchUserProfile() async {
//     try {
//       final token = SharedPrefHelper().getData(AppConstants.token);
//       print('token in UserService: $token');
//
//       if (token == null) {
//         print('No token found.');
//         return null;
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.baseUrl}/users/self/in'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print('User profile response status: ${response.statusCode}');
//       print('User profile response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final user = data['data']?['attributes']?['user'];
//
//         if (user != null) {
//           return {
//             'name': user['name'] ?? '',
//             'email': user['email'] ?? '',
//             'phone': user['phone'] ?? '',
//             'address': user['address'] ?? '',
//             'image': user['image'],
//           };
//         } else {
//           print('User object not found in response.');
//           return null;
//         }
//       } else {
//         print('Failed to fetch user profile: ${response.statusCode} ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching user profile: $e');
//       return null;
//     }
//   }
//
//   Future<bool> updateUserProfile({
//     required String name,
//     required String email,
//     required String phone,
//     required String address,
//     File? image,
//   }) async {
//     final token = SharedPrefHelper().getData(AppConstants.token);
//     if (token == null) return false;
//
//     try {
//       var uri = Uri.parse('${AppUrl.baseUrl}/users/self/update');
//       var request = http.MultipartRequest('PATCH', uri);
//
//       request.headers['Authorization'] = 'Bearer $token';
//
//       request.fields['name'] = name;
//       // request.fields['email'] = email;
//       request.fields['phone'] = phone;
//       request.fields['address'] = address;
//
//       if (image != null) {
//         request.files.add(await http.MultipartFile.fromPath('image', image.path));
//       }
//
//       // final response = await request.send();
//       //
//       // if (response.statusCode == 200) {
//       //   final respStr = await response.stream.bytesToString();
//       //   print('Update response: $respStr');
//       //   return true;
//       // } else {
//       //   print('Failed to update user profile: ${response.statusCode}');
//       //   return false;
//       // }
//
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//
//       print('Update status: ${response.statusCode}');
//       print('Update response body: $respStr');
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         return false;
//       }
//
//
//
//
//     } catch (e) {
//       print('Error updating user profile: $e');
//       return false;
//     }
//   }
// }



/// todo:: upload image


import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';

class UserService {
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      print('token in UserService: $token');

      if (token == null) {
        print('No token found.');
        return null;
      }

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/users/self/in'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('User profile response status: ${response.statusCode}');
      print('User profile response body: ${response.body}');

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
        } else {
          print('User object not found in response.');
          return null;
        }
      } else {
        print('Failed to fetch user profile: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

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
      // If your backend supports email update uncomment this:
      // request.fields['email'] = email;
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

      print('Update status: ${response.statusCode}');
      print('Update response body: $respStr');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }
}
