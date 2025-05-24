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

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
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
              debugPrint('details of chat list');
              debugPrint(chat.toString());

              return ListTile(
                leading:
                    chat['avatar'].toString().startsWith('assets/')
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  debugPrint(chat['conversationId']);
                  chatController.fetchSingleMessage(
                    conversationId: chat['conversationId'],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InboxChatScreen(name: chat['name']),
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

///
///
/// todo:: getting the conversationID
///
///
