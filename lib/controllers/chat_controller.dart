

import 'dart:convert';
import 'dart:developer';

import 'package:clothing_exchange/models/conversation_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import '../Utils/app_constants.dart';
import '../Utils/app_url.dart';
import '../Utils/helper_shared_pref.dart';

class MessageController extends GetxController{


  /// >>>>>>>>>>>>>>>>>>>>>> Conversation >>>>>>>>>>>>>>>>>>..


  RxList<ConversationModel> convertionsMessageListModel=<ConversationModel>[].obs;

  var conversationsLoading=false.obs;

  conversationGet() async {
    try {
      conversationsLoading(true);

      final token = SharedPrefHelper().getData(AppConstants.token);
      final response = await http.get(
        Uri.parse(AppUrl.conversationEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        print('Data ✅: $jsonMap');

        final attributes = jsonMap['data']?['attributes'];

        if (attributes != null && attributes is List) {
          convertionsMessageListModel.value = List<ConversationModel>.from(attributes.map((x) => ConversationModel.fromJson(x)),
          );
          print("✅ List loaded: ${convertionsMessageListModel.length} items");
          update();
        } else {
          print('⚠️ attributes is null or not a list');
        }
      } else {
        print('❌ Failed to load conversations (${response.statusCode})');
      }
    } catch (e) {
      log('❌ Error fetching conversations: $e');
    } finally {
      conversationsLoading(false);
    }
  }





}