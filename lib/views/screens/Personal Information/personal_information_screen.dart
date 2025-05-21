// import 'package:clothing_exchange/views/screens/Profile/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class PersonalInformationScreen extends StatefulWidget {
//   const PersonalInformationScreen({super.key});
//
//   @override
//   State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
// }
//
// class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
//   File? _selectedImage;
//   bool _isEditing = false;
//
//   // User information fields
//   String _name = 'Afsana Hamid Mim';
//   String _email = 'support.info@gmail.com';
//   String _phone = '0808080';
//   String _address = 'Rangpur, Bangladesh';
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = _name;
//     _emailController.text = _email;
//     _phoneController.text = _phone;
//     _addressController.text = _address;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   void _toggleEditMode() {
//     setState(() {
//       _isEditing = !_isEditing;
//       if (!_isEditing) {
//         // Save changes when exiting edit mode
//         _name = _nameController.text;
//         _email = _emailController.text;
//         _phone = _phoneController.text;
//         _address = _addressController.text;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Personal Information'),
//         centerTitle: true,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Get.offAll(ProfileScreen(),),
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Profile header section
//             SizedBox(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     margin: const EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                     ),
//                     child: Stack(
//                       children: [
//                         Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.green
//                             ),
//                             width: 90,
//                             height: 90,
//                             child: _selectedImage == null
//                                 ? Icon(Icons.person, size: 32, color: Colors.grey[600])
//                                 : null,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           right: 5,
//                           child: GestureDetector(
//                             onTap: _pickImage,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: SvgPicture.asset(
//                                 'assets/icons/edit_image_icon.svg',
//                                 width: 24,
//                                 height: 24,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child:
//
//
//                 Card(
//                   color: AppColors.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header row with title and edit button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Personal Information',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: _toggleEditMode,
//                               child: Text(
//                                 _isEditing ? 'SAVE' : 'EDIT',
//                                 style: TextStyle(
//                                   color: AppColors.secondary_text_color2,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _buildInfoItem('Name', _name, _nameController),
//                         const SizedBox(height: 8),
//                         _buildInfoItem('Email', _email, _emailController),
//                         const SizedBox(height: 8),
//                         _buildInfoItem('Phone number', _phone, _phoneController),
//                         const SizedBox(height: 8),
//                         _buildInfoItem('Address', _address, _addressController),
//                         const SizedBox(height: 8),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoItem(String title, String value, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         _isEditing
//             ? TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             isDense: true,
//             contentPadding: const EdgeInsets.symmetric(vertical: 8),
//             border: const UnderlineInputBorder(),
//           ),
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         )
//             : Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }





import 'package:flutter/material.dart';

import '../../../Utils/Services/user_service.dart';
import '../../../Utils/app_url.dart';




class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String? _imagePath;

  final TextEditingController _nameController = TextEditingController() ;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    final userService = UserService();
    final userData = await userService.fetchUserProfile();
    if (userData != null) {
      setState(() {
        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _phone = userData['phone'] ?? '';
        _imagePath = userData['image'];

        _nameController.text = _name;
        _emailController.text = _email;
        _phoneController.text = _phone;

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // optionally show error message here
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Column(
        children: [
          _imagePath != null
              ? Image.network('${AppUrl.baseUrl}$_imagePath', width: 100, height: 100)
              : Icon(Icons.person, size: 100),
          TextField(controller: _nameController),
          TextField(controller: _emailController),
          TextField(controller: _phoneController),
          // ... rest of your UI
        ],
      ),
    );
  }
}

