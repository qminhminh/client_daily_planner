import 'package:flutter/material.dart';

class SettingsState {
  final bool isDarkMode;
  final Color primaryColor;
  final String fontFamily;

  SettingsState({
    required this.isDarkMode,
    required this.primaryColor,
    required this.fontFamily,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    Color? primaryColor,
    String? fontFamily,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
