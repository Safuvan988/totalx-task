import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/auth/presentation/pages/phone_input_page.dart';
import '../../features/users/presentation/pages/user_list_page.dart';

class AppRouter {
  static const String phonePath = '/auth/phone';
  static const String otpPath = '/auth/otp';
  static const String usersPath = '/users';

  static final GoRouter router = GoRouter(
    initialLocation: phonePath,
    routes: [
      GoRoute(
        path: phonePath,
        name: 'phone',
        builder: (context, state) => const PhoneInputPage(),
      ),
      GoRoute(
        path: otpPath,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          final phone = extra?['phone'] ?? '';
          final reqId = extra?['reqId'] ?? '';
          return OtpVerifyPage(phone: phone, reqId: reqId);
        },
      ),
      GoRoute(
        path: usersPath,
        name: 'users',
        builder: (context, state) => const UserListPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
