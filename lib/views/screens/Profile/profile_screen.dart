// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../Utils/Services/user_service.dart';
// import '../../../Utils/app_constants.dart';
// import '../../../Utils/app_url.dart';
// import '../../../Utils/helper_shared_pref.dart';
// import '../../../utils/colors.dart';
// import '../../../views/widget/customElevatedButton.dart';
// import '../../../views/widget/CustomOutlinedButton.dart';
// import '../../../views/screens/Auth/signin_screen.dart';
// import '../../../views/screens/Personal%20Information/personal_information_screen.dart';
// import '../../../views/screens/Profile/subscription_package_screen.dart';
// import '../../../views/screens/Settings/settings_screen.dart';
// import '../../../views/screens/Product/my_product_history.dart';
// import '../../../views/screens/Chat/chat_list_screen.dart';
// import '../../../views/screens/Wishlist/wishlist_screen.dart';
// import '../../fonts_style/fonts_style.dart';
// import '../../main_bottom_nav.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? userName;
//   String? userProfileImage;
//   bool isLoading = true;
//   int _currentIndex = 4; // Set to 4 for Profile
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedUserName = prefs.getString('userName');
//     final storedUserProfileImage = prefs.getString('userProfileImage');
//
//     if (storedUserName != null && storedUserProfileImage != null) {
//       setState(() {
//         userName = storedUserName;
//         userProfileImage = storedUserProfileImage;
//         isLoading = false;
//       });
//     } else {
//       final userService = UserService();
//       final userData = await userService.fetchUserProfile();
//       if (userData != null && userData['name'] != null) {
//         setState(() {
//           userName = userData['name'];
//           userProfileImage = userData['image']; // Fetching user image
//           isLoading = false;
//         });
//         // Store the data locally
//         prefs.setString('userName', userName!);
//         prefs.setString('userProfileImage', userProfileImage!);
//       } else {
//         setState(() {
//           userName = 'Unknown User';
//           userProfileImage = null;
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   BottomNavigationBarItem _buildNavBarItem(String iconPath, String label) {
//     return BottomNavigationBarItem(
//       icon: SvgPicture.asset(
//         iconPath,
//         colorFilter: ColorFilter.mode(
//           _currentIndex == labelToIndex(label)
//               ? AppColors.secondaryColor
//               : AppColors.onSecondary,
//           BlendMode.srcIn,
//         ),
//         width: 35,
//         height: 35,
//       ),
//       activeIcon: CircleAvatar(
//         backgroundColor: AppColors.icon_bg_circleAvater_color,
//         child: SvgPicture.asset(
//           iconPath,
//           colorFilter: const ColorFilter.mode(
//             AppColors.secondaryColor,
//             BlendMode.srcIn,
//           ),
//           width: 35,
//           height: 35,
//         ),
//       ),
//       label: label,
//     );
//   }
//
//   int labelToIndex(String label) {
//     switch (label) {
//       case 'Home': return 0;
//       case 'Wishlist': return 1;
//       case 'Post': return 2;
//       case 'Chat': return 3;
//       case 'Profile': return 4;
//       default: return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Profile',
//           style: GoogleFonts.outfit(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primary_text_color,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile header
//             Container(
//               padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
//               child: Center(
//                 child: Column(
//                   children: [
//
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(20), // Rounded corners of the container
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             blurRadius: 6,
//                             offset: Offset(0, 2),
//                           )
//                         ],
//                         border: Border.all( // Add border
//                           color: Colors.grey.withOpacity(0.5), // Border color
//                           width: 2, // Border width
//                         ),
//                       ),
//                       child: ClipRRect( // Clip the image with rounded corners
//                         borderRadius: BorderRadius.circular(20), // Rounded corners for the image
//                         child: userProfileImage != null && userProfileImage!.isNotEmpty
//                             ? CachedNetworkImage(
//                           imageUrl: '${AppUrl.imageBaseUrl}${userProfileImage!}',
//                           fit: BoxFit.cover,
//                           width: 100,
//                           height: 100,
//                           placeholder: (context, url) => Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                           errorWidget: (context, url, error) => const Icon(
//                             Icons.person,
//                             size: 32,
//                             color: Colors.grey,
//                           ),
//                         )
//                             : Icon(Icons.person, size: 32, color: Colors.grey[600]),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     isLoading
//                         ? CircularProgressIndicator()
//                         : Text(
//                       userName ?? 'Unknown User',
//                       style: GoogleFonts.outfit(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.5,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CustomElevatedButton(
//                             textStyle: AppTextFont.regular(
//                                 20, AppColors.secondary_text_color),
//                             svgIcon: 'assets/icons/basic_subscription_image.svg',
//                             borderRadius: 30,
//                             text: "Basic",
//                             elevation: 0,
//                             onPressed: () => Get.offAll(() => MainBottomNavScreen()),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Menu buttons
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   _buildMenuButton(
//                     label: "Personal Information",
//                     icon: 'assets/icons/person-circle-svgrepo-com.svg',
//                     onTap: () => Get.to(PersonalInformationScreen()),
//                   ),
//                   _buildMenuButton(
//                     label: "Subscription Package",
//                     icon: 'assets/icons/basic_subscription_image.svg',
//                     onTap: () => Get.to(SubscriptionPackageScreen()),
//                   ),
//                   _buildMenuButton(
//                     label: "My Product History",
//                     icon: 'assets/icons/product_history_icon.svg',
//                     onTap: () => Get.to(ProductHistoryScreen()),
//                   ),
//                   _buildMenuButton(
//                     label: "Settings",
//                     icon: 'assets/icons/settings_icon.svg',
//                     onTap: () => Get.to(SettingsScreen()),
//                   ),
//                   _buildMenuButton(
//                     label: "Logout",
//                     icon: 'assets/icons/logout_icon.svg',
//                     onTap: _showLogoutDialog,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuButton({
//     required String label,
//     required String icon,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: CustomOutlinedButton(
//         borderRadius: 20,
//         onPressed: onTap,
//         borderColor: AppColors.secondaryColor,
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   SvgPicture.asset(
//                     icon,
//                     height: 24,
//                     width: 24,
//                     color: AppColors.profilePageIconsColor,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     label,
//                     style: AppTextFont.regular(15, AppColors.primary_text_color),
//                   ),
//                 ],
//               ),
//               Icon(Icons.arrow_forward_ios, color: AppColors.primary_text_color),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showLogoutDialog() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Text(
//           "Confirm Logout",
//           style: AppTextFont.regular(18, AppColors.primary_text_color),
//         ),
//         content: Text(
//           "Are you sure you want to logout?",
//           style: AppTextFont.regular(15, AppColors.primary_text_color),
//         ),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomOutlinedButton(
//                   borderRadius: 20,
//                   onPressed: () => Get.back(),
//                   borderColor: AppColors.secondaryColor,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Text(
//                     "No",
//                     style: AppTextFont.regular(15, AppColors.primary_text_color),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: CustomElevatedButton(
//                   borderRadius: 20,
//                   onPressed: () async {
//                     Get.back();
//                     await SharedPrefHelper().removeData(AppConstants.token);
//                     final token =
//                     await SharedPrefHelper().getData(AppConstants.token);
//                     if (token == null) {
//                       Get.offAll(() => SigninScreen());
//                     }
//                   },
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   text: 'Yes',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }




/// todo:: deviding the code into two files for controller
///




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/app_url.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../views/widget/customElevatedButton.dart';
import '../../../views/widget/CustomOutlinedButton.dart';
import '../../../views/screens/Auth/signin_screen.dart';
import '../../../views/screens/Personal%20Information/personal_information_screen.dart';
import '../../../views/screens/Profile/subscription_package_screen.dart';
import '../../../views/screens/Settings/settings_screen.dart';
import '../../../views/screens/Product/my_product_history.dart';
import '../../fonts_style/fonts_style.dart';
import '../../main_bottom_nav.dart';
import '../../../utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenController controller = Get.put(ProfileScreenController());

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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Obx(() => controller.userProfileImage.value.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: '${AppUrl.imageBaseUrl}${controller.userProfileImage.value}',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.grey,
                          ),
                        )
                            : Icon(Icons.person, size: 32, color: Colors.grey[600])),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(() => controller.isLoading.value
                        ? CircularProgressIndicator()
                        : Text(
                      controller.userName.value,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    )),
                    SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            textStyle: AppTextFont.regular(
                                20, AppColors.secondary_text_color),
                            svgIcon: 'assets/icons/basic_subscription_image.svg',
                            borderRadius: 30,
                            text: "Basic",
                            elevation: 0,
                            onPressed: () => Get.offAll(() => MainBottomNavScreen()),
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
                    height: 24,
                    width: 24,
                    color: AppColors.profilePageIconsColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTextFont.regular(15, AppColors.primary_text_color),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: AppColors.primary_text_color),
            ],
          ),
        ),
      ),
    );
  }
}




