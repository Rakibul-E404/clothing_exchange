

import 'dart:convert';
import 'dart:developer';

import 'package:clothing_exchange/models/conversation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import '../Utils/Services/socket_service.dart';
import '../Utils/app_constants.dart';
import '../Utils/app_url.dart';
import '../Utils/helper_shared_pref.dart';
import '../models/inbox_model.dart';
import '../views/screens/Chat/inbox_chat_screen.dart';

class MessageController extends GetxController{


  /// >>>>>>>>>>>>>>>>>>>>>> Conversation >>>>>>>>>>>>>>>>>>..


  RxList<ConversationModel> convertionsMessageListModel=<ConversationModel>[].obs;
  ScrollController scrollController=ScrollController();
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
          convertionsMessageListModel.value = List<ConversationModel>.from(attributes.map((x) => ConversationModel.fromJson(x)));
            conversationsLoading(false);

        update();

      } else {
        print('❌ Failed to load conversations (${response.statusCode})');
      }
    } catch (e) {
      log('❌ Error fetching conversations: $e');
    } finally {
      conversationsLoading(false);
    }
  }


  /// Inbox Controller

  RxList<InboxModel> inboxMessageListModel=<InboxModel>[].obs;

  var inboxPage = 1;
  var inboxFirstLoading=false.obs;
  var inboxLoadMoreLoading=false.obs;
  var inboxTotalPage = 0;
  var inboxCurrentPage = 0;



  /// All Inbox Message

  Future inboxFirstLoad(String conversationId)async{

    print('COnversation>>>>>>>${conversationId}');
    try {
      inboxFirstLoading(true);

      final token = SharedPrefHelper().getData(AppConstants.token);
      final response = await http.get(
        Uri.parse('${AppUrl.inboxEndPoint(conversationId)}&page=$inboxPage&limit=100'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        print('Data ✅: $jsonMap');

        final attributes = jsonMap['data']?['attributes']['data'];

          inboxMessageListModel.value= List<InboxModel>.from(attributes.map((x) => InboxModel.fromJson(x)));
          inboxCurrentPage=jsonMap['data']?['attributes']['page'];
          inboxTotalPage=jsonMap['data']?['attributes']['totalPages'];

          debugPrint("Current Check>>${inboxCurrentPage}");
          debugPrint("Total Check>>${inboxTotalPage}");

        inboxFirstLoading(false);

        update();

      } else {
        print('❌ Failed to load conversations (${response.statusCode})');
      }
    } catch (e) {
      log('❌ Error fetching conversations: $e');
    } finally {
      inboxFirstLoading(false);
    }
    // inboxPage=1;
    // inboxFirstLoading(true);
    // var response=await ApiClient.getData('${ApiConstants.inboxMessageEndPoint(conversationId)}&page=$inboxPage&limit=100');
    // if(response.statusCode==200){
    //   inboxMessageListModel.value= List<InboxModel>.from(response.body['data']['attributes']['data'].map((x) => InboxModel.fromJson(x)));
    //   inboxCurrentPage=response.body['data']['attributes']['page'];
    //   inboxTotalPage=response.body['data']['attributes']['totalPages'];
    //   debugPrint("Current Check>>${currentPage}");
    //   debugPrint("Total Check>>${totalPage}");
    //   // rxRequestStatus(Status.completed);
    //   inboxFirstLoading(false);
    //   update();
    // }else if(response.statusCode==404 || response.statusCode==400){
    //   inboxFirstLoading.value=false;
    //   update();
    // } else{
    //
    //   ApiChecker.checkApi(response);
    //   inboxFirstLoading.value=false;
    //   update();
    // }

  }
  inboxLoadMore(String conversationId)async{
    if(inboxFirstLoading !=true && inboxLoadMoreLoading ==false && inboxTotalPage !=inboxCurrentPage){

      debugPrint("Scroll return call Test");
      inboxPage +=1;
      inboxLoadMoreLoading (true);

      try {

        final token = SharedPrefHelper().getData(AppConstants.token);
        final response = await http.get(
          Uri.parse('${AppUrl.inboxEndPoint(conversationId)}&page=$inboxPage&limit=100'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonMap = jsonDecode(response.body);
          print('Data ✅: $jsonMap');

          final attributes = jsonMap['data']?['attributes']['data'];

         var result= inboxMessageListModel.value= List<InboxModel>.from(attributes.map((x) => InboxModel.fromJson(x)));
             inboxMessageListModel.addAll(result);
             inboxMessageListModel.refresh();

          inboxCurrentPage=jsonMap['data']?['attributes']['page'];
          inboxTotalPage=jsonMap['data']?['attributes']['totalPages'];

          debugPrint("Current Check>>${inboxCurrentPage}");
          debugPrint("Total Check>>${inboxTotalPage}");

          inboxLoadMoreLoading(false);
          update();

        } else {
          print('❌ Failed to load conversations (${response.statusCode})');
        }
      } catch (e) {
        log('❌ Error fetching conversations: $e');
      } finally {
        inboxLoadMoreLoading(false);
      }

      // var response =await ApiClient.getData('${ApiConstants.inboxMessageEndPoint(conversationId)}&page=$inboxPage&limit=100');
      // if(response.statusCode==200){
      //   debugPrint("All Check>>");
      //
      //   var result= List<InboxModel>.from(response.body['data']['attributes']['data'].map((x) => InboxModel.fromJson(x)));
      //   inboxCurrentPage=response.body['data']['attributes']['page'];
      //   inboxTotalPage=response.body['data']['attributes']['totalPages'];
      //   inboxMessageListModel.addAll(result);
      //   inboxMessageListModel.refresh();
      //   debugPrint("All Check>>${result}");
      //   // rxRequestStatus(Status.completed);
      //   inboxLoadMoreLoading(false);
      //   update();
      // }
      //
      // else{
      //   if (ApiClient.noInternetMessage == response.statusText) {
      //     inboxLoadMoreLoading.value=false;
      //     update();
      //     // setRxRequestStatus(Status.internetError);
      //   } else
      //     ApiChecker.checkApi(response);
      //   inboxLoadMoreLoading.value=false;
      //   update();
      // }

    }
  }

  /// Socket

  listenMessage(String conversationId) async {
    SocketApi.socket.on("new-message::$conversationId", (data) {
      debugPrint("=========> Response Message $data");
      InboxModel demoData = InboxModel.fromJson(data);
      inboxMessageListModel.add(demoData);
      inboxMessageListModel.refresh();
      update();
    });
  }

  socketOffListen(String conversationId)async{
    SocketApi.socket.off("new-message::$conversationId");
    debugPrint("Socket off New message");
  }
  /// Sent Message

  TextEditingController sentMesgCtrl=TextEditingController();
  var sentMessageLoading=true.obs;

  sentMessage(String conversationID,String type)async{

    print('check>>>>>');
    sentMessageLoading(true);
    final token = SharedPrefHelper().getData(AppConstants.token);
    var body={
      "conversationId":conversationID,
      "text":sentMesgCtrl.text.trim(),
      "type":type
    };

    try{
      final response = await http.post(
        Uri.parse(AppUrl.sentMessageEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:jsonEncode(body),);

      if(response.statusCode==200 || response.statusCode==201){
        sentMesgCtrl.clear();
        sentMessageLoading(false);
        update();

      }
      else{
        sentMessageLoading(false);
        update();
      }

    }catch(e){
      sentMessageLoading(false);
      update();
      log('❌ Error fetching conversations: $e');
    }

  }

  /// Chat Exchange Create

  var conversationCreateLoading=false.obs;


  conversationExchangeCreate(String conversationID)async{


    conversationCreateLoading(true);
    final token = SharedPrefHelper().getData(AppConstants.token);
    var body={
    "product":conversationID
  };

    try{
      final response = await http.post(
        Uri.parse(AppUrl.conversationCreateEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:jsonEncode(body),);

      if(response.statusCode==200 || response.statusCode==201){
        print('Test>>>>>>>');
        final jsonMap = jsonDecode(response.body);
        ConversationModel conversation = ConversationModel.fromJson(jsonMap['data']['attributes']);
         Get.to(()=>  InboxChatScreen(conversationModel:conversation));
        conversationCreateLoading(false);
        update();
      }
      else{
        print('Erro>>>>>>>');
        conversationCreateLoading(false);
        update();
      }

    }catch(e){
      conversationCreateLoading(false);
      update();
      log('❌ Error fetching conversations: $e');
    }

  }





}