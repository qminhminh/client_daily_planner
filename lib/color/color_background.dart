import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ColorBackground {
  static final GetStorage storage = GetStorage();
  static const String colorKey = 'primaryColor';

  static Color get primaryColor {
    // Đọc màu từ GetStorage, nếu không có sẽ trả về màu mặc định
    final colorValue = storage.read(colorKey);
    return colorValue != null
        ? Color(colorValue)
        : const Color.fromARGB(255, 159, 207, 219);
  }
}
