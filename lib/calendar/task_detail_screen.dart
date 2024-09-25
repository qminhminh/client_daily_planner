import 'package:daily_planner_test/color/color_background.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner_test/model/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Màu chủ đạo của app
  final Color primaryColor = ColorBackground.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Chi Tiết Công Việc',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), // Màu của nút quay lại
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nội dung công việc
            _buildInfoRow('Nội dung:', widget.task.content),
            const SizedBox(height: 20),

            // Thời gian
            _buildInfoRow('Thời gian:', widget.task.time),
            const SizedBox(height: 20),

            // Địa điểm
            _buildInfoRow('Địa điểm:', widget.task.location),
            const SizedBox(height: 20),

            // Trạng thái
            _buildInfoRow('Trạng thái:', widget.task.status),
            const SizedBox(height: 20),

            // Leader
            _buildInfoRow('Leader:', widget.task.leader),
            const SizedBox(height: 40),

            // Nút chỉnh sửa công việc
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic để chỉnh sửa công việc
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                ),
                child: const Text(
                  'Chỉnh Sửa',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng các hàng thông tin
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
