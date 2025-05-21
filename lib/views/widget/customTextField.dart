// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../../utils/colors.dart';
// //
// // class CustomTextField extends StatefulWidget {
// //   final String hintText;
// //   final String? svgIconPath;
// //   final IconData? icon;
// //   final bool obscureText;
// //   final TextEditingController? controller;
// //   final TextInputType? keyboardType;
// //   final String? Function(String?)? validator;
// //   final Color hoverColor;
// //   final Color iconColor;
// //   final Color borderColor;
// //   final double borderRadius;
// //
// //   const CustomTextField({
// //     super.key,
// //     required this.hintText,
// //     this.svgIconPath,
// //     this.icon,
// //     this.obscureText = false,
// //     this.controller,
// //     this.keyboardType,
// //     this.validator,
// //     this.hoverColor = const Color(0xFFF0E6D6),
// //     this.iconColor = const Color(0xFFAB7843),
// //     this.borderColor = const Color(0xFFAB7843),
// //     this.borderRadius = 32.0,
// //   }) : assert(svgIconPath == null || icon == null,
// //   'Cannot provide both svgIconPath and icon');
// //
// //   @override
// //   State<CustomTextField> createState() => _CustomTextFieldState();
// // }
// //
// // class _CustomTextFieldState extends State<CustomTextField> {
// //   bool _isHovered = false;
// //   bool _isFocused = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Focus(
// //       onFocusChange: (focused) => setState(() => _isFocused = focused),
// //       child: MouseRegion(
// //         onEnter: (_) => setState(() => _isHovered = true),
// //         onExit: (_) => setState(() => _isHovered = false),
// //         child: TextField(
// //           obscureText: widget.obscureText,
// //           controller: widget.controller,
// //           keyboardType: widget.keyboardType,
// //           style: GoogleFonts.outfit(
// //             fontSize: 16,
// //             color: AppColors.primary_text_color,
// //             fontWeight: FontWeight.w400, // Regular
// //           ),
// //           decoration: InputDecoration(
// //             hintText: widget.hintText,
// //             hintStyle: GoogleFonts.outfit(
// //               fontSize: 16,
// //               color: widget.iconColor.withOpacity(0.6),
// //               fontWeight: FontWeight.w400, // Regular
// //             ),
// //             filled: true,
// //             fillColor: _isHovered || _isFocused
// //                 ? widget.hoverColor
// //                 : const Color(0xFFFAF4EF),
// //             contentPadding: const EdgeInsets.symmetric(
// //                 vertical: 18, horizontal: 20),
// //             border: _buildBorder(),
// //             enabledBorder: _buildBorder(isEnabled: true),
// //             focusedBorder: _buildBorder(isFocused: true),
// //             errorBorder: _buildBorder(isError: true),
// //             focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
// //             prefixIcon: _buildPrefixIcon(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   OutlineInputBorder _buildBorder({
// //     bool isEnabled = false,
// //     bool isFocused = false,
// //     bool isError = false,
// //   }) {
// //     final color = isError
// //         ? Colors.red
// //         : isFocused
// //         ? widget.borderColor
// //         : widget.borderColor.withOpacity(
// //         _isHovered ? 0.8 : isEnabled ? 1.0 : 0.5);
// //
// //     return OutlineInputBorder(
// //       borderRadius: BorderRadius.circular(widget.borderRadius),
// //       borderSide: BorderSide(
// //         color: color,
// //         width: isFocused ? 2.0 : 1.5,
// //       ),
// //     );
// //   }
// //
// //   Widget? _buildPrefixIcon() {
// //     if (widget.svgIconPath != null) {
// //       return Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: SvgPicture.asset(
// //           widget.svgIconPath!,
// //           width: 24,
// //           height: 24,
// //           color: widget.iconColor.withOpacity(
// //               _isHovered || _isFocused ? 0.9 : 0.7),
// //         ),
// //       );
// //     } else if (widget.icon != null) {
// //       return Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: Icon(
// //           widget.icon,
// //           size: 24,
// //           color: widget.iconColor.withOpacity(
// //               _isHovered || _isFocused ? 0.9 : 0.7),
// //         ),
// //       );
// //     }
// //     return null;
// //   }
// // }
//
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../utils/colors.dart';
//
// class CustomTextField extends StatefulWidget {
//   final String hintText;
//   final String? svgIconPath;
//   final IconData? icon;
//   final String? suffixSvgIconPath;
//   final Widget? suffixIcon; // Allow any widget here
//   final bool obscureText;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final Color hoverColor;
//   final Color iconColor;
//   final Color borderColor;
//   final double borderRadius;
//   final VoidCallback? onSuffixIconPressed;
//
//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     this.svgIconPath,
//     this.icon,
//     this.suffixSvgIconPath,
//     this.suffixIcon, // Accept Widget instead of IconData
//     this.obscureText = false,
//     this.controller,
//     this.keyboardType,
//     this.validator,
//     this.hoverColor = const Color(0xFFF0E6D6),
//     this.iconColor = const Color(0xFFAB7843),
//     this.borderColor = const Color(0xFFAB7843),
//     this.borderRadius = 32.0,
//     this.onSuffixIconPressed,
//   }) : assert(svgIconPath == null || icon == null, 'Cannot provide both svgIconPath and icon'),
//         assert(suffixSvgIconPath == null || suffixIcon == null, 'Cannot provide both suffixSvgIconPath and suffixIcon');
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _isHovered = false;
//   bool _isFocused = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Focus(
//       onFocusChange: (focused) => setState(() => _isFocused = focused),
//       child: MouseRegion(
//         onEnter: (_) => setState(() => _isHovered = true),
//         onExit: (_) => setState(() => _isHovered = false),
//         child: TextFormField(
//           obscureText: widget.obscureText,
//           controller: widget.controller,
//           keyboardType: widget.keyboardType,
//           validator: widget.validator,
//           style: GoogleFonts.outfit(
//             fontSize: 16,
//             color: AppColors.primary_text_color,
//             fontWeight: FontWeight.w400,
//           ),
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             hintStyle: GoogleFonts.outfit(
//               fontSize: 16,
//               color: widget.iconColor.withOpacity(0.6),
//               fontWeight: FontWeight.w400,
//             ),
//             filled: true,
//             fillColor: _isHovered || _isFocused ? widget.hoverColor : const Color(0xFFFAF4EF),
//             contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//             border: _buildBorder(),
//             enabledBorder: _buildBorder(isEnabled: true),
//             focusedBorder: _buildBorder(isFocused: true),
//             errorBorder: _buildBorder(isError: true),
//             focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
//             prefixIcon: _buildPrefixIcon(),
//             suffixIcon: widget.suffixIcon, // Use the widget directly
//           ),
//         ),
//       ),
//     );
//   }
//
//   OutlineInputBorder _buildBorder({
//     bool isEnabled = false,
//     bool isFocused = false,
//     bool isError = false,
//   }) {
//     final color = isError
//         ? Colors.red
//         : isFocused
//         ? widget.borderColor
//         : widget.borderColor.withOpacity(
//       _isHovered ? 0.8 : isEnabled ? 1.0 : 0.5,
//     );
//
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(widget.borderRadius),
//       borderSide: BorderSide(
//         color: color,
//         width: isFocused ? 2.0 : 1.5,
//       ),
//     );
//   }
//
//   Widget? _buildPrefixIcon() {
//     if (widget.svgIconPath != null) {
//       return Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: SvgPicture.asset(
//           widget.svgIconPath!,
//           width: 24,
//           height: 24,
//           color: widget.iconColor.withOpacity(_isHovered || _isFocused ? 0.9 : 0.7),
//         ),
//       );
//     } else if (widget.icon != null) {
//       return Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Icon(
//           widget.icon,
//           size: 24,
//           color: widget.iconColor.withOpacity(_isHovered || _isFocused ? 0.9 : 0.7),
//         ),
//       );
//     }
//     return null;
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? svgIconPath;
  final IconData? icon;
  final String? suffixSvgIconPath;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color hoverColor;
  final Color iconColor;
  final Color borderColor;
  final double borderRadius;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.svgIconPath,
    this.icon,
    this.suffixSvgIconPath,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.hoverColor = const Color(0xFFF0E6D6),
    this.iconColor = const Color(0xFFAB7843),
    this.borderColor = const Color(0xFFAB7843),
    this.borderRadius = 32.0,
    this.onSuffixIconPressed,
    this.onChanged,
  }) : assert(svgIconPath == null || icon == null, 'Cannot provide both svgIconPath and icon'),
        assert(suffixSvgIconPath == null || suffixIcon == null, 'Cannot provide both suffixSvgIconPath and suffixIcon');

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: TextFormField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppColors.primary_text_color,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.outfit(
              fontSize: 16,
              color: widget.iconColor.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: _isHovered || _isFocused ? widget.hoverColor : const Color(0xFFFAF4EF),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: _buildBorder(),
            enabledBorder: _buildBorder(isEnabled: true),
            focusedBorder: _buildBorder(isFocused: true),
            errorBorder: _buildBorder(isError: true),
            focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder({
    bool isEnabled = false,
    bool isFocused = false,
    bool isError = false,
  }) {
    final color = isError
        ? Colors.red
        : isFocused
        ? widget.borderColor
        : widget.borderColor.withOpacity(_isHovered ? 0.8 : isEnabled ? 1.0 : 0.5);

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: color,
        width: isFocused ? 2.0 : 1.5,
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.svgIconPath != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          widget.svgIconPath!,
          width: 24,
          height: 24,
          color: widget.iconColor.withOpacity(_isHovered || _isFocused ? 0.9 : 0.7),
        ),
      );
    } else if (widget.icon != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          widget.icon,
          size: 24,
          color: widget.iconColor.withOpacity(_isHovered || _isFocused ? 0.9 : 0.7),
        ),
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixSvgIconPath != null) {
      return IconButton(
        onPressed: widget.onSuffixIconPressed,
        icon: SvgPicture.asset(
          widget.suffixSvgIconPath!,
          width: 24,
          height: 24,
          color: widget.iconColor.withOpacity(_isHovered || _isFocused ? 0.9 : 0.7),
        ),
      );
    } else if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixIconPressed,
        child: widget.suffixIcon!,
      );
    }
    return null;
  }
}
