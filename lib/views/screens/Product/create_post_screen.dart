// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import '../../widget/customElevatedButton.dart';
// import '../Home/home_screen.dart';
//
// class CreatePostPage extends StatefulWidget {
//   const CreatePostPage({super.key});
//
//   @override
//   State<CreatePostPage> createState() => _CreatePostPageState();
// }
//
// class _CreatePostPageState extends State<CreatePostPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? _gender;
//   Color _selectedColor = Colors.transparent;//dafault color
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Create a Post',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 color: Colors.white,
//                 blurRadius: 10,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.offAll(const HomeScreen(), arguments: 0),
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/create_post_screen_cover_image.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarHeight: 100,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Upload Image Section
//               SizedBox(
//                 width: double.infinity,
//                 child: CustomElevatedButton(
//                   svgIcon: 'assets/icons/upload_file_icon.svg',
//                   text: 'Upload A Image',
//                   onPressed: () {},
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Title',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter title',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Age Range',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Select age range',
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: '0-6 months', child: Text('0-6 months')),
//                   DropdownMenuItem(value: '6-12 months', child: Text('6-12 months')),
//                   DropdownMenuItem(value: '1-2 years', child: Text('1-2 years')),
//                   DropdownMenuItem(value: '2-3 years', child: Text('2-3 years')),
//                   DropdownMenuItem(value: '3-4 years', child: Text('3-4 years')),
//                   DropdownMenuItem(value: '4-5 years', child: Text('4-5 years')),
//                   DropdownMenuItem(value: '5-6 years', child: Text('5-6 years')),
//                   DropdownMenuItem(value: '6-7 years', child: Text('6-7 years')),
//                   DropdownMenuItem(value: '7-8 years', child: Text('7-8 years')),
//                   DropdownMenuItem(value: '8+ years', child: Text('8+ years')),
//                 ],
//                 onChanged: (value) {},
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select age range';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Gender',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _gender,
//                 items: const [
//                   DropdownMenuItem(value: 'male', child: Text('Male')),
//                   DropdownMenuItem(value: 'female', child: Text('Female')),
//                   DropdownMenuItem(value: 'unisex', child: Text('Unisex')),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _gender = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select gender';
//                   }
//                   return null;
//                 },
//                 hint: const Text('Select gender'),
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Size',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.secondaryColor)),
//                   hintText: 'Select size',
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'S', child: Text('S')),
//                   DropdownMenuItem(value: 'M', child: Text('M')),
//                   DropdownMenuItem(value: 'L', child: Text('L')),
//                   DropdownMenuItem(value: 'XL', child: Text('XL')),
//                 ],
//                 onChanged: (value) {},
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select size';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Location',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter location',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter location';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Color',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () {
//                   // Open the color picker
//                   showDialog(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('Pick a Color'),
//                       content: SingleChildScrollView(
//                         child: ColorPicker(
//                           pickerColor: _selectedColor,
//                           onColorChanged: (Color color) {
//                             setState(() {
//                               _selectedColor = color;
//                             });
//                           },
//                           showLabel: true,
//                           pickerAreaHeightPercent: 0.8,
//                         ),
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: const Text('OK'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: _selectedColor,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.black26),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Description',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter description',
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 30),
//
//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: CustomElevatedButton(
//                   borderRadius: 30,
//                   text: 'Post',
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Post created successfully')),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//


///
///
///
/// todo::: connecting the api
///
///
///


// import 'dart:io';
// import 'dart:convert';
// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';
// import '../../widget/customElevatedButton.dart';
// import '../Home/home_screen.dart';
// import '../../../Utils/app_constants.dart';
// import '../../../Utils/helper_shared_pref.dart';
// import 'package:clothing_exchange/utils/app_url.dart'; // Adjust if needed
//
// class CreatePostPage extends StatefulWidget {
//   const CreatePostPage({super.key});
//
//   @override
//   State<CreatePostPage> createState() => _CreatePostPageState();
// }
//
// class _CreatePostPageState extends State<CreatePostPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   String? _gender;
//   String? _ageRange;
//   String? _size;
//   Color _selectedColor = Colors.transparent;
//
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   bool _isLoading = false;
//
//   void _showImageSourceActionSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Future<void> _pickImage(ImageSource source) async {
//   //   final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _imageFile = File(pickedFile.path);
//   //     });
//   //   }
//   // }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
//     if (pickedFile != null) {
//       final mimeType = lookupMimeType(pickedFile.path) ?? '';
//       if (mimeType == 'image/jpeg' || mimeType == 'image/jpg' || mimeType == 'image/png') {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select a JPG or PNG image')),
//         );
//       }
//     }
//   }
//
//
//   Future<void> _submitPost() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload an image')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final token = SharedPrefHelper().getData(AppConstants.token);
//
//       var uri = Uri.parse('${AppUrl.baseUrl}/products/create');
//
//       var request = http.MultipartRequest('POST', uri);
//       request.headers['Authorization'] = 'Bearer $token';
//
//       // Add text fields
//       request.fields['title'] = _titleController.text.trim();
//       request.fields['location'] = _locationController.text.trim();
//       request.fields['description'] = _descriptionController.text.trim();
//       request.fields['gender'] = _gender ?? '';
//       request.fields['age'] = _ageRange ?? '';
//       request.fields['size'] = _size ?? '';
//       // Convert Color to hex string, include # (e.g. #aabbcc)
//       request.fields['color'] = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
//
//       // Add image file
//       var imageStream = http.ByteStream(_imageFile!.openRead());
//       var imageLength = await _imageFile!.length();
//
//       var multipartFile = http.MultipartFile(
//         'image',
//         imageStream,
//         imageLength,
//         filename: _imageFile!.path.split('/').last,
//       );
//
//       request.files.add(multipartFile);
//
//       // Send request
//       var response = await request.send();
//
//       if (response.statusCode == 201) {
//         // Optionally parse response body:
//         final respStr = await response.stream.bytesToString();
//         final respJson = jsonDecode(respStr);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(respJson['message'] ?? 'Post created successfully')),
//         );
//
//         Get.offAll(const HomeScreen(), arguments: 0);
//       } else {
//         final respStr = await response.stream.bytesToString();
//         final respJson = jsonDecode(respStr);
//         final errorMsg = respJson['message'] ?? 'Failed to create post';
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMsg)),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Create a Post',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 color: Colors.white,
//                 blurRadius: 10,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.offAll(const HomeScreen(), arguments: 0),
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/create_post_screen_cover_image.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarHeight: 100,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 child: CustomElevatedButton(
//                   svgIcon: 'assets/icons/upload_file_icon.svg',
//                   text: _imageFile == null ? 'Upload An Image' : 'Change Image',
//                   onPressed: _showImageSourceActionSheet,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (_imageFile != null)
//                 Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Image.file(_imageFile!, fit: BoxFit.cover),
//                 ),
//               const SizedBox(height: 20),
//
//               const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter title',
//                 ),
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Age Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(border: OutlineInputBorder()),
//                 value: _ageRange,
//                 items: const [
//                   DropdownMenuItem(value: '0-6 months', child: Text('0-6 months')),
//                   DropdownMenuItem(value: '6-12 months', child: Text('6-12 months')),
//                   DropdownMenuItem(value: '1-2 years', child: Text('1-2 years')),
//                   DropdownMenuItem(value: '2-3 years', child: Text('2-3 years')),
//                   DropdownMenuItem(value: '3-4 years', child: Text('3-4 years')),
//                   DropdownMenuItem(value: '4-5 years', child: Text('4-5 years')),
//                   DropdownMenuItem(value: '5-6 years', child: Text('5-6 years')),
//                   DropdownMenuItem(value: '6-7 years', child: Text('6-7 years')),
//                   DropdownMenuItem(value: '7-8 years', child: Text('7-8 years')),
//                   DropdownMenuItem(value: '8+ years', child: Text('8+ years')),
//                 ],
//                 onChanged: (value) => setState(() => _ageRange = value),
//                 validator: (value) => value == null ? 'Please select age range' : null,
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(border: OutlineInputBorder()),
//                 value: _gender,
//                 items: const [
//                   DropdownMenuItem(value: 'male', child: Text('Male')),
//                   DropdownMenuItem(value: 'female', child: Text('Female')),
//                   DropdownMenuItem(value: 'unisex', child: Text('Unisex')),
//                 ],
//                 onChanged: (value) => setState(() => _gender = value),
//                 validator: (value) => value == null ? 'Please select gender' : null,
//                 hint: const Text('Select gender'),
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
//                   hintText: 'Select size',
//                 ),
//                 value: _size,
//                 items: const [
//                   DropdownMenuItem(value: 'S', child: Text('S')),
//                   DropdownMenuItem(value: 'M', child: Text('M')),
//                   DropdownMenuItem(value: 'L', child: Text('L')),
//                   DropdownMenuItem(value: 'XL', child: Text('XL')),
//                 ],
//                 onChanged: (value) => setState(() => _size = value),
//                 validator: (value) => value == null ? 'Please select size' : null,
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter location',
//                 ),
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter location' : null,
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('Pick a Color'),
//                       content: SingleChildScrollView(
//                         child: ColorPicker(
//                           pickerColor: _selectedColor,
//                           onColorChanged: (color) {
//                             setState(() => _selectedColor = color);
//                           },
//                           showLabel: true,
//                           pickerAreaHeightPercent: 0.8,
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: const Text('OK'),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: _selectedColor,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.black26),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter description',
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 4,
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter description' : null,
//               ),
//               const SizedBox(height: 30),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: CustomElevatedButton(
//                   borderRadius: 30,
//                   text: 'Post',
//                   onPressed: _submitPost,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



///TODO:: CHECKING THE IMAGE FILE
///



import 'dart:io';
import 'dart:convert';
import 'package:clothing_exchange/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../widget/customElevatedButton.dart';
import '../Home/home_screen.dart';
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

  // // Future<void> _pickImage() async {
  // //   try {
  // //     final pickedFile = await _picker.pickImage(
  // //       source: ImageSource.gallery,
  // //       imageQuality: 70,
  // //     );
  // //
  // //     if (pickedFile != null) {
  // //       final file = File(pickedFile.path);
  // //       final fileSize = await file.length();
  // //       const maxSize = 2 * 1024 * 1024; // 2MB
  // //
  // //       if (fileSize > maxSize) {
  // //         Get.snackbar(
  // //           'Image too large',
  // //           'Please select an image smaller than 2MB',
  // //           snackPosition: SnackPosition.BOTTOM,
  // //         );
  // //         return;
  // //       }
  // //
  // //       final mimeType = lookupMimeType(pickedFile.path);
  // //       if (mimeType == null || !mimeType.startsWith('image/')) {
  // //         Get.snackbar(
  // //           'Invalid file',
  // //           'Please select a valid image file',
  // //           snackPosition: SnackPosition.BOTTOM,
  // //         );
  // //         return;
  // //       }
  // //
  // //       setState(() {
  // //         _selectedImage = file;
  // //       });
  // //     }
  // //   } catch (e) {
  // //     Get.snackbar(
  // //       'Error',
  // //       'Failed to pick image: ${e.toString()}',
  // //       snackPosition: SnackPosition.BOTTOM,
  // //     );
  // //   }
  // // }
  //
  //
  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //     );
  //
  //     if (pickedFile != null) {
  //       // File size check (2MB limit)
  //       final file = File(pickedFile.path);
  //       final fileSize = await file.length();
  //       const maxSize = 2 * 1024 * 1024; // 2MB
  //
  //       if (fileSize > maxSize) {
  //         Get.snackbar(
  //           'Image too large',
  //           'Only images smaller than 2MB are allowed',
  //           snackPosition: SnackPosition.BOTTOM,
  //           duration: const Duration(seconds: 3),
  //         );
  //         return;
  //       }
  //
  //       // Get file extension and MIME type
  //       final extension = pickedFile.path.split('.').last.toLowerCase();
  //       final mimeType = lookupMimeType(pickedFile.path);
  //
  //       // List of allowed formats
  //       const allowedExtensions = ['jpg', 'jpeg', 'png'];
  //       const allowedMimeTypes = ['image/jpeg', 'image/png'];
  //
  //       // Validate both extension and MIME type
  //       if (!allowedExtensions.contains(extension) ||
  //           (mimeType != null && !allowedMimeTypes.contains(mimeType))) {
  //         Get.snackbar(
  //           'Invalid image format',
  //           'Only JPG, JPEG, and PNG images are allowed',
  //           snackPosition: SnackPosition.BOTTOM,
  //           duration: const Duration(seconds: 3),
  //         );
  //         return;
  //       }
  //
  //       // If all checks passed
  //       setState(() {
  //         _selectedImage = file;
  //       });
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to select image: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  // }
  //
  // // Future<void> _submitPost() async {
  // //   if (!_formKey.currentState!.validate()) return;
  // //
  // //   if (_selectedImage == null) {
  // //     Get.snackbar(
  // //       'Image Required',
  // //       'Please upload an image.',
  // //       snackPosition: SnackPosition.BOTTOM,
  // //     );
  // //     return;
  // //   }
  // //
  // //   setState(() {
  // //     _isLoading = true;
  // //   });
  // //
  // //   try {
  // //     final token = SharedPrefHelper().getData(AppConstants.token);
  // //     final uri = Uri.parse('${AppUrl.baseUrl}/products/create');
  // //     var request = http.MultipartRequest('POST', uri);
  // //     request.headers['Authorization'] = 'Bearer $token';
  // //
  // //     // Add fields
  // //     request.fields['title'] = _titleController.text.trim();
  // //     request.fields['location'] = _locationController.text.trim();
  // //     request.fields['description'] = _descriptionController.text.trim();
  // //     request.fields['gender'] = _gender ?? '';
  // //     request.fields['age'] = _ageRange ?? '';
  // //     request.fields['size'] = _size ?? '';
  // //     request.fields['color'] = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  // //
  // //     // Add image file
  // //     var stream = http.ByteStream(_selectedImage!.openRead());
  // //     var length = await _selectedImage!.length();
  // //     var multipartFile = http.MultipartFile(
  // //         'image',
  // //         stream,
  // //         length,
  // //         filename: _selectedImage!.path.split('/').last
  // //     );
  // //
  // //     request.files.add(multipartFile);
  // //
  // //     var response = await request.send();
  // //
  // //     if (response.statusCode == 201) {
  // //       final respStr = await response.stream.bytesToString();
  // //       final respJson = jsonDecode(respStr);
  // //       Get.snackbar(
  // //         'Success',
  // //         respJson['message'] ?? 'Post created successfully',
  // //         snackPosition: SnackPosition.BOTTOM,
  // //       );
  // //       Get.offAll(const HomeScreen(), arguments: 0);
  // //     } else {
  // //       final respStr = await response.stream.bytesToString();
  // //       final respJson = jsonDecode(respStr);
  // //       Get.snackbar(
  // //         'Error',
  // //         respJson['message'] ?? 'Failed to create post',
  // //         snackPosition: SnackPosition.BOTTOM,
  // //       );
  // //     }
  // //   } catch (e) {
  // //     Get.snackbar(
  // //       'Error',
  // //       'Failed to create post: ${e.toString()}',
  // //       snackPosition: SnackPosition.BOTTOM,
  // //     );
  // //   } finally {
  // //     setState(() {
  // //       _isLoading = false;
  // //     });
  // //   }
  // // }
  //
  //
  // Future<void> _submitPost() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   // Validate image before submission
  //   if (_selectedImage == null) {
  //     _showError('Image Required', 'Please upload an image');
  //     return;
  //   }
  //
  //   // Perform the same image validation as in _pickImage
  //   try {
  //     // File size check (2MB limit)
  //     final fileSize = await _selectedImage!.length();
  //     const maxSize = 2 * 1024 * 1024; // 2MB
  //
  //     if (fileSize > maxSize) {
  //       _showError('Image too large', 'Only images smaller than 2MB are allowed');
  //       return;
  //     }
  //
  //     // Get file extension and MIME type
  //     final extension = _selectedImage!.path.split('.').last.toLowerCase();
  //     final mimeType = lookupMimeType(_selectedImage!.path);
  //
  //     // List of allowed formats
  //     const allowedExtensions = ['jpg', 'jpeg', 'png'];
  //     const allowedMimeTypes = ['image/jpeg', 'image/png'];
  //
  //     // Validate both extension and MIME type
  //     if (!allowedExtensions.contains(extension) ||
  //         (mimeType != null && !allowedMimeTypes.contains(mimeType))) {
  //       _showError('Invalid image format', 'Only JPG, JPEG, and PNG images are allowed');
  //       return;
  //     }
  //   } catch (e) {
  //     _showError('Image Error', 'Failed to validate image: ${e.toString()}');
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final token = SharedPrefHelper().getData(AppConstants.token);
  //     final uri = Uri.parse('${AppUrl.baseUrl}/products/create');
  //     var request = http.MultipartRequest('POST', uri);
  //     request.headers['Authorization'] = 'Bearer $token';
  //
  //     // Add fields
  //     request.fields['title'] = _titleController.text.trim();
  //     request.fields['location'] = _locationController.text.trim();
  //     request.fields['description'] = _descriptionController.text.trim();
  //     request.fields['gender'] = _gender ?? '';
  //     request.fields['age'] = _ageRange ?? '';
  //     request.fields['size'] = _size ?? '';
  //     request.fields['color'] = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  //
  //     // Add image file
  //     var stream = http.ByteStream(_selectedImage!.openRead());
  //     var length = await _selectedImage!.length();
  //     var multipartFile = http.MultipartFile(
  //         'image',
  //         stream,
  //         length,
  //         filename: _selectedImage!.path.split('/').last
  //     );
  //
  //     request.files.add(multipartFile);
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 201) {
  //       final respStr = await response.stream.bytesToString();
  //       final respJson = jsonDecode(respStr);
  //       _showSuccess('Success', respJson['message'] ?? 'Post created successfully');
  //       Get.offAll(const HomeScreen(), arguments: 0);
  //     } else {
  //       final respStr = await response.stream.bytesToString();
  //       final respJson = jsonDecode(respStr);
  //       _showError('Error', respJson['message'] ?? 'Failed to create post');
  //     }
  //   } catch (e) {
  //     _showError('Error', 'Failed to create post: ${e.toString()}');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }



  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        // File size check (2MB limit)
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        const maxSize = 2 * 1024 * 1024; // 2MB

        if (fileSize > maxSize) {
          Get.snackbar(
            'Image too large',
            'Only images smaller than 2MB are allowed',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // Get file extension and MIME type
        final extension = pickedFile.path.split('.').last.toLowerCase();
        final mimeType = lookupMimeType(pickedFile.path);

        // List of allowed formats
        const allowedExtensions = ['jpg', 'jpeg', 'png'];
        const allowedMimeTypes = ['image/jpeg', 'image/png'];

        // Validate both extension and MIME type, treat null mimeType as invalid
        if (!allowedExtensions.contains(extension) || mimeType == null || !allowedMimeTypes.contains(mimeType)) {
          Get.snackbar(
            'Invalid image format',
            'Only JPG, JPEG, and PNG images are allowed',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // If all checks passed
        setState(() {
          _selectedImage = file;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate image before submission
    if (_selectedImage == null) {
      _showError('Image Required', 'Please upload an image');
      return;
    }

    // Perform the same image validation as in _pickImage
    try {
      // File size check (2MB limit)
      final fileSize = await _selectedImage!.length();
      const maxSize = 2 * 1024 * 1024; // 2MB

      if (fileSize > maxSize) {
        _showError('Image too large', 'Only images smaller than 2MB are allowed');
        return;
      }

      // Get file extension and MIME type
      final extension = _selectedImage!.path.split('.').last.toLowerCase();
      final mimeType = lookupMimeType(_selectedImage!.path);

      // List of allowed formats
      const allowedExtensions = ['jpg', 'jpeg', 'png'];
      const allowedMimeTypes = ['image/jpeg', 'image/png'];

      // Validate both extension and MIME type, treat null mimeType as invalid
      if (!allowedExtensions.contains(extension) || mimeType == null || !allowedMimeTypes.contains(mimeType)) {
        _showError('Invalid image format', 'Only JPG, JPEG, and PNG images are allowed');
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
      request.fields['color'] = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';

      // Add image file
      var stream = http.ByteStream(_selectedImage!.openRead());
      var length = await _selectedImage!.length();
      var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: _selectedImage!.path.split('/').last
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final respJson = jsonDecode(respStr);
        _showSuccess('Success', respJson['message'] ?? 'Post created successfully');
        Get.offAll(const HomeScreen(), arguments: 0);
      } else {
        final respStr = await response.stream.bytesToString();
        final respJson = jsonDecode(respStr);
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




// Helper methods for consistent messaging
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
            Shadow(
            color: Colors.white,
            blurRadius: 10,
            offset: Offset(0, 0),
            )
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.offAll(const HomeScreen(), arguments: 0),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
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
                  svgIcon: 'assets/icons/upload_file_icon.svg',
                  text: _selectedImage == null ? 'Upload An Image' : 'Change Image',
                  onPressed: _pickImage,
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

              const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter title',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),

              const Text('Age Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: _ageRange,
                items: const [
                  DropdownMenuItem(value: '0-6 months', child: Text('0-6 months')),
                  DropdownMenuItem(value: '6-12 months', child: Text('6-12 months')),
                  DropdownMenuItem(value: '1-2 years', child: Text('1-2 years')),
                  DropdownMenuItem(value: '2-3 years', child: Text('2-3 years')),
                  DropdownMenuItem(value: '3-4 years', child: Text('3-4 years')),
                  DropdownMenuItem(value: '4-5 years', child: Text('4-5 years')),
                  DropdownMenuItem(value: '5-6 years', child: Text('5-6 years')),
                  DropdownMenuItem(value: '6-7 years', child: Text('6-7 years')),
                  DropdownMenuItem(value: '7-8 years', child: Text('7-8 years')),
                  DropdownMenuItem(value: '8+ years', child: Text('8+ years')),
                ],
                onChanged: (value) => setState(() => _ageRange = value),
                validator: (value) => value == null ? 'Please select age range' : null,
              ),
              const SizedBox(height: 20),

              const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'unisex', child: Text('Unisex')),
                ],
                onChanged: (value) => setState(() => _gender = value),
                validator: (value) => value == null ? 'Please select gender' : null,
                hint: const Text('Select gender'),
              ),
              const SizedBox(height: 20),

              const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
                  hintText: 'Select size',
                ),
                value: _size,
                items: const [
                  DropdownMenuItem(value: 'S', child: Text('S')),
                  DropdownMenuItem(value: 'M', child: Text('M')),
                  DropdownMenuItem(value: 'L', child: Text('L')),
                  DropdownMenuItem(value: 'XL', child: Text('XL')),
                ],
                onChanged: (value) => setState(() => _size = value),
                validator: (value) => value == null ? 'Please select size' : null,
              ),
              const SizedBox(height: 20),

              const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter location',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter location' : null,
              ),
              const SizedBox(height: 20),

              const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                          child: const Text('OK'),
                        )
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

              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter description' : null,
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
    );
  }
}

