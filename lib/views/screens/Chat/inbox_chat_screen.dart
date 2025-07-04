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
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Added for DateFormat

import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../controllers/chat_controller.dart';
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


  var currentUserId='';
  var reciveImage='';
  var reciveName='';


  curentID()async{
    currentUserId=await SharedPrefHelper().getData(AppConstants.userId);
     reciveImage = currentUserId ==widget.conversationModel.receiver!.id ? widget.conversationModel.sender!.image! : widget.conversationModel.receiver!.image!;
     reciveName = currentUserId ==widget.conversationModel.receiver!.id ? widget.conversationModel.sender!.name! :widget.conversationModel.receiver!.name!;
     setState(() {});
  }

  MessageController _chatCtrl=Get.put(MessageController());



  @override
  void initState() {
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

      body: Obx(()=>Column(
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

          _chatCtrl.inboxFirstLoading.value?Expanded(child: Center(child:CircularProgressIndicator())):  Expanded(

            child: GroupedListView<InboxModel, DateTime>(
              elements: _chatCtrl.inboxMessageListModel.value,
              controller: _chatCtrl.scrollController,
              // padding: EdgeInsets.symmetric(horizontal: 20.w),
              order: GroupedListOrder.DESC,
              itemComparator: (item1, item2) => item1.createdAt!.compareTo(item2.createdAt!),
              groupBy: (InboxModel message) => DateTime(
                  message.createdAt!.year,
                  message.createdAt!.month,
                  message.createdAt!.day),
              reverse: true,
              shrinkWrap: true,
              groupSeparatorBuilder: (DateTime date) {
                return Center(child: Text(TimeFormatHelper.formatDate(date)));

              },
              itemBuilder: (context, InboxModel message) {
                // print('Sent Id>>>${message.msgByUserId!.id}');
                // print('CurentUser Id>>>${currentUserID}');

                if(message.msgByUserId!.id==currentUserId){
                  return senderBubble(context, message);
                }else if(message.msgByUserId!.id != currentUserId){
                  return receiverBubble(context, message);
                }else{
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
                  onTap: (){
                    if(_chatCtrl.sentMesgCtrl.text.trim().isNotEmpty){
                      _chatCtrl.sentMessage(widget.conversationModel.id!, 'text');
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
      ),)
    );
  }
}
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
            Get.offAll(()=> MainBottomNavScreen());
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


receiverBubble(BuildContext context,InboxModel message) {

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
senderBubble(BuildContext context,InboxModel message) {
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

