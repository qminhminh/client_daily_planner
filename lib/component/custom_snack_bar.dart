import 'package:daily_planner_test/color/color_background.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar show({
    required String message,
    Color? backgroundColor, // Mặc định màu nền
    IconData icon = Icons.add_alert, // Mặc định icon
    Color iconColor = Colors.white, // Mặc định màu icon
    Color textColor = Colors.white, // Màu chữ mặc định
  }) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(
            message,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? ColorBackground.primaryColor,
      behavior: SnackBarBehavior.floating,
    );
  }
}
