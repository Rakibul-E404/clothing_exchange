// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:clothing_exchange/Utils/app_constants.dart';
// import 'package:clothing_exchange/Utils/app_url.dart';
// import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
//
// class UserService {
//   Future<Map<String, dynamic>?> fetchUserProfile() async {
//     try {
//       final token = SharedPrefHelper().getData(AppConstants.token);
//       print('Token in UserService: $token');
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
//
//         final userName = data['data']?['attributes']?['user']?['name'];
//
//         if (userName != null) {
//           return {'name': userName};
//         } else {
//           print('Name not found in response.');
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
// }




///
///
///
/// toto:: updating
///
///
///



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';

class UserService {
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      print('Token in UserService: $token');

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
            'name': user['name'],
            'email': user['email'],
            'phone': user['phone'],
            'image': user['image'], // image path relative to base url
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
}
