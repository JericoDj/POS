import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = "Leos POS";
  // static const String backendUrl = "https://pos-backend-rosy.vercel.app/api";
  static String get backendUrl =>
      dotenv.env['BACKEND_URL'] ?? 'https://pos-backend-rosy.vercel.app/api';

  // Colors
  // Colors
  static const Color primaryColor = Color(0xFF376184); // Deep Steel Blue
  static const Color secondaryColor = Color(0xFF81ADBC); // Muted Teal
  static const Color accentColor = Color(0xFFE3B23C); // Mustard Gold

  // Backgrounds
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color backgroundDark = Color(
    0xFFF8FAFB,
  ); // Secondary Panel / Light Grey-Blue

  // Text Colors
  static const Color slate900 = Color(0xFF376184); // Headings (Primary)

  static const Color slate800 = Color(0xFF6B6C6E); // Body Text (Dark Neutral)
  static const Color slate500 = Color(0xFF9CA3AF); // Muted Text
  static const Color slate400 = Color(0xFF94A3B8);

  // Shadows
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];
}
