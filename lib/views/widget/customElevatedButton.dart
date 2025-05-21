// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../utils/colors.dart';
//
// class CustomElevatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color color;
//   final Color textColor;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   final double elevation;
//   final Color borderColor;
//   final double borderWidth;
//   final TextStyle? textStyle;
//   final IconData? icon;
//   final String? svgIcon;
//   final double? iconSize;
//   final double gapBetweenIconAndText;
//   final Color? iconColor;
//
//   const CustomElevatedButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.color = AppColors.custom_Elevated_Button_Color,
//     this.textColor = AppColors.custom_Elevated_Button_Text_Color,
//     this.borderRadius = 12.0,
//     this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//     this.elevation = 4.0,
//     this.borderColor = AppColors.customElevatedButtonBorderColor,
//     this.borderWidth = 1.5,
//     this.textStyle,
//     this.icon,
//     this.svgIcon,
//     this.iconSize = 24.0,
//     this.gapBetweenIconAndText = 8.0,
//     this.iconColor,
//   }) : assert(icon == null || svgIcon == null,
//   'Cannot provide both icon and svgIcon');
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: textColor,
//         elevation: elevation,
//         padding: padding,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           side: BorderSide(
//             color: borderColor,
//             width: borderWidth,
//           ),
//         ),
//       ),
//       onPressed: onPressed,
//       child: _buildChild(context),
//     );
//   }
//
//   Widget _buildChild(BuildContext context) {
//     final textWidget = Text(
//       text,
//       style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor),
//     );
//
//     if (icon != null) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: iconSize,
//             color: iconColor ?? textColor,
//           ),
//           SizedBox(width: gapBetweenIconAndText),
//           textWidget,
//         ],
//       );
//     } else if (svgIcon != null) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             svgIcon!,
//             height: iconSize,
//             width: iconSize,
//             colorFilter: iconColor != null
//                 ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
//                 : null,
//           ),
//           SizedBox(width: gapBetweenIconAndText),
//           textWidget,
//         ],
//       );
//     }
//     return textWidget;
//   }
// }



///
///
///updating
///
///




import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color borderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final IconData? icon;
  final String? svgIcon;
  final double? iconSize;
  final double gapBetweenIconAndText;
  final Color? iconColor;
  final Widget? child; // ✅ Added child

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.custom_Elevated_Button_Color,
    this.textColor = AppColors.custom_Elevated_Button_Text_Color,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    this.elevation = 4.0,
    this.borderColor = AppColors.customElevatedButtonBorderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.icon,
    this.svgIcon,
    this.iconSize = 24.0,
    this.gapBetweenIconAndText = 8.0,
    this.iconColor,
    this.child, // ✅ Included in constructor
  }) : assert(icon == null || svgIcon == null,
  'Cannot provide both icon and svgIcon');

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: elevation,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
      ),
      onPressed: onPressed,
      child: child ?? _buildChild(context), // ✅ Use child if available
    );
  }

  Widget _buildChild(BuildContext context) {
    final textWidget = Text(
      text,
      style: textStyle ??
          Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? textColor,
          ),
          SizedBox(width: gapBetweenIconAndText),
          textWidget,
        ],
      );
    } else if (svgIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgIcon!,
            height: iconSize,
            width: iconSize,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          ),
          SizedBox(width: gapBetweenIconAndText),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}
