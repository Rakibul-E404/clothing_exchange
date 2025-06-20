import 'dart:convert';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';

import '../../views/screens/Chat/inbox_chat_screen.dart';

class ChatService {
  // POST method to create a conversation
  createConversation({required String productId}) async {
    final token = await SharedPrefHelper().getData(AppConstants.token);

    if (token == null || token.isEmpty) {
      throw Exception("No authentication token found");
    }

    final url = '${AppUrl.baseUrl}/conversation/create';

    final Map<String, dynamic> requestBody = {"product": productId};

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    // debugPrint(response.body.toString());
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      debugPrint(jsonResponse.toString());
      if (jsonResponse['code'] == 200) {
        final conversationId = jsonResponse['data']['attributes']['id'];
        debugPrint('================>');
        debugPrint(conversationId);
        Get.find<ChatController>().fetchSingleMessage(
          conversationId: conversationId,
        );
        Get.to(
          () => InboxChatScreen(
            name: jsonResponse['data']['attributes']['receiver']['name'],
          ),
        );

        // Get.to(() => ChatListScreen());
        // return jsonResponse['data'];
      } else {
        debugPrint('pasdofpadsofsadfjoijdasf');

        throw Exception(
          'Failed to create conversation: ${jsonResponse['message']}',
        );
      }
    } else {
      Get.snackbar(
        'Error',
        jsonResponse["message"] ,

        snackPosition: SnackPosition.BOTTOM,
        // Show the Snackbar at the bottom
        backgroundColor: Colors.red,
        // Set a background color to indicate an error
        colorText: Colors.white,
        // Set the text color to white
        icon: Icon(
          Icons.error, // Error icon
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(10),
        // Add margin for spacing
        borderRadius: 8,
        // Round the corners
        duration: const Duration(
          seconds: 3,
        ), // Set the duration for how long it stays
      );

      // throw Exception(
      //   'Failed to create conversation. Status code: ${response.statusCode}',
      // );
    }
  }



}
