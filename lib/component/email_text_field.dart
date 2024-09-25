// ignore_for_file: unnecessary_string_interpolations

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
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 18,
      ),
      cursorColor: const Color.fromARGB(255, 159, 207, 219),
      controller: controller,
      decoration: InputDecoration(
        labelText: '$labeltext',
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 159, 207, 219),
        ),
        fillColor: const Color.fromARGB(255, 159, 207, 219),
        iconColor: const Color.fromARGB(255, 159, 207, 219),
        prefixIcon: Icon(
          // Sử dụng Icon với IconData
          icon,
          color: const Color.fromARGB(255, 159, 207, 219),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 159, 207, 219),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 159, 207, 219),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 159, 207, 219),
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
