// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import, avoid_print

import 'dart:async';
import 'package:daily_planner_test/model/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:intl/intl.dart'; // Thư viện để xử lý chuỗi thời gian

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    tz_data.initializeTimeZones(); // Initialize time zones

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo'); // Your app icon

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleTaskNotificationWithCountdown(Task task) async {
    // Chuyển đổi thời gian từ chuỗi thành DateTime
    DateTime taskDateTime = _parseTaskTime(task);

    // Tính toán thời gian còn lại từ thời điểm hiện tại đến taskDateTime
    Duration timeRemaining = taskDateTime.difference(DateTime.now());

    if (timeRemaining.isNegative) {
      // Nếu thời gian task đã qua, không cần đếm ngược
      print('Task đã qua thời gian.');
      return;
    }

    // Đếm ngược cho đến khi thông báo
    Timer(timeRemaining, () {
      _showTaskNotification(task);
    });
  }

  DateTime _parseTaskTime(Task task) {
    // Lấy ngày và giờ từ các trường của task
    final dateString = task.dayOfWeek.split(' ')[0]; // Lấy "2024-09-26"
    final timeString = task.time; // Lấy "15:50"

    // Ghép ngày và giờ lại thành một chuỗi
    final fullDateTimeString = "$dateString $timeString";

    // Chuyển chuỗi thành DateTime
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    try {
      return format.parse(fullDateTimeString);
    } catch (e) {
      // In thông báo lỗi nếu có
      print("Error parsing date-time: $e");
      // Xử lý lỗi theo cách bạn muốn, có thể ném lại hoặc trả về giá trị mặc định
      rethrow;
    }
  }

  void _showTaskNotification(Task task) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminder_channel', // id
      'Nhắc nhở nhiệm vụ', // name
      channelDescription: 'Kênh cho lời nhắc nhiệm vụ',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      task.id.hashCode, // Unique ID for the notification
      'Nhắc nhở nhiệm vụ: ${task.content}', // Notification title
      'Dự kiến ​​cho ${task.time} vào ${task.dayOfWeek}', // Notification body
      platformChannelSpecifics,
    );
  }
}
