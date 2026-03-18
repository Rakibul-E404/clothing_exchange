/**
import 'dart:convert';

import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/models/conversation_model.dart';
import 'package:clothing_exchange/models/inbox_model.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import 'package:clothing_exchange/views/widget/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Added for DateFormat

import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../models/chat_model.dart';
import '../../widget/network_image.dart';
import '../../widget/time_formet.dart';

class InboxChatScreen extends StatefulWidget {
  final ConversationModel conversationModel;
  const InboxChatScreen({super.key, required this.conversationModel});

  @override
  State<InboxChatScreen> createState() => _InboxChatScreenState();
}

class _InboxChatScreenState extends State<InboxChatScreen> {
  var currentUserId = '';
  var reciveImage = '';
  var reciveName = '';

  // Initialize ProfileScreenController
  late final ProfileScreenController _profileCtrl = Get.isRegistered<ProfileScreenController>()
      ? Get.find<ProfileScreenController>()
      : Get.put(ProfileScreenController());

  MessageController _chatCtrl = Get.put(MessageController());

  // Method to get current user ID from ProfileScreenController
  Future<String?> _getCurrentUserId() async {
    try {
      print('🔍 Attempting to get user ID from ProfileController...');

      // First check if controller already has userId
      String? userId = _profileCtrl.userId.value;

      if (userId.isNotEmpty) {
        print('✅ Found user ID from ProfileController: $userId');
        return userId;
      }

      // Try using getter method
      userId = _profileCtrl.getUserId();
      if (userId.isNotEmpty) {
        print('✅ Found user ID from getter: $userId');
        return userId;
      }

      // If not in controller, check SharedPreferences
      print('⚠️ No user ID in ProfileController, checking SharedPreferences...');
      await SharedPrefHelper.init();
      userId = await SharedPrefHelper().getString('userId');

      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences: $userId');
        // Update controller with this ID
        _profileCtrl.userId.value = userId;
        return userId;
      }

      // If still not found, wait a moment for API call to complete
      print('⏳ Waiting for API call to complete...');
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check again after delay
      userId = _profileCtrl.userId.value;
      if (userId.isNotEmpty) {
        print('✅ Found user ID after delay: $userId');
        return userId;
      }

      // One final check from SharedPreferences
      userId = await SharedPrefHelper().getString('userId');
      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences after delay: $userId');
        _profileCtrl.userId.value = userId;
        return userId;
      }

      print('❌ No user ID found anywhere');
      return null;
    } catch (e) {
      print('❌ Error getting user ID: $e');
      return null;
    }
  }

  // Method to get auth token
  Future<String?> _getAuthToken() async {
    try {
      await SharedPrefHelper.init();
      final token = await SharedPrefHelper().getString(AppConstants.token);
      print('🔑 Token exists: ${token != null}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  curentID() async {
    currentUserId = await SharedPrefHelper().getData(AppConstants.userId);
    reciveImage = currentUserId == widget.conversationModel.receiver!.id
        ? widget.conversationModel.sender!.image!
        : widget.conversationModel.receiver!.image!;
    reciveName = currentUserId == widget.conversationModel.receiver!.id
        ? widget.conversationModel.sender!.name!
        : widget.conversationModel.receiver!.name!;
    setState(() {});
  }

  @override
  void initState() {
    print('📱 ====== CURRENT OPEN INBOX ======');
    print('🆔 Conversation ID: ${widget.conversationModel.id}');
    print('📱 =================================');
    curentID();

    _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);

    _chatCtrl.listenMessage(widget.conversationModel.id!);

    _chatCtrl.scrollController.addListener(() {
      if (_chatCtrl.scrollController.position.pixels <=
          _chatCtrl.scrollController.position.minScrollExtent) {
      } else if (_chatCtrl.scrollController.position.pixels ==
          _chatCtrl.scrollController.position.maxScrollExtent) {
        _chatCtrl.inboxLoadMore(widget.conversationModel.id!);
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _chatCtrl.socketOffListen(widget.conversationModel.id!);
    // TODO: implement dispose
    super.dispose();
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
                      icon: Icon(Icons.arrow_back_ios),
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
                        _showReportDialog(context, widget.conversationModel.product!.id!);
                      },
                      icon: Icon(Icons.report_gmailerrorred),
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
      body: Obx(
            () => Column(
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
            _chatCtrl.inboxFirstLoading.value
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: GroupedListView<InboxModel, DateTime>(
                elements: _chatCtrl.inboxMessageListModel.value,
                controller: _chatCtrl.scrollController,
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                order: GroupedListOrder.DESC,
                itemComparator: (item1, item2) =>
                    item1.createdAt!.compareTo(item2.createdAt!),
                groupBy: (InboxModel message) => DateTime(
                  message.createdAt!.year,
                  message.createdAt!.month,
                  message.createdAt!.day,
                ),
                reverse: true,
                shrinkWrap: true,
                groupSeparatorBuilder: (DateTime date) {
                  return Center(child: Text(TimeFormatHelper.formatDate(date)));
                },
                itemBuilder: (context, InboxModel message) {
                  // print('Sent Id>>>${message.msgByUserId!.id}');
                  // print('CurentUser Id>>>${currentUserID}');

                  if (message.msgByUserId!.id == currentUserId) {
                    return senderBubble(context, message);
                  } else if (message.msgByUserId!.id != currentUserId) {
                    return receiverBubble(context, message);
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            // // Chat messages list
            // Expanded(d
            //   child: Obx(() {
            //     final messages = chatController.messageResponse.value?.data.attributes.data ?? [];
            //
            //     return ListView.builder(
            //       padding: EdgeInsets.all(16),
            //       itemCount: messages.length,
            //       reverse: true,
            //       itemBuilder: (context, index) {
            //         final msg = messages[messages.length - 1 - index];
            //         final isCurrentUser = msg.msgByUserId.email == currentUserEmail;
            //         final messageText = msg.text ?? "";
            //
            //
            //         DateTime parsedDate;
            //         try {
            //           parsedDate = DateTime.parse((msg.createdAt ?? '').toString());
            //         } catch (_) {
            //           parsedDate = DateTime.now();
            //         }
            //         final messageTime = DateFormat('hh:mm a').format(parsedDate);
            //
            //
            //
            //         final senderName = isCurrentUser ? currentUserEmail : (msg.msgByUserId.email ?? "Unknown");
            //         final senderSubtitle = isCurrentUser ? null : "Of Counsel";
            //
            //         Widget messageBubble = Container(
            //           padding: EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             color: Colors.grey.shade300,
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(8),
            //               bottomLeft: Radius.circular(8),
            //               bottomRight: Radius.circular(8),
            //             ),
            //           ),
            //           child: Text(messageText),
            //         );
            //
            //         if (!isCurrentUser) {
            //           return Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   CircleAvatar(
            //                     radius: 16,
            //                     backgroundColor: Colors.grey.shade300,
            //                     child: Icon(Icons.person, size: 16),
            //                   ),
            //                   SizedBox(width: 8),
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           senderName,
            //                           style: TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 12,
            //                           ),
            //                         ),
            //                         if (senderSubtitle != null)
            //                           Text(
            //                             senderSubtitle,
            //                             style: TextStyle(fontSize: 10, color: Colors.grey),
            //                           ),
            //                         SizedBox(height: 4),
            //                         messageBubble,
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(width: 8),
            //                   Text(
            //                     messageTime,
            //                     style: TextStyle(fontSize: 12, color: Colors.grey),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 16),
            //             ],
            //           );
            //         } else {
            //           return Column(
            //             crossAxisAlignment: CrossAxisAlignment.end,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.end,
            //                       children: [
            //                         Text(
            //                           senderName,
            //                           style: TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 12,
            //                           ),
            //                         ),
            //                         SizedBox(height: 4),
            //                         messageBubble,
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(width: 8),
            //                   Text(
            //                     messageTime,
            //                     style: TextStyle(fontSize: 12, color: Colors.grey),
            //                   ),
            //                   SizedBox(width: 8),
            //                   CircleAvatar(
            //                     radius: 16,
            //                     backgroundColor: Colors.grey.shade300,
            //                     child: Icon(Icons.person, size: 16),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 16),
            //             ],
            //           );
            //         }
            //       },
            //     );
            //
            //   }),
            // ),

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
                      controller: _chatCtrl.sentMesgCtrl,
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
                  InkWell(
                    onTap: () async {
                      if (_chatCtrl.sentMesgCtrl.text.trim().isNotEmpty) {
                        // Send message
                        await _chatCtrl.sentMessage(widget.conversationModel.id!, 'text');

                        // Clear the text field
                        _chatCtrl.sentMesgCtrl.clear();

                        // Refresh messages - scroll to bottom to show new message
                        _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);

                        // Scroll to bottom after a short delay to ensure messages are loaded
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (_chatCtrl.scrollController.hasClients) {
                            _chatCtrl.scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.secondaryColor,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed report dialog with API integration
  void _showReportDialog(BuildContext context, String productId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final isSubmitting = false.obs;

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
              CustomTextField(
                controller: titleController,
                hintText: 'Subject',
                borderRadius: 30,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Type Here',
                borderRadius: 20,
                // maxLines: 4,
              ),
              SizedBox(height: 24),
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomOutlinedButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel',
                    ),
                    SizedBox(width: 8),
                    isSubmitting.value
                        ? const SizedBox(
                      height: 40,
                      width: 40,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : CustomElevatedButton(
                      text: "Submit",
                      borderRadius: 30,
                      onPressed: () async {
                        // Validate fields
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        isSubmitting.value = true;

                        try {
                          // Get current user ID
                          final userId = await _getCurrentUserId();

                          print('🔍 Debug - Final User ID: $userId');

                          if (userId == null || userId.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please login first to report",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          // Get auth token
                          final token = await _getAuthToken();

                          if (token == null || token.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Session expired. Please login again.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          print('📤 Submitting report for product: $productId');
                          print('📤 Report data:');
                          print('   - reportBy: $userId');
                          print('   - title: ${titleController.text.trim()}');
                          print('   - description: ${descriptionController.text.trim()}');

                          final response = await http.post(
                            Uri.parse(
                                'https://api.bearemountclothing.co.uk/api/v1/report/$productId'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              "reportBy": userId,
                              "title": titleController.text.trim(),
                              "description": descriptionController.text.trim(),
                            }),
                          );

                          print('📥 Response status: ${response.statusCode}');
                          print('📥 Response body: ${response.body}');

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Fluttertoast.showToast(
                              msg: "Report submitted successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            Get.back(); // Close dialog
                          } else {
                            String errorMsg = "Failed to submit report";
                            try {
                              final errorResponse = json.decode(response.body);
                              if (errorResponse['message'] != null) {
                                errorMsg = errorResponse['message'];
                              } else if (errorResponse['error'] != null) {
                                errorMsg = errorResponse['error'];
                              }
                            } catch (_) {}

                            Fluttertoast.showToast(
                              msg: errorMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } catch (e) {
                          print('❌ Error in report submission: $e');
                          Fluttertoast.showToast(
                            msg: "Error: ${e.toString()}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } finally {
                          isSubmitting.value = false;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
            Get.offAll(() => MainBottomNavScreen());
          },
        ),
      ],
    ),
  );
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

Widget receiverBubble(BuildContext context, InboxModel message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomNetworkImage(
          imageUrl: '${AppUrl.imageBaseUrl}${message.msgByUserId!.image}',
          boxShape: BoxShape.circle,
          height: 30,
          width: 30),

      // Container(
      //   height: 38.h,
      //   width: 38.w,
      //   clipBehavior: Clip.antiAlias,
      //   decoration: const BoxDecoration(
      //     shape: BoxShape.circle,
      //   ),
      //   child: Image.asset(
      //     message['image']!,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      SizedBox(width: 8),
      Expanded(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
          backGroundColor: Colors.white,
          // backGroundColor: Color(0xffDCEFF9),

          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.57,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // message.type=='image'? CustomNetworkImage(
                //     imageUrl: '${ApiConstants.imageBaseUrl}${message.imageUrl}',
                //     borderRadius: BorderRadius.circular(8),
                //     height: 140,
                //     width: 155):

                Text(
                  '${message.text}',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                // Text(
                //   '${TimeFormatHelper.timeFormat(message.createdAt!.toLocal())}',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 8.sp,
                //   ),
                //   textAlign: TextAlign.end,
                // ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

//=============================================> Sender Bubble <========================================
Widget senderBubble(BuildContext context, InboxModel message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(
            type: BubbleType.sendBubble,
          ),
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 8, bottom: 8),
          backGroundColor: AppColors.primaryColor.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // message.type=='image'? CustomNetworkImage(
              //     imageUrl: '${ApiConstants.imageBaseUrl}${message.imageUrl}',
              //     borderRadius: BorderRadius.circular(8),
              //     height: 140.h,
              //     width: 155.w):
              //
              Text(
                '${message.text}',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.start,
              ),

              // Text(
              //   '${TimeFormatHelper.timeFormat(message.createdAt!.toLocal())}',
              //   textAlign: TextAlign.right,
              //   style: TextStyle(
              //       color: Colors.black, fontSize: 8),
              // ),
            ],
          ),
        ),
      ),
      SizedBox(width: 8),

      // Container(
      //   height: 38.h,
      //   width: 38.w,
      //   clipBehavior: Clip.antiAlias,
      //   decoration: const BoxDecoration(
      //     shape: BoxShape.circle,
      //   ),
      //   child: Image.asset(
      //     message['image']!,
      //     fit: BoxFit.cover,
      //   ),
      // ),

      // CustomNetworkImage(
      //     imageUrl: '${ApiConstants.imageBaseUrl}${message.msgByUserId!.profileImage}',
      //     boxShape: BoxShape.circle,
      //     height: 30.h,
      //     width: 30.w),
    ],
  );
}



*/






///
///
///
///
/// todo::: implementing the block and unblock
///
///
///
///





// import 'dart:convert';
//
// import 'package:clothing_exchange/Utils/app_url.dart';
// import 'package:clothing_exchange/models/conversation_model.dart';
// import 'package:clothing_exchange/models/inbox_model.dart';
// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:clothing_exchange/views/main_bottom_nav.dart';
// import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
// import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
// import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
// import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
// import 'package:clothing_exchange/views/widget/customTextField.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../../../Utils/app_constants.dart';
// import '../../../Utils/helper_shared_pref.dart';
// import '../../../controllers/chat_controller.dart';
// import '../../../controllers/profile_screen_controller.dart';
// import '../../../models/chat_model.dart';
// import '../../widget/network_image.dart';
// import '../../widget/time_formet.dart';
//
// class InboxChatScreen extends StatefulWidget {
//   final ConversationModel conversationModel;
//   const InboxChatScreen({super.key, required this.conversationModel});
//
//   @override
//   State<InboxChatScreen> createState() => _InboxChatScreenState();
// }
//
// class _InboxChatScreenState extends State<InboxChatScreen> {
//   var currentUserId = '';
//   var reciveImage = '';
//   var reciveName = '';
//   var opponentId = '';
//   var isBlocked = false.obs; // Add this to track block status
//
//   // Initialize ProfileScreenController
//   late final ProfileScreenController _profileCtrl = Get.isRegistered<ProfileScreenController>()
//       ? Get.find<ProfileScreenController>()
//       : Get.put(ProfileScreenController());
//
//   MessageController _chatCtrl = Get.put(MessageController());
//
//   // Method to get current user ID from ProfileScreenController
//   Future<String?> _getCurrentUserId() async {
//     try {
//       print('🔍 Attempting to get user ID from ProfileController...');
//
//       String? userId = _profileCtrl.userId.value;
//
//       if (userId.isNotEmpty) {
//         print('✅ Found user ID from ProfileController: $userId');
//         return userId;
//       }
//
//       userId = _profileCtrl.getUserId();
//       if (userId.isNotEmpty) {
//         print('✅ Found user ID from getter: $userId');
//         return userId;
//       }
//
//       print('⚠️ No user ID in ProfileController, checking SharedPreferences...');
//       await SharedPrefHelper.init();
//       userId = await SharedPrefHelper().getString('userId');
//
//       if (userId != null && userId.isNotEmpty) {
//         print('✅ Found user ID in SharedPreferences: $userId');
//         _profileCtrl.userId.value = userId;
//         return userId;
//       }
//
//       print('⏳ Waiting for API call to complete...');
//       await Future.delayed(const Duration(milliseconds: 1500));
//
//       userId = _profileCtrl.userId.value;
//       if (userId.isNotEmpty) {
//         print('✅ Found user ID after delay: $userId');
//         return userId;
//       }
//
//       userId = await SharedPrefHelper().getString('userId');
//       if (userId != null && userId.isNotEmpty) {
//         print('✅ Found user ID in SharedPreferences after delay: $userId');
//         _profileCtrl.userId.value = userId;
//         return userId;
//       }
//
//       print('❌ No user ID found anywhere');
//       return null;
//     } catch (e) {
//       print('❌ Error getting user ID: $e');
//       return null;
//     }
//   }
//
//   // Method to get auth token
//   Future<String?> _getAuthToken() async {
//     try {
//       await SharedPrefHelper.init();
//       final token = await SharedPrefHelper().getString(AppConstants.token);
//       print('🔑 Token exists: ${token != null}');
//       return token;
//     } catch (e) {
//       print('❌ Error getting token: $e');
//       return null;
//     }
//   }
//
//   // Check if user is blocked
//   Future<void> _checkBlockStatus() async {
//     try {
//       // You can get this from the conversation model if available
//       // For now, we'll assume it's not blocked
//       // In a real app, you might have a field in conversation model like isBlocked
//       if (widget.conversationModel.blockedBy != null) {
//         isBlocked.value = widget.conversationModel.blockedBy == currentUserId;
//       }
//     } catch (e) {
//       print('❌ Error checking block status: $e');
//     }
//   }
//
//   curentID() async {
//     currentUserId = await SharedPrefHelper().getData(AppConstants.userId);
//
//     reciveImage = currentUserId == widget.conversationModel.receiver!.id
//         ? widget.conversationModel.sender!.image!
//         : widget.conversationModel.receiver!.image!;
//     reciveName = currentUserId == widget.conversationModel.receiver!.id
//         ? widget.conversationModel.sender!.name!
//         : widget.conversationModel.receiver!.name!;
//
//     opponentId = currentUserId == widget.conversationModel.receiver!.id
//         ? widget.conversationModel.sender!.id!
//         : widget.conversationModel.receiver!.id!;
//
//     await _checkBlockStatus(); // Check block status
//
//     print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');
//     print('🎯 OPPONENT ID: $opponentId');
//     print('👤 OPPONENT NAME: $reciveName');
//     print('🔑 CURRENT USER ID: $currentUserId');
//     print('💬 CONVERSATION ID: ${widget.conversationModel.id}');
//     print('🚫 BLOCKED: ${isBlocked.value}');
//     print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');
//
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     print('🚀 INIT STATE CALLED');
//     curentID();
//
//     _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);
//     _chatCtrl.listenMessage(widget.conversationModel.id!);
//
//     _chatCtrl.scrollController.addListener(() {
//       if (_chatCtrl.scrollController.position.pixels <=
//           _chatCtrl.scrollController.position.minScrollExtent) {
//       } else if (_chatCtrl.scrollController.position.pixels ==
//           _chatCtrl.scrollController.position.maxScrollExtent) {
//         _chatCtrl.inboxLoadMore(widget.conversationModel.id!);
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _chatCtrl.socketOffListen(widget.conversationModel.id!);
//     super.dispose();
//   }
//
//   // Show options dialog (Report or Block/Unblock)
//   void _showOptionsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text(
//           "Options",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.report, color: Colors.orange),
//               title: Text(
//                 "Report",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               subtitle: Text("Report an issue with this conversation"),
//               onTap: () {
//                 Navigator.pop(context); // Close options dialog
//                 _showReportDialog(context, widget.conversationModel.product!.id!);
//               },
//             ),
//             Divider(height: 1),
//             // Show Block or Unblock based on current status
//             Obx(
//                   () => ListTile(
//                 leading: Icon(
//                   isBlocked.value ? Icons.lock_open : Icons.block,
//                   color: isBlocked.value ? Colors.green : Colors.red,
//                 ),
//                 title: Text(
//                   isBlocked.value ? "Unblock User" : "Block User",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isBlocked.value ? Colors.green : Colors.red,
//                   ),
//                 ),
//                 subtitle: Text(
//                   isBlocked.value
//                       ? "Allow this user to message you again"
//                       : "Block this user from messaging you",
//                 ),
//                 onTap: () {
//                   Navigator.pop(context); // Close options dialog
//                   if (isBlocked.value) {
//                     _showUnblockConfirmationDialog(context);
//                   } else {
//                     _showBlockConfirmationDialog(context);
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Show block confirmation dialog
//   void _showBlockConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text(
//           "Block User",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
//         ),
//         content: Text(
//           "Are you sure you want to block $reciveName? You won't receive any more messages from this user.",
//           style: TextStyle(fontSize: 16),
//         ),
//         actions: [
//           CustomOutlinedButton(
//             onPressed: () => Navigator.pop(context),
//             text: "Cancel",
//           ),
//           CustomElevatedButton(
//             borderRadius: 30,
//             text: "Block",
//             color: Colors.red,
//             onPressed: () async {
//               Navigator.pop(context); // Close confirmation dialog
//               await _updateBlockStatus("blocked");
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Show unblock confirmation dialog
//   void _showUnblockConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text(
//           "Unblock User",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
//         ),
//         content: Text(
//           "Are you sure you want to unblock $reciveName? They will be able to message you again.",
//           style: TextStyle(fontSize: 16),
//         ),
//         actions: [
//           CustomOutlinedButton(
//             onPressed: () => Navigator.pop(context),
//             text: "Cancel",
//           ),
//           CustomElevatedButton(
//             borderRadius: 30,
//             text: "Unblock",
//             color: Colors.green,
//             onPressed: () async {
//               Navigator.pop(context); // Close confirmation dialog
//               await _updateBlockStatus("unblocked");
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Update block status API call (for both block and unblock)
//   Future<void> _updateBlockStatus(String type) async {
//     try {
//       // Show loading indicator
//       Get.dialog(
//         Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );
//
//       final token = await _getAuthToken();
//
//       if (token == null || token.isEmpty) {
//         Get.back(); // Close loading
//         Fluttertoast.showToast(
//           msg: "Session expired. Please login again.",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.orange,
//           textColor: Colors.white,
//         );
//         return;
//       }
//
//       final body = {
//         "conversationId": widget.conversationModel.id,
//         "type": type // "blocked" or "unblocked"
//       };
//
//       print('📤 ${type == "blocked" ? "Blocking" : "Unblocking"} user with data: $body');
//
//       final response = await http.post(
//         Uri.parse('${AppUrl.baseUrl}/conversation/block'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(body),
//       );
//
//       Get.back(); // Close loading
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Update local block status
//         isBlocked.value = type == "blocked";
//
//         Fluttertoast.showToast(
//           msg: type == "blocked"
//               ? "User blocked successfully"
//               : "User unblocked successfully",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//
//         // If blocked, optionally navigate back
//         if (type == "blocked") {
//           Future.delayed(Duration(seconds: 1), () {
//             Get.offAll(() => MainBottomNavScreen());
//           });
//         }
//       } else {
//         String errorMsg = type == "blocked"
//             ? "Failed to block user"
//             : "Failed to unblock user";
//         try {
//           final errorResponse = json.decode(response.body);
//           if (errorResponse['message'] != null) {
//             errorMsg = errorResponse['message'];
//           } else if (errorResponse['error'] != null) {
//             errorMsg = errorResponse['error'];
//           }
//         } catch (_) {}
//
//         Fluttertoast.showToast(
//           msg: errorMsg,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.back(); // Close loading if still showing
//       print('❌ Error: $e');
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }
//
//   // Show report dialog
//   void _showReportDialog(BuildContext context, String productId) {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final isSubmitting = false.obs;
//
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Report an Issue",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 "Let us know your issue, and we'll help resolve it as soon as possible.",
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//               ),
//               SizedBox(height: 16),
//               Divider(height: 1),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: titleController,
//                 hintText: 'Subject',
//                 borderRadius: 30,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: descriptionController,
//                 hintText: 'Type Here',
//                 borderRadius: 20,
//               ),
//               SizedBox(height: 24),
//               Obx(
//                     () => Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CustomOutlinedButton(
//                       onPressed: () => Get.back(),
//                       text: 'Cancel',
//                     ),
//                     SizedBox(width: 8),
//                     isSubmitting.value
//                         ? const SizedBox(
//                       height: 40,
//                       width: 40,
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                         : CustomElevatedButton(
//                       text: "Submit",
//                       borderRadius: 30,
//                       onPressed: () async {
//                         if (titleController.text.isEmpty ||
//                             descriptionController.text.isEmpty) {
//                           Fluttertoast.showToast(
//                             msg: "Please fill all fields",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             backgroundColor: Colors.red,
//                             textColor: Colors.white,
//                           );
//                           return;
//                         }
//
//                         isSubmitting.value = true;
//
//                         try {
//                           final userId = await _getCurrentUserId();
//
//                           if (userId == null || userId.isEmpty) {
//                             Fluttertoast.showToast(
//                               msg: "Please login first to report",
//                               toastLength: Toast.LENGTH_LONG,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: Colors.orange,
//                               textColor: Colors.white,
//                             );
//                             isSubmitting.value = false;
//                             return;
//                           }
//
//                           final token = await _getAuthToken();
//
//                           if (token == null || token.isEmpty) {
//                             Fluttertoast.showToast(
//                               msg: "Session expired. Please login again.",
//                               toastLength: Toast.LENGTH_LONG,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: Colors.orange,
//                               textColor: Colors.white,
//                             );
//                             isSubmitting.value = false;
//                             return;
//                           }
//
//                           final response = await http.post(
//                             Uri.parse(
//                                 'https://api.bearemountclothing.co.uk/api/v1/report/$productId'),
//                             headers: {
//                               'Content-Type': 'application/json',
//                               'Authorization': 'Bearer $token',
//                             },
//                             body: json.encode({
//                               "reportBy": userId,
//                               "title": titleController.text.trim(),
//                               "description": descriptionController.text.trim(),
//                             }),
//                           );
//
//                           if (response.statusCode == 200 ||
//                               response.statusCode == 201) {
//                             Fluttertoast.showToast(
//                               msg: "Report submitted successfully",
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: Colors.green,
//                               textColor: Colors.white,
//                             );
//                             Get.back(); // Close dialog
//                           } else {
//                             String errorMsg = "Failed to submit report";
//                             try {
//                               final errorResponse = json.decode(response.body);
//                               if (errorResponse['message'] != null) {
//                                 errorMsg = errorResponse['message'];
//                               } else if (errorResponse['error'] != null) {
//                                 errorMsg = errorResponse['error'];
//                               }
//                             } catch (_) {}
//
//                             Fluttertoast.showToast(
//                               msg: errorMsg,
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: Colors.red,
//                               textColor: Colors.white,
//                             );
//                           }
//                         } catch (e) {
//                           Fluttertoast.showToast(
//                             msg: "Error: ${e.toString()}",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             backgroundColor: Colors.red,
//                             textColor: Colors.white,
//                           );
//                         } finally {
//                           isSubmitting.value = false;
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ChatController chatController = Get.find<ChatController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Positioned(
//                     left: 0,
//                     child: IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Icon(Icons.arrow_back_ios),
//                       iconSize: 24,
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         reciveName,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                       Obx(
//                             () => isBlocked.value
//                             ? Container(
//                           margin: EdgeInsets.only(left: 8),
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade100,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "Blocked",
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         )
//                             : SizedBox(),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     right: 0,
//                     child: IconButton(
//                       onPressed: () {
//                         _showOptionsDialog(context);
//                       },
//                       icon: Icon(Icons.more_vert), // Changed to more_vert for options
//                       iconSize: 24,
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 2),
//             Obx(
//                   () => Text(
//                 isBlocked.value ? "You have blocked this user" : "Active now",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isBlocked.value ? Colors.red : Colors.black,
//                   height: 1.2,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         toolbarHeight: 70,
//       ),
//       body: Obx(
//             () => Column(
//           children: [
//             // Product Info Card
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 margin: EdgeInsets.all(0),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(16)),
//                   border: Border.all(
//                     color: AppColors.secondaryColor,
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${widget.conversationModel.product!.title}",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Age: 18-18 years",
//                       style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Grey jeans for girls (10-13 years) easily used for a month. Comfortable and stylish, perfect for everyday wear—available for exchange",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Location: location, dhuba",
//                       style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.secondaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         onPressed: () => _showConfirmationDialog(context),
//                         child: Text(
//                           "Exchange Done",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _chatCtrl.inboxFirstLoading.value
//                 ? Expanded(child: Center(child: CircularProgressIndicator()))
//                 : Expanded(
//               child: GroupedListView<InboxModel, DateTime>(
//                 elements: _chatCtrl.inboxMessageListModel.value,
//                 controller: _chatCtrl.scrollController,
//                 order: GroupedListOrder.DESC,
//                 itemComparator: (item1, item2) =>
//                     item1.createdAt!.compareTo(item2.createdAt!),
//                 groupBy: (InboxModel message) => DateTime(
//                   message.createdAt!.year,
//                   message.createdAt!.month,
//                   message.createdAt!.day,
//                 ),
//                 reverse: true,
//                 shrinkWrap: true,
//                 groupSeparatorBuilder: (DateTime date) {
//                   return Center(child: Text(TimeFormatHelper.formatDate(date)));
//                 },
//                 itemBuilder: (context, InboxModel message) {
//                   if (message.msgByUserId!.id == currentUserId) {
//                     return senderBubble(context, message);
//                   } else if (message.msgByUserId!.id != currentUserId) {
//                     return receiverBubble(context, message);
//                   } else {
//                     return SizedBox();
//                   }
//                 },
//               ),
//             ),
//             // Message input area
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(color: Colors.grey.shade300, width: 1),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _chatCtrl.sentMesgCtrl,
//                       enabled: !isBlocked.value, // Disable if blocked
//                       decoration: InputDecoration(
//                         hintText: isBlocked.value
//                             ? "You cannot send messages to blocked user"
//                             : "Write Your Message",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: isBlocked.value
//                             ? Colors.grey.shade300
//                             : Colors.grey.shade200,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   InkWell(
//                     onTap: isBlocked.value
//                         ? null // Disable if blocked
//                         : () async {
//                       if (_chatCtrl.sentMesgCtrl.text.trim().isNotEmpty) {
//                         await _chatCtrl.sentMessage(widget.conversationModel.id!, 'text');
//                         _chatCtrl.sentMesgCtrl.clear();
//                         _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);
//                         Future.delayed(const Duration(milliseconds: 300), () {
//                           if (_chatCtrl.scrollController.hasClients) {
//                             _chatCtrl.scrollController.animateTo(
//                               0,
//                               duration: const Duration(milliseconds: 300),
//                               curve: Curves.easeOut,
//                             );
//                           }
//                         });
//                       }
//                     },
//                     child: CircleAvatar(
//                       backgroundColor: isBlocked.value
//                           ? Colors.grey
//                           : AppColors.secondaryColor,
//                       child: Icon(Icons.send, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void _showConfirmationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Confirm Exchange"),
//       content: Text(
//         "Are you sure you want to mark this exchange as done?",
//       ),
//       actions: [
//         CustomOutlinedButton(
//           onPressed: () {
//             Get.back();
//           },
//           text: "Cancel",
//         ),
//         CustomElevatedButton(
//           borderRadius: 30,
//           text: "Confirm",
//           onPressed: () {
//             Get.offAll(() => MainBottomNavScreen());
//           },
//         ),
//       ],
//     ),
//   );
// }
//
// class ChatController extends GetxController {
//   Rxn<MessagesResponse> messageResponse = Rxn<MessagesResponse>();
//
//   fetchSingleMessage({required String conversationId}) async {
//     final token = await SharedPrefHelper().getData(AppConstants.token);
//     final response = await http.get(
//       Uri.parse(AppUrl.getSingleConversation(conversationId)),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     debugPrint(response.toString());
//
//     final responseBody = jsonDecode(response.body);
//     messageResponse.value = MessagesResponse.fromJson(responseBody);
//     debugPrint('Response body =====> ');
//     debugPrint(messageResponse.value?.data.attributes.totalResults.toString());
//   }
// }
//
// Widget receiverBubble(BuildContext context, InboxModel message) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomNetworkImage(
//           imageUrl: '${AppUrl.imageBaseUrl}${message.msgByUserId!.image}',
//           boxShape: BoxShape.circle,
//           height: 30,
//           width: 30),
//       SizedBox(width: 8),
//       Expanded(
//         child: ChatBubble(
//           clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
//           backGroundColor: Colors.white,
//           margin: EdgeInsets.only(top: 8, bottom: 8),
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.57,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '${message.text}',
//                   style: const TextStyle(color: Colors.black),
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
//
// Widget senderBubble(BuildContext context, InboxModel message) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     crossAxisAlignment: CrossAxisAlignment.end,
//     children: [
//       Expanded(
//         child: ChatBubble(
//           clipper: ChatBubbleClipper5(
//             type: BubbleType.sendBubble,
//           ),
//           alignment: Alignment.topRight,
//           margin: EdgeInsets.only(top: 8, bottom: 8),
//           backGroundColor: AppColors.primaryColor.withOpacity(0.2),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${message.text}',
//                 style: const TextStyle(color: Colors.black),
//                 textAlign: TextAlign.start,
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(width: 8),
//     ],
//   );
// }







import 'dart:convert';

import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:clothing_exchange/models/conversation_model.dart';
import 'package:clothing_exchange/models/inbox_model.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import 'package:clothing_exchange/views/widget/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../models/chat_model.dart';
import '../../widget/network_image.dart';
import '../../widget/time_formet.dart';

class InboxChatScreen extends StatefulWidget {
  final ConversationModel conversationModel;
  const InboxChatScreen({super.key, required this.conversationModel});

  @override
  State<InboxChatScreen> createState() => _InboxChatScreenState();
}

class _InboxChatScreenState extends State<InboxChatScreen> {
  var currentUserId = '';
  var reciveImage = '';
  var reciveName = '';
  var opponentId = '';
  var isBlocked = false.obs; // Add this to track block status

  // Initialize ProfileScreenController
  late final ProfileScreenController _profileCtrl = Get.isRegistered<ProfileScreenController>()
      ? Get.find<ProfileScreenController>()
      : Get.put(ProfileScreenController());

  MessageController _chatCtrl = Get.put(MessageController());

  // Method to get current user ID from ProfileScreenController
  Future<String?> _getCurrentUserId() async {
    try {
      print('🔍 Attempting to get user ID from ProfileController...');

      String? userId = _profileCtrl.userId.value;

      if (userId.isNotEmpty) {
        print('✅ Found user ID from ProfileController: $userId');
        return userId;
      }

      userId = _profileCtrl.getUserId();
      if (userId.isNotEmpty) {
        print('✅ Found user ID from getter: $userId');
        return userId;
      }

      print('⚠️ No user ID in ProfileController, checking SharedPreferences...');
      await SharedPrefHelper.init();
      userId = await SharedPrefHelper().getString('userId');

      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences: $userId');
        _profileCtrl.userId.value = userId;
        return userId;
      }

      print('⏳ Waiting for API call to complete...');
      await Future.delayed(const Duration(milliseconds: 1500));

      userId = _profileCtrl.userId.value;
      if (userId.isNotEmpty) {
        print('✅ Found user ID after delay: $userId');
        return userId;
      }

      userId = await SharedPrefHelper().getString('userId');
      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID in SharedPreferences after delay: $userId');
        _profileCtrl.userId.value = userId;
        return userId;
      }

      print('❌ No user ID found anywhere');
      return null;
    } catch (e) {
      print('❌ Error getting user ID: $e');
      return null;
    }
  }

  // Method to get auth token
  Future<String?> _getAuthToken() async {
    try {
      await SharedPrefHelper.init();
      final token = await SharedPrefHelper().getString(AppConstants.token);
      print('🔑 Token exists: ${token != null}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  // Check if user is blocked
  Future<void> _checkBlockStatus() async {
    try {
      // You can get this from the conversation model if available
      // For now, we'll assume it's not blocked
      // In a real app, you might have a field in conversation model like isBlocked
      if (widget.conversationModel.blockedBy != null) {
        isBlocked.value = widget.conversationModel.blockedBy == currentUserId;
      }
    } catch (e) {
      print('❌ Error checking block status: $e');
    }
  }

  curentID() async {
    currentUserId = await SharedPrefHelper().getData(AppConstants.userId);

    reciveImage = currentUserId == widget.conversationModel.receiver!.id
        ? widget.conversationModel.sender!.image!
        : widget.conversationModel.receiver!.image!;
    reciveName = currentUserId == widget.conversationModel.receiver!.id
        ? widget.conversationModel.sender!.name!
        : widget.conversationModel.receiver!.name!;

    opponentId = currentUserId == widget.conversationModel.receiver!.id
        ? widget.conversationModel.sender!.id!
        : widget.conversationModel.receiver!.id!;

    await _checkBlockStatus(); // Check block status

    print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');
    print('🎯 OPPONENT ID: $opponentId');
    print('👤 OPPONENT NAME: $reciveName');
    print('🔑 CURRENT USER ID: $currentUserId');
    print('💬 CONVERSATION ID: ${widget.conversationModel.id}');
    print('🚫 BLOCKED: ${isBlocked.value}');
    print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');

    setState(() {});
  }

  @override
  void initState() {
    print('🚀 INIT STATE CALLED');
    curentID();

    _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);
    _chatCtrl.listenMessage(widget.conversationModel.id!);

    _chatCtrl.scrollController.addListener(() {
      if (_chatCtrl.scrollController.position.pixels <=
          _chatCtrl.scrollController.position.minScrollExtent) {
      } else if (_chatCtrl.scrollController.position.pixels ==
          _chatCtrl.scrollController.position.maxScrollExtent) {
        _chatCtrl.inboxLoadMore(widget.conversationModel.id!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _chatCtrl.socketOffListen(widget.conversationModel.id!);
    super.dispose();
  }

  // Show options dialog (Report or Block/Unblock)
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Options",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.report, color: Colors.orange),
              title: Text(
                "Report",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Report an issue with this conversation"),
              onTap: () {
                Navigator.pop(context); // Close options dialog
                _showReportDialog(context, widget.conversationModel.product!.id!);
              },
            ),
            Divider(height: 1),
            // Show Block or Unblock based on current status
            Obx(
                  () => ListTile(
                leading: Icon(
                  isBlocked.value ? Icons.lock_open : Icons.block,
                  color: isBlocked.value ? Colors.green : Colors.red,
                ),
                title: Text(
                  isBlocked.value ? "Unblock User" : "Block User",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isBlocked.value ? Colors.green : Colors.red,
                  ),
                ),
                subtitle: Text(
                  isBlocked.value
                      ? "Allow this user to message you again"
                      : "Block this user from messaging you",
                ),
                onTap: () {
                  Navigator.pop(context); // Close options dialog
                  if (isBlocked.value) {
                    _showUnblockConfirmationDialog(context);
                  } else {
                    _showBlockConfirmationDialog(context);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Show block confirmation dialog
  void _showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Block User",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          "Are you sure you want to block $reciveName? You won't receive any more messages from this user.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          CustomOutlinedButton(
            onPressed: () => Navigator.pop(context),
            text: "Cancel",
          ),
          CustomElevatedButton(
            borderRadius: 30,
            text: "Block",
            color: Colors.red,
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _updateBlockStatus("blocked");
            },
          ),
        ],
      ),
    );
  }

  // Show unblock confirmation dialog
  void _showUnblockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Unblock User",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        content: Text(
          "Are you sure you want to unblock $reciveName? They will be able to message you again.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          CustomOutlinedButton(
            onPressed: () => Navigator.pop(context),
            text: "Cancel",
          ),
          CustomElevatedButton(
            borderRadius: 30,
            text: "Unblock",
            color: Colors.green,
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _updateBlockStatus("unblocked");
            },
          ),
        ],
      ),
    );
  }

  // Update block status API call (for both block and unblock) - USING APPURL
  Future<void> _updateBlockStatus(String type) async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        Get.back(); // Close loading
        Fluttertoast.showToast(
          msg: "Session expired. Please login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return;
      }

      final body = {
        "conversationId": widget.conversationModel.id,
        "type": type // "blocked" or "unblocked"
      };

      print('📤 ${type == "blocked" ? "Blocking" : "Unblocking"} user with data: $body');

      final response = await http.post(
        Uri.parse(AppUrl.blockConversation), // Using AppUrl here
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      Get.back(); // Close loading

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local block status
        isBlocked.value = type == "blocked";

        Fluttertoast.showToast(
          msg: type == "blocked"
              ? "User blocked successfully"
              : "User unblocked successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // If blocked, optionally navigate back
        if (type == "blocked") {
          Future.delayed(Duration(seconds: 1), () {
            Get.offAll(() => MainBottomNavScreen());
          });
        }
      } else {
        String errorMsg = type == "blocked"
            ? "Failed to block user"
            : "Failed to unblock user";
        try {
          final errorResponse = json.decode(response.body);
          if (errorResponse['message'] != null) {
            errorMsg = errorResponse['message'];
          } else if (errorResponse['error'] != null) {
            errorMsg = errorResponse['error'];
          }
        } catch (_) {}

        Fluttertoast.showToast(
          msg: errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loading if still showing
      print('❌ Error: $e');
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Show report dialog - USING APPURL
  void _showReportDialog(BuildContext context, String productId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final isSubmitting = false.obs;

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
                "Report an Issue",
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
              CustomTextField(
                controller: titleController,
                hintText: 'Subject',
                borderRadius: 30,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Type Here',
                borderRadius: 20,
              ),
              SizedBox(height: 24),
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomOutlinedButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel',
                    ),
                    SizedBox(width: 8),
                    isSubmitting.value
                        ? const SizedBox(
                      height: 40,
                      width: 40,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : CustomElevatedButton(
                      text: "Submit",
                      borderRadius: 30,
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        isSubmitting.value = true;

                        try {
                          final userId = await _getCurrentUserId();

                          if (userId == null || userId.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please login first to report",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          final token = await _getAuthToken();

                          if (token == null || token.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Session expired. Please login again.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                            isSubmitting.value = false;
                            return;
                          }

                          // Using AppUrl.reportProduct(productId) here
                          final response = await http.post(
                            Uri.parse(AppUrl.reportProduct(productId)),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              "reportBy": userId,
                              "title": titleController.text.trim(),
                              "description": descriptionController.text.trim(),
                            }),
                          );

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Fluttertoast.showToast(
                              msg: "Report submitted successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            Get.back(); // Close dialog
                          } else {
                            String errorMsg = "Failed to submit report";
                            try {
                              final errorResponse = json.decode(response.body);
                              if (errorResponse['message'] != null) {
                                errorMsg = errorResponse['message'];
                              } else if (errorResponse['error'] != null) {
                                errorMsg = errorResponse['error'];
                              }
                            } catch (_) {}

                            Fluttertoast.showToast(
                              msg: errorMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Error: ${e.toString()}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } finally {
                          isSubmitting.value = false;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

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
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        reciveName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Obx(
                            () => isBlocked.value
                            ? Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Blocked",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _showOptionsDialog(context);
                      },
                      icon: Icon(Icons.more_vert), // Changed to more_vert for options
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Obx(
                  () => Text(
                isBlocked.value ? "You have blocked this user" : "Active now",
                style: TextStyle(
                  fontSize: 12,
                  color: isBlocked.value ? Colors.red : Colors.black,
                  height: 1.2,
                ),
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
      body: Obx(
            () => Column(
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
            _chatCtrl.inboxFirstLoading.value
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: GroupedListView<InboxModel, DateTime>(
                elements: _chatCtrl.inboxMessageListModel.value,
                controller: _chatCtrl.scrollController,
                order: GroupedListOrder.DESC,
                itemComparator: (item1, item2) =>
                    item1.createdAt!.compareTo(item2.createdAt!),
                groupBy: (InboxModel message) => DateTime(
                  message.createdAt!.year,
                  message.createdAt!.month,
                  message.createdAt!.day,
                ),
                reverse: true,
                shrinkWrap: true,
                groupSeparatorBuilder: (DateTime date) {
                  return Center(child: Text(TimeFormatHelper.formatDate(date)));
                },
                itemBuilder: (context, InboxModel message) {
                  if (message.msgByUserId!.id == currentUserId) {
                    return senderBubble(context, message);
                  } else if (message.msgByUserId!.id != currentUserId) {
                    return receiverBubble(context, message);
                  } else {
                    return SizedBox();
                  }
                },
              ),
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
                      controller: _chatCtrl.sentMesgCtrl,
                      enabled: !isBlocked.value, // Disable if blocked
                      decoration: InputDecoration(
                        hintText: isBlocked.value
                            ? "You cannot send messages to blocked user"
                            : "Write Your Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isBlocked.value
                            ? Colors.grey.shade300
                            : Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: isBlocked.value
                        ? null // Disable if blocked
                        : () async {
                      if (_chatCtrl.sentMesgCtrl.text.trim().isNotEmpty) {
                        await _chatCtrl.sentMessage(widget.conversationModel.id!, 'text');
                        _chatCtrl.sentMesgCtrl.clear();
                        _chatCtrl.inboxFirstLoad(widget.conversationModel.id!);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (_chatCtrl.scrollController.hasClients) {
                            _chatCtrl.scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: isBlocked.value
                          ? Colors.grey
                          : AppColors.secondaryColor,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
            Get.offAll(() => MainBottomNavScreen());
          },
        ),
      ],
    ),
  );
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

Widget receiverBubble(BuildContext context, InboxModel message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomNetworkImage(
          imageUrl: '${AppUrl.imageBaseUrl}${message.msgByUserId!.image}',
          boxShape: BoxShape.circle,
          height: 30,
          width: 30),
      SizedBox(width: 8),
      Expanded(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
          backGroundColor: Colors.white,
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.57,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${message.text}',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget senderBubble(BuildContext context, InboxModel message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(
            type: BubbleType.sendBubble,
          ),
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 8, bottom: 8),
          backGroundColor: AppColors.primaryColor.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${message.text}',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 8),
    ],
  );
}