import 'package:flutter/material.dart';

// 🔥 IMPORT THIS (THIS WAS MISSING)
import 'animated_route.dart';

// Screens
import '../screens/splash_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/success_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String success = '/success';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return AnimatedRoute.slide(const SplashScreen());

      case intro:
        return AnimatedRoute.slide(const IntroScreen());

      case login:
        return AnimatedRoute.slide(const LoginScreen());

      case otp:
        return AnimatedRoute.slide(const OTPScreen());

      case success:
        return AnimatedRoute.slide(const SuccessScreen());

      // case dashboard:
      //   return AnimatedRoute.slide(const DashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
