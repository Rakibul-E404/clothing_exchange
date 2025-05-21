import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inbox_chat_screen.dart';

class ChatListScreen extends StatelessWidget {
   ChatListScreen({super.key});

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Afsana hamid mim',
      'message': 'Nice to meet you, darling',
      'time': '7:09 pm',
      'unread': 0,
      'avatar': 'assets/afsana.png',
    },
    {
      'name': 'Jame',
      'message': 'Hey bro, do you want to pl...',
      'time': '5:35 pm',
      'unread': 1,
      'avatar': 'assets/jame.png',
    },
    {
      'name': 'Ken',
      'message': 'I agree with your opinion',
      'time': '10:09 pm',
      'unread': 0,
      'avatar': 'assets/ken.png',
    },
    {
      'name': 'Nalli',
      'message': 'Your voice is so attractive!',
      'time': '8:00 pm',
      'unread': 8,
      'avatar': 'assets/nalli.png',
    },
    {
      'name': 'Jenny',
      'message': 'Yesterday I went to Grand...',
      'time': '8:00 pm',
      'unread': 8,
      'avatar': 'assets/jenny.png',
    },
  ];


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
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(chat['avatar']),
            ),
            title: Text(chat['name']),
            subtitle: Text(chat['message']),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chat['time'], style: TextStyle(fontSize: 12)),
                if (chat['unread'] > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange,
                    child: Text(
                      chat['unread'].toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InboxChatScreen(name: chat['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
