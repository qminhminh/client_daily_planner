// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:daily_planner_test/calendar/calendar_screen.dart';
import 'package:daily_planner_test/color/color_background.dart';
import 'package:daily_planner_test/setting/setting_screen.dart';
import 'package:daily_planner_test/statistcis/statitics_screen.dart';
import 'package:daily_planner_test/work/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetStorage _storage = GetStorage();
  bool isDarkMode = false;
  bool isBackgroundEnabled = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = _storage.read("isDarkMode") ?? false;
    isBackgroundEnabled = _storage.read("isBackground") ?? false;
  }

  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    WorkScreen(),
    CalendarScreen(),
    TaskStatisticsScreen(),
    SettingsScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ColorBackground.primaryColor;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: isBackgroundEnabled
              ? DecorationImage(
                  image:
                      AssetImage(isDarkMode ? 'assets/2.jpg' : 'assets/1.jpg'),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child:
              _pages.elementAt(_selectedIndex), // Hiển thị màn hình tương ứng
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Công việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex, // Màn hình hiện tại
        selectedItemColor: Colors.blueAccent, // Màu khi được chọn
        unselectedItemColor: Colors.grey, // Màu khi không được chọn
        showUnselectedLabels: true, // Hiển thị cả các nhãn chưa chọn
        backgroundColor: primaryColor, // Màu nền của thanh điều hướng
        type:
            BottomNavigationBarType.fixed, // Đảm bảo các icon giữ nguyên vị trí
        onTap: _onItemTapped, // Sự kiện nhấn vào các item
      ),
    );
  }
}
