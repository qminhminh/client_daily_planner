// ignore_for_file: prefer_const_constructors

import 'package:daily_planner_test/auth/login_screen.dart';
import 'package:daily_planner_test/auth/register_screen.dart';
import 'package:daily_planner_test/home/home_page.dart';
import 'package:flutter/material.dart';
import '../splash/splash_screen.dart'; // Cập nhật đường dẫn tùy theo cấu trúc dự án của bạn
// Cập nhật đường dẫn tùy theo cấu trúc dự án của bạn

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
