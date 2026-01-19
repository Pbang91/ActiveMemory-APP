import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2563EB); // Vivid Blue (Active)
  static const Color secondary = Color(0xFF0F172A); // Dark Navy (Professional)
  static const Color accent =
      Color(0xFF10B981); // Emerald Green (Success/Health)

  // Neutral Colors (Backgrounds, Texts)
  static const Color background = Color(0xFFF8FAFC); // 아주 연한 회색 (눈 편함)
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // 진한 회색 (Black 대신)
  static const Color textSecondary = Color(0xFF64748B); // 연한 회색

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}
