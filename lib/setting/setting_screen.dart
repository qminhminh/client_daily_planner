// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'package:daily_planner_test/auth/login_cubit.dart';
import 'package:daily_planner_test/color/color_background.dart';
import 'package:daily_planner_test/setting/setting_cubit.dart';
import 'package:daily_planner_test/setting/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // const Color primaryColor = Color.fromARGB(255, 159, 207, 219);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorBackground.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text("Cài đặt"),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // Do something when state changes (e.g., show a message)
        },
        builder: (context, state) {
          return Column(
            children: [
              // Toggle between dark and light mode
              SwitchListTile(
                title: const Text("Chế độ tối"),
                value: state.isDarkMode,
                onChanged: (value) {
                  context.read<SettingsCubit>().toggleTheme(value);
                },
              ),
              // Change primary color
              ListTile(
                title: const Text("Màu chính"),
                trailing: CircleAvatar(
                  backgroundColor: state.primaryColor,
                ),
                onTap: () async {
                  Color? pickedColor = await showDialog(
                    context: context,
                    builder: (context) => ColorPickerDialog(
                      initialColor: state.primaryColor,
                    ),
                  );
                  if (pickedColor != null) {
                    context
                        .read<SettingsCubit>()
                        .changePrimaryColor(pickedColor);
                  }
                },
              ),
              // Change font family
              ListTile(
                title: const Text("Font chữ"),
                trailing: DropdownButton<String>(
                  value: state.fontFamily,
                  items: ['Roboto', 'Arial', 'Times New Roman']
                      .map((font) => DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().changeFontFamily(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<LoginCubit>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Đăng xuất',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorBackground.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  ColorPickerDialog({required this.initialColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn màu'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: initialColor,
          onColorChanged: (color) {
            Navigator.of(context).pop(color);
          },
        ),
      ),
    );
  }
}
