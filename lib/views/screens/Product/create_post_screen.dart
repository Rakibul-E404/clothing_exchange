import 'package:clothing_exchange/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../widget/customElevatedButton.dart';
import '../Home/home_screen.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  Color _selectedColor = Colors.transparent;//dafault color

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
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Image Section
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  svgIcon: 'assets/icons/upload_file_icon.svg',
                  text: 'Upload A Image',
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Age Range',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select age range',
                ),
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
                onChanged: (value) {},
                validator: (value) {
                  if (value == null) {
                    return 'Please select age range';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'unisex', child: Text('Unisex')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
                hint: const Text('Select gender'),
              ),
              const SizedBox(height: 20),

              const Text(
                'Size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor)),
                  hintText: 'Select size',
                ),
                items: const [
                  DropdownMenuItem(value: 'S', child: Text('S')),
                  DropdownMenuItem(value: 'M', child: Text('M')),
                  DropdownMenuItem(value: 'L', child: Text('L')),
                  DropdownMenuItem(value: 'XL', child: Text('XL')),
                ],
                onChanged: (value) {},
                validator: (value) {
                  if (value == null) {
                    return 'Please select size';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Open the color picker
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pick a Color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  borderRadius: 30,
                  text: 'Post',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post created successfully')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


