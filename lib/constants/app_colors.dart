// lib/constants/app_colors.dart
// Centralized color palette for the Fitness Tracker App.
// All colors are defined here to ensure consistency across the UI.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // --- Primary Brand Colors ---
  static const Color primary = Color(0xFF4F6AF0);       // Vibrant indigo-blue
  static const Color primaryLight = Color(0xFFEEF1FD);  // Soft primary tint
  static const Color primaryDark = Color(0xFF3451D1);   // Deeper shade

  // --- Accent / Secondary ---
  static const Color accent = Color(0xFF00C6AE);        // Teal accent
  static const Color accentLight = Color(0xFFE0F8F5);   // Soft teal tint

  // --- Surface & Background ---
  static const Color background = Color(0xFFF6F7FB);    // Off-white background
  static const Color surface = Color(0xFFFFFFFF);       // Card surface white
  static const Color surfaceVariant = Color(0xFFF0F2FC);// Slightly tinted surface

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF1A1D2E);   // Near-black
  static const Color textSecondary = Color(0xFF6B7280); // Muted grey
  static const Color textHint = Color(0xFFB0B7C3);      // Light placeholder

  // --- Status Colors ---
  static const Color success = Color(0xFF22C55E);       // Green
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color error = Color(0xFFEF4444);         // Red
  static const Color info = Color(0xFF3B82F6);          // Blue

  // --- Exercise Type Colors (for color-coded chips/cards) ---
  static const Color colorRunning = Color(0xFFFF6B6B);
  static const Color colorCycling = Color(0xFF4ECDC4);
  static const Color colorSwimming = Color(0xFF45B7D1);
  static const Color colorYoga = Color(0xFFA78BFA);
  static const Color colorWeightlifting = Color(0xFFFFA94D);
  static const Color colorWalking = Color(0xFF74C69D);
  static const Color colorDefault = Color(0xFF4F6AF0);

  // --- Chart Colors ---
  static const List<Color> chartColors = [
    Color(0xFF4F6AF0),
    Color(0xFF00C6AE),
    Color(0xFFFF6B6B),
    Color(0xFFFFA94D),
    Color(0xFFA78BFA),
    Color(0xFF45B7D1),
    Color(0xFF74C69D),
  ];

  // --- Divider & Border ---
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE0E4F0);

  // --- Shadow ---
  static Color shadow = const Color(0xFF4F6AF0).withValues(alpha: 0.08);
}
