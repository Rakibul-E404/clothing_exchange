import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: IconButton(
        icon:Icon(Icons.chat,size: 50,color: AppColors.secondaryColor,),
      onPressed: ()=> Get.to(HomeScreen()),)),
    );
  }
}
