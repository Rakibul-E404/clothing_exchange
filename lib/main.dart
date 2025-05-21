import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/screens/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Utils/helper_shared_pref.dart' show SharedPrefHelper;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // or immersive, stickyImmersive


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

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
        home: const SplashScreen(),
        // home: const ForgotPasswordScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}




