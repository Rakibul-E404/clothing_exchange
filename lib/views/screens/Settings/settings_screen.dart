import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import 'package:clothing_exchange/views/screens/About%20us/about_us_screen.dart';
import 'package:clothing_exchange/views/screens/Home/home_screen.dart';
import 'package:clothing_exchange/views/screens/Legal%20Notice/legal_notice_screen.dart';
import 'package:clothing_exchange/views/screens/Profile/change_password_screen.dart';
import 'package:clothing_exchange/views/screens/Terms%20and%20Privacy/privacy_policy_screen.dart';
import 'package:clothing_exchange/views/screens/Terms%20and%20Privacy/terms_&_conditions.dart';
import 'package:clothing_exchange/views/widget/CustomOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Support/support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primary_text_color,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.offAll(HomeScreen(), arguments: 0),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(ChangePasswordScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/password_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Change Password",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(PrivacyPolicyScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/privacy_policy_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Privacy Plicy",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(TermsAndConditionsScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/terms_condition_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Terms and Conditions",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(LegalNoticeScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/terms_condition_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Leagal Notice",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(AboutUsScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/about_info_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "About Us",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  CustomOutlinedButton(
                    borderRadius: 20,
                    onPressed: () => Get.to(SupportScreen()),
                    borderColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/support_icon.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.profilePageIconsColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Support",
                                style: AppTextFont.regular(
                                    15, AppColors.primary_text_color),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primary_text_color)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        // Handle menu item tap
      },
    );
  }
}
