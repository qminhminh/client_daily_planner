// ignore_for_file: prefer_const_constructors

import 'package:daily_planner_test/auth/login_screen.dart';
import 'package:daily_planner_test/auth/register_screen.dart';
import 'package:daily_planner_test/calendar/task_detail_screen.dart';
import 'package:daily_planner_test/home/home_page.dart';
import 'package:daily_planner_test/model/task.dart';
import 'package:daily_planner_test/work/add_task_screen.dart';
import 'package:daily_planner_test/work/edit_task_screen.dart';
import 'package:flutter/material.dart';
import '../splash/splash_screen.dart'; // Cập nhật đường dẫn tùy theo cấu trúc dự án của bạn
// Cập nhật đường dẫn tùy theo cấu trúc dự án của bạn

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/addtask':
        return MaterialPageRoute(builder: (_) => AddTaskScreen());
      case '/edittask':
        final Task task =
            settings.arguments as Task; // Chuyển đổi arguments thành Task
        return MaterialPageRoute(
          builder: (_) => EditTaskScreen(task: task),
        );

      case '/taskdetail':
        final Task task =
            settings.arguments as Task; // Chuyển đổi arguments thành Task
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(task: task),
        );
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
