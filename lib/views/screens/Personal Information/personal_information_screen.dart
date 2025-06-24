import 'package:clothing_exchange/Utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/colors.dart';
import '../../../utils/services/user_service.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../main_bottom_nav.dart';
import '../Profile/profile_screen.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  File? _selectedImage;
  bool _isEditing = false;
  bool _isLoading = true;

  // Fetched from API
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String? _imagePath;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final UserService userService = UserService();

  // Get the ProfileScreenController instance
  late ProfileScreenController profileController;

  @override
  void initState() {
    super.initState();
    // Initialize or get existing ProfileScreenController
    profileController = Get.find<ProfileScreenController>();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await userService.fetchUserProfile();

    if (userData != null) {
      setState(() {
        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _phone = userData['phone'] ?? '';
        _address = userData['address'] ?? '';
        _imagePath = userData['image'];

        _nameController.text = _name;
        _emailController.text = _email;
        _phoneController.text = _phone;
        _addressController.text = _address;

        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load user profile');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _toggleEditMode() async {
    if (_isEditing) {
      // Save changes
      setState(() {
        _isLoading = true;
      });

      bool success = await userService.updateUserProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        image: _selectedImage,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        setState(() {
          _name = _nameController.text;
          _email = _emailController.text;
          _phone = _phoneController.text;
          _address = _addressController.text;
          _isEditing = false;
        });

        // Update ProfileScreenController immediately with new data
        profileController.updateFromPersonalInfo(
          newUserName: _nameController.text,
          newImagePath: _imagePath,
        );

        if (_selectedImage != null) {
          _selectedImage = null;
          // Refresh profile to get updated image URL
          await _loadUserProfile();
          // Update ProfileScreenController with the new image path immediately
          profileController.updateFromPersonalInfo(
            newUserName: _nameController.text,
            newImagePath: _imagePath,
          );
        }

        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } else {
      // Enable editing
      setState(() {
        _isEditing = true;
      });
    }
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              )
                  : _imagePath != null && _imagePath!.isNotEmpty
                  ? Image.network(
                '${AppUrl.imageBaseUrl}$_imagePath',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondaryColor),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
                  : _buildDefaultAvatar(),
            ),
          ),
          if (_isEditing)
            Positioned(
              bottom: 10,
              right: 5,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/edit_image_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[500],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            TextButton(
                              onPressed: _toggleEditMode,
                              child: Text(
                                _isEditing ? 'SAVE' : 'EDIT',
                                style: TextStyle(
                                  color: AppColors.secondary_text_color2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem('Name', _name, _nameController),
                        const SizedBox(height: 8),
                        _buildInfoItem('Email', _email, _emailController),
                        const SizedBox(height: 8),
                        _buildInfoItem(
                          'Phone number',
                          _phone,
                          _phoneController,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoItem('Address', _address, _addressController),
                      ],
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

  Widget _buildInfoItem(
      String title,
      String value,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing
            ? TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
            : Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}