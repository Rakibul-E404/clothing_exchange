import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../views/widget/customElevatedButton.dart';
import '../../../views/widget/CustomOutlinedButton.dart';
import '../../../views/screens/Personal%20Information/personal_information_screen.dart';
import '../../../views/screens/Profile/subscription_package_screen.dart';
import '../../../views/screens/Settings/settings_screen.dart';
import '../../../views/screens/Product/my_product_history.dart';
import '../../fonts_style/fonts_style.dart';
import '../../../utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenController controller = Get.put(
      ProfileScreenController(),
    );

    // Check for updates silently when screen is built (no loading shown)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkForUpdates();
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primary_text_color,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.refresh, color: AppColors.primary_text_color),
        //     onPressed: () => controller.forceRefreshWithLoading(),
        //     tooltip: 'Force Refresh',
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              padding: EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Center(
                child: Column(
                  children: [
                    // Profile image using controller method
                    controller.buildProfileImage(),
                    SizedBox(height: 16),
                    // User name with loading state
                    Obx(
                      () =>
                          controller.isLoading.value
                              ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryColor,
                                ),
                              )
                              : Text(
                                controller.userName.value,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                    ),
                    SizedBox(height: 40),
                    // Subscription button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            textStyle: AppTextFont.regular(
                              20,
                              AppColors.secondary_text_color,
                            ),
                            svgIcon:
                                'assets/icons/basic_subscription_image.svg',
                            borderRadius: 30,
                            text: "Basic",
                            elevation: 0,
                            onPressed:
                                () => Get.to(() => SubscriptionPackageScreen()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu buttons
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _buildMenuButton(
                    label: "Personal Information",
                    icon: 'assets/icons/person-circle-svgrepo-com.svg',
                    onTap: () => Get.to(PersonalInformationScreen()),
                  ),
                  _buildMenuButton(
                    label: "Subscription Package",
                    icon: 'assets/icons/basic_subscription_image.svg',
                    onTap: () => Get.to(SubscriptionPackageScreen()),
                  ),
                  _buildMenuButton(
                    label: "My Product History",
                    icon: 'assets/icons/product_history_icon.svg',
                    onTap: () => Get.to(ProductHistoryScreen()),
                  ),
                  _buildMenuButton(
                    label: "Settings",
                    icon: 'assets/icons/settings_icon.svg',
                    onTap: () => Get.to(SettingsScreen()),
                  ),
                  _buildMenuButton(
                    label: "Logout",
                    icon: 'assets/icons/logout_icon.svg',
                    onTap: controller.showLogoutDialog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomOutlinedButton(
        borderRadius: 20,
        onPressed: onTap,
        borderColor: AppColors.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    height:   24,
                    width:  24,
                    color: AppColors.profilePageIconsColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTextFont.regular(
                      15,
                      AppColors.primary_text_color,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary_text_color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
