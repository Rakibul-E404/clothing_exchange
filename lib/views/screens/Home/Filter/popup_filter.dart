import 'dart:developer';

import 'package:clothing_exchange/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedAgeRange;
  final String? selectedSize;
  final String? selectedGender;
  final Function(String?, String?, String?) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedAgeRange,
    required this.selectedSize,
    required this.selectedGender,
    required this.onApply,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? selectedAgeRange;
  late String? selectedSize;
  late String? selectedGender;

  final List<String> ageRanges = [
    '0-12 Months',
    '2-3 Years',
    '4-9 Years',
    '10-15 Years',
    '16-21 Years',
  ];

  final List<String> sizes = [
    'Sm',
    'Md',
    'Lg',
  ];

  final List<String> genders = [
    'Unisex',
    'Girls',
    'Boys',
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    selectedAgeRange = widget.selectedAgeRange;
    selectedSize = widget.selectedSize;
    selectedGender = widget.selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Filter By',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 20),

            // Age Range Filter (Dropdown)
            _buildDropdownSection(
              title: 'Age',
              selectedValue: selectedAgeRange,
              options: ageRanges,
              onChanged: (value) {
                setState(() {
                  selectedAgeRange = value;
                });
              },
            ),

            // Size Filter (Dropdown)
            _buildDropdownSection(
              title: 'Size',
              selectedValue: selectedSize,
              options: sizes,
              onChanged: (value) {
                setState(() {
                  selectedSize = value;
                });
              },
            ),

            // Gender Filter (Dropdown)
            _buildDropdownSection(
              title: 'Gender',
              selectedValue: selectedGender,
              options: genders,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedAgeRange = null;
                        selectedSize = null;
                        selectedGender = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.Custom_Outlined_Button_Color),
                      backgroundColor: AppColors.Custom_Outlined_Button_Color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:  Text('Reset',style: TextStyle(color: AppColors.primary_text_color),),
                  ),
                ),
                const SizedBox(width: 16),

                // Apply Button
                Expanded(
                  child: ElevatedButton(

                    onPressed: () {
                      // log('Applying filters - Age: $selectedAgeRange, Size: $selectedSize, Gender: $selectedGender');

                      widget.onApply(
                        selectedAgeRange,
                        selectedSize,
                        selectedGender,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.custom_Elevated_Button_Color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          hint: Text("Select $title"),
          onChanged: onChanged,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
