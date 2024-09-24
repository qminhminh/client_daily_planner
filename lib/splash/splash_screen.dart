// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors

import 'package:daily_planner_test/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Đợi 3 giây rồi chuyển sang màn hình chính
    await Future.delayed(const Duration(seconds: 6), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền cho splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thêm logo
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.jpg', // Đường dẫn đến logo của bạn
                  height: 150, // Chiều cao của logo
                  width: 150, // Chiều rộng của logo
                  fit: BoxFit.cover, // Đảm bảo hình ảnh không bị méo
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Thêm tên ứng dụng hoặc dòng chào mừng
            const Text(
              'Welcome to MyApp!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
