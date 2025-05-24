// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:clothing_exchange/views/screens/Chat/chat_list_screen.dart';
// import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
// import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
// import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
// import 'package:clothing_exchange/views/widget/customTextField.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class InboxChatScreen extends StatelessWidget {
//   final String name;
//
//   const InboxChatScreen({super.key, required this.name});
//
//
//   void _showReportDialog(BuildContext context) {
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
//                 "Report an Issue with Your Product",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 "Let us know your issue, and we'll help resolve it as soon as possible.",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Divider(height: 1),
//               SizedBox(height: 16),
//
//               SizedBox(height: 8),
//
//               CustomTextField(
//                   hintText: 'Subject',
//               borderRadius: 30,
//               ),
//
//               SizedBox(height: 16),
//
//
//               CustomTextField(
//                 hintText: 'Type Here',
//                 borderRadius: 20,
//
//               ),
//               SizedBox(height: 24),
//
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   CustomOutlinedButton(onPressed:()=>Get.back(),
//                   text: 'Cancle',),
//                   SizedBox(width: 8),
//                   CustomElevatedButton(text: "Submit",
//                       borderRadius:30,
//                       onPressed: ()=>Get.to(ChatListScreen())),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Confirm Exchange"),
//         content: Text("Are you sure you want to mark this exchange as done?"),
//         actions: [
//           CustomOutlinedButton(
//             onPressed: () {
//               Get.back();
//             },
//             text: "Cancel",
//           ),
//           CustomElevatedButton(
//               borderRadius: 30,
//               text: "Confirm",
//               onPressed: () {
//                 Get.to(HomeScreen());
//               })
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//                       icon: Icon(Icons.arrow_back),
//                       iconSize: 24,
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                     ),
//                   ),
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//
//                   Positioned(
//                     right: 0,
//                     child: IconButton(
//                       onPressed: () {
//                         _showReportDialog(context);
//                       },
//                       icon: Icon(Icons.info_outline),
//                       iconSize: 24,
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                     ),
//                   ),
//
//                   // Positioned(
//                   //   right: 0,
//                   //   child: IconButton(
//                   //     onPressed: () {
//                   //       // Info button action
//                   //     },
//                   //     icon: Icon(Icons.info_outline),
//                   //     iconSize: 24,
//                   //     padding: EdgeInsets.zero,
//                   //     constraints: BoxConstraints(),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               "Active now",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//                 height: 1.2,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         toolbarHeight: 70, // Increased height for better spacing
//       ),
//
//       body: Column(
//         children: [
//           // Top Card with Product Info
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               margin: EdgeInsets.all(0),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//                 border: Border.all(
//
//                   // all: BorderSide(
//                     color: AppColors.secondaryColor,
//                     width: 1,
//                   // ),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Formal Suit Set",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "Age: 18-18 years",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "Grey jeans for girls (10-13 years) easily used for a month. Comfortable and stylish, perfect for everyday wear—available for exchange",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "Location: location, dhuba",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Container(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.secondaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       onPressed: () => _showConfirmationDialog(context),
//                       child: Text(
//                         "Exchange Done",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Chat messages
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(16),
//               children: [
//                 // Exchange Done message
//                 Container(
//                   margin: EdgeInsets.only(bottom: 16),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     "Hi, I'd like to exchange this dress.",
//                     style: TextStyle(
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 // Time indicator
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 8.0),
//                     child: Text(
//                       "09:25 AM",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // John Abraham message
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.grey.shade300,
//                       child: Icon(Icons.person, size: 16),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "John Abraham",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             "Of Counsel",
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(8),
//                                 bottomLeft: Radius.circular(8),
//                                 bottomRight: Radius.circular(8),
//                               ),
//                             ),
//                             child: Text("Yes, have it is. I'd like a different size"),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       "09:23 AM",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 // Response message
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.grey.shade300,
//                       child: Icon(Icons.person, size: 16),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "John Abraham",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(8),
//                                 bottomLeft: Radius.circular(8),
//                                 bottomRight: Radius.circular(8),
//                               ),
//                             ),
//                             child: Text("No Problem! Let Me Check Availability"),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       "09:23 AM",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 // Simple message
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(8),
//                         bottomLeft: Radius.circular(8),
//                         bottomRight: Radius.circular(8),
//                       ),
//                     ),
//                     child: Text("Sure!"),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     "09:23 AM",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Message input
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(
//                   color: Colors.grey.shade300,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Write Your Message",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade200,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: AppColors.secondaryColor,
//                   child: Icon(Icons.send, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



///
/// todo::: adding the api
///



import 'dart:convert';

import 'package:clothing_exchange/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../widget/CustomOutlinedButton.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextField.dart';
import '../Home/home_screen.dart';

class InboxChatScreen extends StatefulWidget {
  final String name;
  final String conversationId;
  final String currentUserId;

  const InboxChatScreen({
    super.key,
    required this.name,
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  State<InboxChatScreen> createState() => _InboxChatScreenState();
}

class _InboxChatScreenState extends State<InboxChatScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final token = await SharedPrefHelper().getData(AppConstants.token) as String?;
      if (token == null || token.isEmpty) {
        setState(() {
          error = "No authentication token found.";
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse(
          '${AppUrl.baseUrl}/conversation/get-messages?conversationId=${widget.conversationId}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['code'] == 200) {
          setState(() {
            messages = jsonResponse['data']['attributes']['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            error = "Failed to load messages: ${jsonResponse['message']}";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = "Failed to load messages. Status code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "An error occurred: $e";
        isLoading = false;
      });
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Let us know your issue, and we'll help resolve it as soon as possible.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),
              Divider(height: 1),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'Subject',
                borderRadius: 30,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'Type Here',
                borderRadius: 20,
              ),
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
                    onPressed: () => Get.back(),
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
        content: Text("Are you sure you want to mark this exchange as done?"),
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

  @override
  Widget build(BuildContext context) {
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
                    widget.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
                color: Colors.grey.shade600,
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
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(child: Text(error!))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final String text = msg['text'] ?? '';
                final DateTime createdAt =
                    DateTime.tryParse(msg['createdAt'] ?? '') ??
                        DateTime.now();
                final String timeFormatted =
                DateFormat.jm().format(createdAt);

                final msgUser = msg['msgByUserId'] ?? {};
                final String senderId = msgUser['id'] ?? '';
                final bool isSentByMe = senderId == widget.currentUserId;

                return Align(
                  alignment: isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth:
                      MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isSentByMe
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: isSentByMe
                            ? Radius.circular(12)
                            : Radius.circular(0),
                        bottomRight: isSentByMe
                            ? Radius.circular(0)
                            : Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: isSentByMe
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          timeFormatted,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSentByMe
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Message input
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
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

