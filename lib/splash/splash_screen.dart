// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // Sử dụng GetStorage để lưu trữ token

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate(); // Kiểm tra token sau khi vào SplashScreen
  }

  Future<void> _checkTokenAndNavigate() async {
    final box = GetStorage();
    String? token = box.read('token');

    // Giả lập việc chờ trong vài giây để hiển thị splash (6 giây như yêu cầu của bạn)
    await Future.delayed(const Duration(seconds: 6));

    // Điều hướng dựa vào token và trạng thái xác minh
    if (token == null) {
      // Nếu không có token, điều hướng đến trang đăng nhập (LoginScreen)
      Navigator.pushReplacementNamed(context, '/login');
    } else if (token != null) {
      // Nếu có token và đã xác minh, điều hướng đến MainScreen
      Navigator.pushReplacementNamed(context, '/home');
    }
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
              'Chào mừng bạn!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
