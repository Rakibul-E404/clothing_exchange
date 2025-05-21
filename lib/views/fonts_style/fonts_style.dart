import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextFont {
  // Regular
  static TextStyle regular(double size, Color color) {
    return GoogleFonts.outfit(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  // Medium
  static TextStyle medium(double size, Color color) {
    return GoogleFonts.outfit(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  // Semi-bold
  static TextStyle semiBold(double size, Color color) {
    return GoogleFonts.outfit(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  // Bold
  static TextStyle bold(double size, Color color) {
    return GoogleFonts.outfit(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  // Extra-bold
  static TextStyle extraBold(double size, Color color) {
    return GoogleFonts.outfit(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w800,
    );
  }
}