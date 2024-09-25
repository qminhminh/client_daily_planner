import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetStorage storage = GetStorage();

  static const String themeKey = 'isDarkMode';
  static const String colorKey = 'primaryColor';
  static const String fontKey = 'fontFamily';

  SettingsCubit()
      : super(SettingsState(
          isDarkMode: GetStorage().read(themeKey) ?? false,
          primaryColor: Color(GetStorage().read(colorKey) ?? 0xFF2196F3),
          fontFamily: GetStorage().read(fontKey) ?? 'Roboto',
        ));

  void toggleTheme(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
    storage.write(themeKey, isDark);
  }

  void changePrimaryColor(Color color) {
    emit(state.copyWith(primaryColor: color));
    storage.write(colorKey, color.value);
  }

  void changeFontFamily(String font) {
    emit(state.copyWith(fontFamily: font));
    storage.write(fontKey, font);
  }
}
