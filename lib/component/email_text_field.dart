// ignore_for_file: unnecessary_string_interpolations

import 'package:daily_planner_test/color/color_background.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String labeltext;
  final String notevalidate;
  final IconData icon; // Đổi từ Icon thành IconData
  final Function(String) onChanged;

  const TextFieldComponent({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.labeltext,
    required this.notevalidate,
    required this.icon, // Kiểu IconData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: ColorBackground.primaryColor,
        fontSize: 18,
      ),
      cursorColor: ColorBackground.primaryColor,
      controller: controller,
      decoration: InputDecoration(
        labelText: '$labeltext',
        labelStyle: TextStyle(
          color: ColorBackground.primaryColor,
        ),
        fillColor: ColorBackground.primaryColor,
        iconColor: ColorBackground.primaryColor,
        prefixIcon: Icon(
          // Sử dụng Icon với IconData
          icon,
          color: ColorBackground.primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: ColorBackground.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: ColorBackground.primaryColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: ColorBackground.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$notevalidate';
        }
        return null;
      },
    );
  }
}
