import 'dart:convert';

import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/models/conversation_model.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import 'package:clothing_exchange/views/widget/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Added for DateFormat

import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../models/chat_model.dart';

class InboxChatScreen extends StatefulWidget {
  final ConversationModel conversationModel;


  const InboxChatScreen({super.key, required this.conversationModel});

  @override
  State<InboxChatScreen> createState() => _InboxChatScreenState();
}



class _InboxChatScreenState extends State<InboxChatScreen> {
  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Report an Issue with Your Product",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Let us know your issue, and we'll help resolve it as soon as possible.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              SizedBox(height: 16),
              Divider(height: 1),
              SizedBox(height: 16),
              CustomTextField(hintText: 'Subject', borderRadius: 30),
              SizedBox(height: 16),
              CustomTextField(hintText: 'Type Here', borderRadius: 20),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlinedButton(
                    onPressed: () => Get.back(),
                    text: 'Cancel',
                  ),
                  SizedBox(width: 8),
                  CustomElevatedButton(
                    text: "Submit",
                    borderRadius: 30,
                    onPressed: () => Get.to(ChatListScreen()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Exchange"),
        content: Text(
          "Are you sure you want to mark this exchange as done?",
        ),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              Get.back();
            },
            text: "Cancel",
          ),
          CustomElevatedButton(
            borderRadius: 30,
            text: "Confirm",
            onPressed: () {
              Get.to(HomeScreen());
            },
          ),
        ],
      ),
    );
  }

  var currentUserId='';
  var reciveImage='';
  var reciveName='';


  curentID()async{
    currentUserId=await SharedPrefHelper().getData(AppConstants.userId);
     reciveImage = currentUserId ==widget.conversationModel.receiver!.id ? widget.conversationModel.sender!.image! : widget.conversationModel.receiver!.image!;
     reciveName = currentUserId ==widget.conversationModel.receiver!.id ? widget.conversationModel.sender!.name! :widget.conversationModel.receiver!.name!;
     setState(() {});
  }



  @override
  void initState() {
    curentID();

    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    // Replace this with your actual logged-in user email from your auth logic
    final currentUserEmail = "john@example.com";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  Text(
                    reciveName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _showReportDialog(context);
                      },
                      icon: Icon(Icons.info_outline),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Active now",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          // Product Info Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: AppColors.secondaryColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(

                    "${widget.conversationModel.product!.title}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                  ),
                  SizedBox(height: 4),
                  Text(
                    "Age: 18-18 years",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Grey jeans for girls (10-13 years) easily used for a month. Comfortable and stylish, perfect for everyday wear—available for exchange",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Location: location, dhuba",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _showConfirmationDialog(context),
                      child: Text(
                        "Exchange Done",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat messages list
          Expanded(
            child: Obx(() {
              final messages = chatController.messageResponse.value?.data.attributes.data ?? [];

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isCurrentUser = msg.msgByUserId.email == currentUserEmail;
                  final messageText = msg.text ?? "";


                  DateTime parsedDate;
                  try {
                    parsedDate = DateTime.parse((msg.createdAt ?? '').toString());
                  } catch (_) {
                    parsedDate = DateTime.now();
                  }
                  final messageTime = DateFormat('hh:mm a').format(parsedDate);



                  final senderName = isCurrentUser ? currentUserEmail : (msg.msgByUserId.email ?? "Unknown");
                  final senderSubtitle = isCurrentUser ? null : "Of Counsel";

                  Widget messageBubble = Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(messageText),
                  );

                  if (!isCurrentUser) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(Icons.person, size: 16),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    senderName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (senderSubtitle != null)
                                    Text(
                                      senderSubtitle,
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  SizedBox(height: 4),
                                  messageBubble,
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              messageTime,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    senderName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  messageBubble,
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              messageTime,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(Icons.person, size: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }
                },
              );

            }),
          ),

          // Message input area
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Write Your Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.secondaryColor,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatController extends GetxController {
  Rxn<MessagesResponse> messageResponse = Rxn<MessagesResponse>();

  fetchSingleMessage({required String conversationId}) async {
    final token = await SharedPrefHelper().getData(AppConstants.token);
    final response = await http.get(
      Uri.parse(AppUrl.getSingleConversation(conversationId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint(response.toString());

    final responseBody = jsonDecode(response.body);
    messageResponse.value = MessagesResponse.fromJson(responseBody);

    debugPrint('Response body =====> ');
    debugPrint(messageResponse.value?.data.attributes.totalResults.toString());
  }
}



