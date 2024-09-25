// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:daily_planner_test/calendar/calendar_screen.dart';
import 'package:daily_planner_test/setting/setting_screen.dart';
import 'package:daily_planner_test/statistcis/statitics_screen.dart';
import 'package:daily_planner_test/work/work_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    const Color primaryColor = Color.fromARGB(255, 159, 207, 219);
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), // Hiển thị màn hình tương ứng
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
