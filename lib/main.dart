import 'package:clothing_exchange/controllers/home_controller.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/screens/Chat/inbox_chat_screen.dart';
import 'package:clothing_exchange/views/screens/Splash/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Utils/helper_shared_pref.dart' show SharedPrefHelper;
import 'controllers/favoriteController.dart';
import 'controllers/wishlist_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  ); // or immersive, stickyImmersive

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
  // runApp( DevicePreview(builder:(context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.secondaryColor,
            surface: AppColors.background,
          ),
          useMaterial3: true,
        ),
        initialBinding: ControllerBinder(),
        home: const SplashScreen(),
        // home: const ForgotPasswordScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
    Get.put(FavoriteController());
    Get.put(HomeController());
    // Get.put(WishlistController());
  }
}
