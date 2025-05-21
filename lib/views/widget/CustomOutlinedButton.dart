import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final Color? splashColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? backgroundColor;
  final IconData? icon;
  final String? svgIcon;
  final double? iconSize;
  final double gapBetweenIconAndText;
  final Color? iconColor;
  final Widget? child;

  const CustomOutlinedButton({
    super.key,
    this.text = '',
    required this.onPressed,
    this.borderColor = AppColors.secondaryColor,
    this.textColor = AppColors.primary_text_color,
    this.borderWidth = 2.0,
    this.borderRadius = 32.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    this.textStyle,
    this.splashColor,
    this.focusColor,
    this.hoverColor,
    this.backgroundColor,
    this.icon,
    this.svgIcon,
    this.iconSize = 24.0,
    this.gapBetweenIconAndText = 8.0,
    this.iconColor,
    this.child,
  }) : assert(icon == null || svgIcon == null,
  'Cannot provide both icon and svgIcon');

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(textColor),
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        side: WidgetStateProperty.all(BorderSide(
          color: borderColor,
          width: borderWidth,
        )),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )),
        padding: WidgetStateProperty.all(padding),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return splashColor;
          }
          if (states.contains(WidgetState.hovered)) {
            return hoverColor;
          }
          if (states.contains(WidgetState.focused)) {
            return focusColor;
          }
          return null;
        }),
      ),
      onPressed: onPressed,
      child: child ?? _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (text.isEmpty && icon == null && svgIcon == null) {
      return const SizedBox(); // Fallback for empty button
    }

    final textWidget = Text(
      text,
      style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(
        color: textColor,
      ),
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
