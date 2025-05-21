import 'package:clothing_exchange/images/assets_path.dart';
import 'package:flutter/material.dart';
import '../../../controllers/splash_controller.dart';
import '../../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreen> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();
    _controller.navigateToOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashScreenBackground,
      body: Center(
        child:
        Image.asset(
          fit: BoxFit.contain,
          AppAssets.splashLogo,
          width: 210,
          height: 178,
        ),
      ),
    );
  }
}