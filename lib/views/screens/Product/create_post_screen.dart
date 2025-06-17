import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:clothing_exchange/views/widget/customElevatedButton.dart';
import 'package:clothing_exchange/views/fonts_style/fonts_style.dart';
import '../Home/home_screen.dart';
import '../Chat/chat_list_screen.dart';
import '../Profile/profile_screen.dart';
import '../Wishlist/wishlist_screen.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';
import 'package:clothing_exchange/utils/app_url.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final RxInt currentIndex = 2.obs; // Current index set to 2 for Post

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _gender;
  String? _ageRange;
  String? _size;
  Color _selectedColor = Colors.transparent;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  void _onItemTapped(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offAll(() => HomeScreen());
        break;
      case 1:
        Get.offAll(() => WishlistScreen());
        break;
      case 2:
        Get.offAll(() => const CreatePostPage());
        break;
      case 3:
        Get.offAll(() => ChatListScreen());
        break;
      case 4:
        Get.offAll(() => const ProfileScreen());
        break;
    }
  }

  BottomNavigationBarItem _buildNavBarItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          currentIndex.value == index
              ? AppColors.secondaryColor
              : AppColors.onSecondary,
          BlendMode.srcIn,
        ),
        width: 35,
        height: 35,
      ),
      activeIcon: CircleAvatar(
        backgroundColor: AppColors.icon_bg_circleAvater_color,
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.secondaryColor,
            BlendMode.srcIn,
          ),
          width: 35,
          height: 35,
        ),
      ),
      label: label,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Check file size (limit 2MB)
      final fileSize = await file.length();
      const maxSize = 2 * 1024 * 1024; // 2MB
      if (fileSize > maxSize) {
        Get.snackbar(
          'Error',
          'Please select an image smaller than 2MB',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Validate mime type
      final mimeType = lookupMimeType(pickedFile.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        Get.snackbar(
          'Error',
          'Please select a valid image file',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      setState(() {
        _selectedImage = file;
      });
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      _showError('Image Required', 'Please upload an image');
      return;
    }

    try {
      final fileSize = await _selectedImage!.length();
      const maxSize = 2 * 1024 * 1024; // 2MB limit

      if (fileSize > maxSize) {
        _showError(
          'Image too large',
          'Only images smaller than 2MB are allowed',
        );
        return;
      }

      final extension = _selectedImage!.path.split('.').last.toLowerCase();
      final mimeType = lookupMimeType(_selectedImage!.path);

      const allowedExtensions = ['jpg', 'jpeg', 'png'];
      const allowedMimeTypes = ['image/jpeg', 'image/png'];

      if (!allowedExtensions.contains(extension) ||
          mimeType == null ||
          !allowedMimeTypes.contains(mimeType)) {
        _showError(
          'Invalid image format',
          'Only JPG, JPEG, and PNG images are allowed',
        );
        return;
      }
    } catch (e) {
      _showError('Image Error', 'Failed to validate image: ${e.toString()}');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = SharedPrefHelper().getData(AppConstants.token);
      if (token == null) {
        _showError('Authorization Error', 'User token not found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final uri = Uri.parse('${AppUrl.baseUrl}/products/create');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      // Add fields
      request.fields['title'] = _titleController.text.trim();
      request.fields['location'] = _locationController.text.trim();
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['gender'] = _gender ?? '';
      request.fields['age'] = _ageRange ?? '';
      request.fields['size'] = _size ?? '';
      request.fields['color'] =
      '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';

      // Add image file
      final mimeType =
          lookupMimeType(_selectedImage!.path) ?? 'application/octet-stream';
      final mimeSplit = mimeType.split('/');

      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      );

      request.files.add(multipartFile);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final respJson = jsonDecode(respStr);

      if (response.statusCode == 201) {
        _showSuccess(
          'Success',
          respJson['message'] ?? 'Post created successfully',
        );
        Get.offAll(() => HomeScreen(), arguments: 0);
      } else {
        _showError('Error', respJson['message'] ?? 'Failed to create post');
      }
    } catch (e) {
      _showError('Error', 'Failed to create post: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
    );
  }

  void _showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.white, blurRadius: 10, offset: Offset(0, 0)),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/create_post_screen_cover_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  elevation: 0,
                  text: _selectedImage == null
                      ? 'Upload An Image'
                      : 'Change Image',
                  textStyle: AppTextFont.regular(
                    15,
                    AppColors.secondary_text_color,
                  ),
                  onPressed: _pickImage,
                  borderRadius: 30,
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedImage != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              const SizedBox(height: 20),
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter title',
                ),
                validator: (value) =>
                (value == null || value.isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Age Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _ageRange,
                items: const [
                  DropdownMenuItem(
                    value: '0-6',
                    child: Text('0-6 months'),
                  ),
                  DropdownMenuItem(
                    value: '6-12',
                    child: Text('6-12 months'),
                  ),
                  DropdownMenuItem(
                    value: '1-2',
                    child: Text('1-2 years'),
                  ),
                  DropdownMenuItem(
                    value: '2-3',
                    child: Text('2-3 years'),
                  ),
                  DropdownMenuItem(
                    value: '3-4',
                    child: Text('3-4 years'),
                  ),
                  DropdownMenuItem(
                    value: '4-5',
                    child: Text('4-5 years'),
                  ),
                  DropdownMenuItem(
                    value: '5-6',
                    child: Text('5-6 years'),
                  ),
                  DropdownMenuItem(
                    value: '6-7',
                    child: Text('6-7 years'),
                  ),
                  DropdownMenuItem(
                    value: '7-8',
                    child: Text('7-8 years'),
                  ),
                  DropdownMenuItem(
                    value: '8+',
                    child: Text('8+ years'),
                  ),
                ],
                onChanged: (value) => setState(() => _ageRange = value),
                validator: (value) =>
                value == null ? 'Please select age range' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(
                    value: 'female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'unisex',
                    child: Text('Unisex'),
                  ),
                ],
                onChanged: (value) => setState(() => _gender = value),
                validator: (value) =>
                value == null ? 'Please select gender' : null,
                hint: const Text('Select gender'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  hintText: 'Select size',
                ),
                value: _size,
                items: const [
                  DropdownMenuItem(value: 'sm', child: Text('S')),
                  DropdownMenuItem(value: 'md', child: Text('M')),
                  DropdownMenuItem(value: 'lg', child: Text('L')),
                  DropdownMenuItem(value: 'xxl', child: Text('XL')),
                ],
                onChanged: (value) => setState(() => _size = value),
                validator: (value) =>
                value == null ? 'Please select size' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter location',
                ),
                validator: (value) =>
                (value == null || value.isEmpty)
                    ? 'Please enter location'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pick a Color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _selectedColor,
                          onColorChanged: (color) {
                            setState(() => _selectedColor = color);
                          },
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK',style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) =>
                (value == null || value.isEmpty)
                    ? 'Please enter description'
                    : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  borderRadius: 30,
                  text: 'Post',
                  onPressed: _submitPost,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          backgroundColor: AppColors.bottom_navigation_bg_color,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex.value,
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: AppColors.onSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) => _onItemTapped(index),
          items: [
            _buildNavBarItem('assets/icons/home_icon.svg', 'Home', 0),
            _buildNavBarItem('assets/icons/wishlist_icon.svg', 'Wishlist', 1),
            _buildNavBarItem('assets/icons/post_icon.svg', 'Post', 2),
            _buildNavBarItem('assets/icons/chat_icon.svg', 'Chat', 3),
            _buildNavBarItem('assets/icons/profile_icon.svg', 'Profile', 4),
          ],
        ),
      ),
    );
  }
}