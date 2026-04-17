import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color cardShadow = Color(0x0F000000);
  static const Color otpBorder = Color(0xFFD1D5DB);
  static const Color resendText = Color(0xFF6B7280);
}

class AppConstants {
  AppConstants._();

  // App meta
  static const String appName = 'TotalX Task';

  // MSG91 — replace with real credentials from https://msg91.com/in
  static const String msg91WidgetId = 'YOUR_WIDGET_ID';
  static const String msg91AuthToken = 'YOUR_AUTH_TOKEN';

  // Mock OTP for development (remove in production)
  static const String mockOtp = '123456';
  static const bool useMockOtp = true;

  // Pagination
  static const int pageSize = 10;

  // OTP timer
  static const int otpTimerSeconds = 59;
}
