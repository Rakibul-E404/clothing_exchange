import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/colors.dart';
import '../../../utils/services/user_service.dart';
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

  @override
  void initState() {
    super.initState();
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
          // If photo updated, optionally clear selected image or refresh _imagePath
          if (_selectedImage != null) {
            // Clear local selected image to force reload from network if API returns new path later
            _selectedImage = null;
            _loadUserProfile(); // Refresh profile to get updated image url
          }
        });
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.offAll(const ProfileScreen()),
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
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(top: 20),
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child:
                                _selectedImage != null
                                    ? Image.file(
                                      _selectedImage!,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    )
                                    : (_imagePath != null &&
                                        _imagePath!.isNotEmpty)
                                    ? Image.network(
                                      _imagePath!,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/userIcon/usersDefaultImage.png',
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/userIcon/usersDefaultImage.png',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
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
                  ),
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
