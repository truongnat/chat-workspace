import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  const AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF1C1F2A);
  static const Color surfaceLight = Color(0xFF252A3E);

  // Primary Brand (Gradient)
  static const Color electricBlue = Color(0xFF2D68FF);
  static const Color violet = Color(0xFF8A2BE2);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricBlue, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // UI Elements
  static const Color border = Color(0xFF2D3748);
  static const Color icon = Color(0xFF9CA3AF);
  static const Color iconActive = Color(0xFFFFFFFF);
}
