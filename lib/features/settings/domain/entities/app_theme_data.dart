import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppThemeData extends Equatable {
  final Color bubbleColorSent;
  final Color bubbleColorReceived;
  final Color backgroundColor;
  final Color surfaceColor;
  final String fontFamily;

  const AppThemeData({
    required this.bubbleColorSent,
    required this.bubbleColorReceived,
    required this.backgroundColor,
    required this.surfaceColor,
    this.fontFamily = 'Inter',
  });

  // Default dark theme
  static const AppThemeData defaultDark = AppThemeData(
    bubbleColorSent: Color(0xFF2D68FF),
    bubbleColorReceived: Color(0xFF1C1F2A),
    backgroundColor: Color(0xFF0B0E14),
    surfaceColor: Color(0xFF1C1F2A),
    fontFamily: 'Inter',
  );

  // Purple theme
  static const AppThemeData purple = AppThemeData(
    bubbleColorSent: Color(0xFF8A2BE2),
    bubbleColorReceived: Color(0xFF2A1F3E),
    backgroundColor: Color(0xFF0E0B14),
    surfaceColor: Color(0xFF1F1C2A),
    fontFamily: 'Inter',
  );

  // Green theme
  static const AppThemeData green = AppThemeData(
    bubbleColorSent: Color(0xFF10B981),
    bubbleColorReceived: Color(0xFF1F2A1C),
    backgroundColor: Color(0xFF0B140E),
    surfaceColor: Color(0xFF1C2A1F),
    fontFamily: 'Inter',
  );

  // Cyan theme
  static const AppThemeData cyan = AppThemeData(
    bubbleColorSent: Color(0xFF06B6D4),
    bubbleColorReceived: Color(0xFF1C252A),
    backgroundColor: Color(0xFF0B1214),
    surfaceColor: Color(0xFF1C2225),
    fontFamily: 'Inter',
  );

  AppThemeData copyWith({
    Color? bubbleColorSent,
    Color? bubbleColorReceived,
    Color? backgroundColor,
    Color? surfaceColor,
    String? fontFamily,
  }) {
    return AppThemeData(
      bubbleColorSent: bubbleColorSent ?? this.bubbleColorSent,
      bubbleColorReceived: bubbleColorReceived ?? this.bubbleColorReceived,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  List<Object?> get props => [
        bubbleColorSent,
        bubbleColorReceived,
        backgroundColor,
        surfaceColor,
        fontFamily,
      ];
}
