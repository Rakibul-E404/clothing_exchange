import 'package:clothing_exchange/images/assets_path.dart';
import 'package:clothing_exchange/views/main_bottom_nav.dart';
import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:clothing_exchange/views/screens/Splash/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import '../../../controllers/splash_controller.dart';
import '../../../utils/colors.dart';
import '../Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      final token = SharedPrefHelper().getData(AppConstants.token);
      Get.offAll(() => token == null ? OnboardScreen() : MainBottomNavScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashScreenBackground,
      body: Center(
        child: Image.asset(
          fit: BoxFit.contain,
          AppAssets.splashLogo,
          width: 210,
          height: 178,
        ),
      ),
    );
  }
}
