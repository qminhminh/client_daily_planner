// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:daily_planner_test/model/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nội dung: ${widget.task.content}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Thời gian: ${widget.task.time}'),
            SizedBox(height: 10),
            Text('Địa điểm: ${widget.task.location}'),
            SizedBox(height: 10),
            Text('Trạng thái: ${widget.task.status}'),
            // Thêm các thông tin khác của task
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Thêm logic để chỉnh sửa công việc
              },
              child: const Text('Chỉnh Sửa'),
            ),
          ],
        ),
      ),
    );
  }
}
