import 'package:clothing_exchange/Utils/app_constants.dart';
import 'package:clothing_exchange/Utils/helper_shared_pref.dart';
import 'package:clothing_exchange/images/assets_path.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/screens/Auth/signin_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../utils/colors.dart';
import '../../widget/CustomOutlinedButton.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                AppAssets.onboardImage,
                height: 313,
                width: 362,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: SizedBox(
                width: double.infinity,
                child: CustomOutlinedButton(
                  onPressed: () {
                    Get.offAll(() => SigninScreen());
                    // final token =
                    //     SharedPrefHelper().getData(AppConstants.token);
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (_) =>
                    //           token == null ? SigninScreen() : HomeScreen()),
                    // );
                  },
                  borderRadius: 32,
                  borderWidth: 1.4,
                  borderColor: AppColors.Custom_Outlined_Button_Border_Color,
                  textColor: AppColors.Custom_Outlined_Button_Text_Color,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  backgroundColor: AppColors.Custom_Outlined_Button_Color,
                  child: Text(
                    "Let's start",
                    style: AppTextFont.bold(
                      18,
                      AppColors.Custom_Outlined_Button_Text_Color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
