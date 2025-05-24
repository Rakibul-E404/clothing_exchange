// import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'inbox_chat_screen.dart';
//
// class ChatListScreen extends StatelessWidget {
//    ChatListScreen({super.key});
//
//   final List<Map<String, dynamic>> chats = [
//     {
//       'name': 'Afsana hamid mim',
//       'message': 'Nice to meet you, darling',
//       'time': '7:09 pm',
//       'unread': 0,
//       'avatar': 'assets/afsana.png',
//     },
//     {
//       'name': 'Jame',
//       'message': 'Hey bro, do you want to pl...',
//       'time': '5:35 pm',
//       'unread': 1,
//       'avatar': 'assets/jame.png',
//     },
//     {
//       'name': 'Ken',
//       'message': 'I agree with your opinion',
//       'time': '10:09 pm',
//       'unread': 0,
//       'avatar': 'assets/ken.png',
//     },
//     {
//       'name': 'Nalli',
//       'message': 'Your voice is so attractive!',
//       'time': '8:00 pm',
//       'unread': 8,
//       'avatar': 'assets/nalli.png',
//     },
//     {
//       'name': 'Jenny',
//       'message': 'Yesterday I went to Grand...',
//       'time': '8:00 pm',
//       'unread': 8,
//       'avatar': 'assets/jenny.png',
//     },
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Chats'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Get.off(const HomeScreen(), arguments: 0);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: chats.length,
//         itemBuilder: (context, index) {
//           final chat = chats[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(chat['avatar']),
//             ),
//             title: Text(chat['name']),
//             subtitle: Text(chat['message']),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(chat['time'], style: TextStyle(fontSize: 12)),
//                 if (chat['unread'] > 0)
//                   CircleAvatar(
//                     radius: 10,
//                     backgroundColor: Colors.orange,
//                     child: Text(
//                       chat['unread'].toString(),
//                       style: TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                   ),
//               ],
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => InboxChatScreen(name: chat['name']),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


///
/// todo:: connecting the api
///




// import 'dart:convert';
// import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../Utils/app_constants.dart';
// import '../../../Utils/app_url.dart';
// import '../../../Utils/helper_shared_pref.dart';
// import 'inbox_chat_screen.dart';
//
//
// class ChatListScreen extends StatelessWidget {
//   ChatListScreen({super.key});
//
//   // Replace {{URL}} with your actual API base URL
//   final String apiUrl = '${AppUrl.baseUrl}/conversation/conversation_list';
//
//
//   Future<String?> _getToken() async {
//     final token = await SharedPrefHelper().getData(AppConstants.token);
//     return token as String?;
//   }
//
//
//
//   Future<List<Map<String, dynamic>>> fetchChatList() async {
//     final token = await _getToken();
//
//     if (token == null || token.isEmpty) {
//       throw Exception("No authentication token found");
//     }
//
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//
//       if (jsonResponse['code'] == 200) {
//         final List<dynamic> attributes = jsonResponse['data']['attributes'];
//
//         // Map API data to chat list structure
//         return attributes.map<Map<String, dynamic>>((item) {
//           return {
//             'name': item['name'] ?? 'Unknown,,,',
//             'message': item['lastMessage'] ?? '',
//             'time': item['time'] ?? '',
//             'unread': item['unreadCount'] ?? 0,
//             'avatar': item['avatarUrl'] ?? 'assets/default_avatar.png',
//           };
//         }).toList();
//       } else {
//         throw Exception('Failed to fetch conversations: ${jsonResponse['message']}');
//       }
//     } else {
//       throw Exception('Failed to fetch conversations. Status code: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Chats'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Get.off(const HomeScreen(), arguments: 0);
//           },
//         ),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchChatList(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No chats found.'));
//           }
//
//           final chats = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: chat['avatar'].toString().startsWith('assets/')
//                       ? AssetImage(chat['avatar']) as ImageProvider
//                       : NetworkImage(chat['avatar']),
//                 ),
//                 title: Text(chat['name']),
//                 subtitle: Text(chat['message']),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(chat['time'], style: const TextStyle(fontSize: 12)),
//                     if (chat['unread'] > 0)
//                       CircleAvatar(
//                         radius: 10,
//                         backgroundColor: Colors.orange,
//                         child: Text(
//                           chat['unread'].toString(),
//                           style: const TextStyle(fontSize: 12, color: Colors.white),
//                         ),
//                       ),
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => InboxChatScreen(name: chat['name']),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



///
/// todo:: fixing ,,to fetch
///


import 'dart:convert';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/helper_shared_pref.dart';
import 'inbox_chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  // Replace {{URL}} with your actual API base URL
  final String apiUrl = '${AppUrl.baseUrl}/conversation/conversation_list';

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

          final DateTime createdAt = DateTime.parse(item['createdAt']);
          final formattedTime = DateFormat.jm().format(createdAt);


          final String avatarUrl = chatPartner['image'] != null && chatPartner['image'].isNotEmpty
              ? '${AppUrl.baseUrl}' + chatPartner['image']
              : 'assets/default_avatar.png';

          return {
            'name': chatPartner['name'] ?? 'Unknown',
            'message': item['lastMessage'] ?? 'No messages yet',
            'time': formattedTime,
            'unread': 0,
            'avatar': avatarUrl,
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch conversations: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to fetch conversations. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.off(const HomeScreen(), arguments: 0);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChatList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats found.'));
          }

          final chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: chat['avatar'].toString().startsWith('assets/')
                    ? CircleAvatar(
                  backgroundImage: AssetImage(chat['avatar']),
                )
                    : CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatar']),
                ),
                title: Text(chat['name']),
                subtitle: Text(chat['message']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(chat['time'], style: const TextStyle(fontSize: 12)),
                    if (chat['unread'] > 0)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.orange,
                        child: Text(
                          chat['unread'].toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InboxChatScreen(
                        name: chat['name'],
                        conversationId: '',
                          currentUserId: '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
