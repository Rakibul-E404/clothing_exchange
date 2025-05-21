import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Column(
          children: [
            SvgPicture('assets/error_iamge.svg' as BytesLoader),
        ],
      ))
    );
  }
}
