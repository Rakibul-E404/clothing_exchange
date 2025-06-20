import 'dart:convert';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../controllers/chat_controller.dart';
import 'inbox_chat_screen.dart';
import '../../../Utils/colors.dart';
import '../Profile/profile_screen.dart';
import '../Wishlist/wishlist_screen.dart';
import '../Product/create_post_screen.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String apiUrl = '${AppUrl.baseUrl}/conversation/conversation_list';
  int _currentIndex = 3;


  var currentUserId='';

  curentID()async{
    currentUserId=await SharedPrefHelper().getData(AppConstants.userId);


  }


 // Set to 3 for Chat
  Future<String?> _getToken() async {
    final token = await SharedPrefHelper().getData(AppConstants.token);
    return token as String?;
  }

  Future<List<Map<String, dynamic>>> fetchChatList() async {
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception("No authentication token found");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['code'] == 200) {
        final List<dynamic> attributes = jsonResponse['data']['attributes'];

        return attributes.map<Map<String, dynamic>>((item) {
          final chatPartner = item['receiver'];
          final String? conversationId = item['id'];

          final DateTime createdAt = DateTime.parse(item['createdAt']);
          final formattedTime = DateFormat.jm().format(createdAt);

          final String avatarUrl =
              chatPartner['image'] != null && chatPartner['image'].isNotEmpty
                  ? '${AppUrl.imageBaseUrl}' + chatPartner['image']
                  : 'assets/default_avatar.png';
          debugPrint(avatarUrl.toString());

          return {
            'name': chatPartner['name'] ?? 'Unknown',
            'message': item['lastMessage'] ?? 'No messages yet',
            'time': formattedTime,
            'unread': 0,
            'avatar': avatarUrl,
            'conversationId': conversationId,
          };
        }).toList();
      } else {
        throw Exception(
          'Failed to fetch conversations: ${jsonResponse['message']}',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch conversations. Status code: ${response.statusCode}',
      );
    }
  }

  BottomNavigationBarItem _buildNavBarItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          _currentIndex == labelToIndex(label)
              ? AppColors.secondaryColor
              : AppColors.onSecondary,
          BlendMode.srcIn,
        ),
        width: 35,
        height: 35,
      ),
      activeIcon: CircleAvatar(
        backgroundColor: AppColors.icon_bg_circleAvater_color,
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.secondaryColor,
            BlendMode.srcIn,
          ),
          width: 35,
          height: 35,
        ),
      ),
      label: label,
    );
  }

  int labelToIndex(String label) {
    switch (label) {
      case 'Home':
        return 0;
      case 'Wishlist':
        return 1;
      case 'Post':
        return 2;
      case 'Chat':
        return 3;
      case 'Profile':
        return 4;
      default:
        return 0;
    }
  }

  MessageController _chatCtrl=Get.put(MessageController());


  @override
  void initState() {
    curentID();

    _chatCtrl.conversationGet();

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   //  final ChatController chatController = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chats'),
        automaticallyImplyLeading: false,
      ),
      body:Obx(()=>_chatCtrl.conversationsLoading.value ?Center(child: CircularProgressIndicator()):
         ListView.builder(
           itemCount: _chatCtrl.convertionsMessageListModel.length,
           itemBuilder: (context, index) {
            final chat = _chatCtrl.convertionsMessageListModel[index];


            final reciveImage = currentUserId==chat.receiver!.id ? chat.sender!.image :chat.receiver!.image;
            final reciveName = currentUserId==chat.receiver!.id ? chat.sender!.name :chat.receiver!.name;
           return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${AppUrl.imageBaseUrl}$reciveImage"),
            ),
            title: Text(reciveName!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
            ),
            subtitle: Text('fak'),

            // trailing: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(chat['time'], style: const TextStyle(fontSize: 12)),
            //     if (chat['unread'] > 0)
            //       CircleAvatar(
            //         radius: 10,
            //         backgroundColor: Colors.orange,
            //         child: Text(
            //           chat['unread'].toString(),
            //           style: const TextStyle(
            //             fontSize: 12,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //   ],
            // ),
            onTap: () {
              // debugPrint(chat['conversationId']);
              // chatController.fetchSingleMessage(
              //   conversationId: chat['conversationId'],
              // );
              //
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => InboxChatScreen(name: chat['name']),
              //   ),
              // );
            },
          );
        },
      ),),

      // body: FutureBuilder<List<Map<String, dynamic>>>(
      //   future: fetchChatList(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return const Center(child: Text('No chats found.'));
      //     }
      //
      //     final chats = snapshot.data!;
      //
      //     return ListView.builder(
      //       itemCount: chats.length,
      //       itemBuilder: (context, index) {
      //         final chat = chats[index];
      //         debugPrint('details of chat list');
      //         debugPrint(chat.toString());
      //
      //         return ListTile(
      //           leading:
      //               chat['avatar'].toString().startsWith('assets/')
      //                   ? CircleAvatar(
      //                     backgroundImage: AssetImage(chat['avatar']),
      //                   )
      //                   : CircleAvatar(
      //                     backgroundImage: NetworkImage(chat['avatar']),
      //                   ),
      //           title: Text(chat['name']),
      //           subtitle: Text(chat['message']),
      //           trailing: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(chat['time'], style: const TextStyle(fontSize: 12)),
      //               if (chat['unread'] > 0)
      //                 CircleAvatar(
      //                   radius: 10,
      //                   backgroundColor: Colors.orange,
      //                   child: Text(
      //                     chat['unread'].toString(),
      //                     style: const TextStyle(
      //                       fontSize: 12,
      //                       color: Colors.white,
      //                     ),
      //                   ),
      //                 ),
      //             ],
      //           ),
      //           onTap: () {
      //             debugPrint(chat['conversationId']);
      //             chatController.fetchSingleMessage(
      //               conversationId: chat['conversationId'],
      //             );
      //
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (_) => InboxChatScreen(name: chat['name']),
      //               ),
      //             );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottom_navigation_bg_color,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.onSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          if (_currentIndex == index) return;
          switch (index) {
            case 0:
              Get.off(() => HomeScreen());
              break;
            case 1:
              Get.off(() => WishlistScreen());
              break;
            case 2:
              Get.off(() => const CreatePostPage());
              break;
            case 3:
              // Already on chat screen
              break;
            case 4:
              Get.off(() => const ProfileScreen());
              break;
            default:
              break;
          }
        },
        items: [
          _buildNavBarItem('assets/icons/home_icon.svg', 'Home'),
          _buildNavBarItem('assets/icons/wishlist_icon.svg', 'Wishlist'),
          _buildNavBarItem('assets/icons/post_icon.svg', 'Post'),
          _buildNavBarItem('assets/icons/chat_icon.svg', 'Chat'),
          _buildNavBarItem('assets/icons/profile_icon.svg', 'Profile'),
        ],
      ),
    );
  }
}
