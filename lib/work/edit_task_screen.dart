// lib/screens/edit_task_screen.dart
// ignore_for_file: prefer_const_constructors

import 'package:daily_planner_test/model/task.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task; // Nhận task để chỉnh sửa

  EditTaskScreen({required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController reviewerController = TextEditingController();

  String selectedDayOfWeek = '';
  String selectedLeader = 'Thanh Ngân';
  String taskStatus = 'Tạo mới';

  final List<String> daysOfWeek = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ Nhật'
  ];

  final List<String> leaders = [
    'Thanh Ngân',
    'Hữu Nghĩa',
  ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu từ task hiện tại
    contentController.text = widget.task.content;
    timeController.text = widget.task.time;
    locationController.text = widget.task.location;
    noteController.text = widget.task.note;
    reviewerController.text = widget.task.reviewer;
    selectedDayOfWeek = widget.task.dayOfWeek;
    selectedLeader = widget.task.leader;
    taskStatus = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Công Việc'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ngày (Dropdown)
              DropdownButtonFormField<String>(
                value: selectedDayOfWeek,
                items: daysOfWeek.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDayOfWeek = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Ngày'),
              ),
              const SizedBox(height: 16.0),

              // Nội dung công việc
              TextField(
                controller: contentController,
                decoration:
                    const InputDecoration(labelText: 'Nội dung công việc'),
              ),
              const SizedBox(height: 16.0),

              // Thời gian
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Thời gian'),
              ),
              const SizedBox(height: 16.0),

              // Địa điểm
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Địa điểm'),
              ),
              const SizedBox(height: 16.0),

              // Chủ trì (Dropdown)
              DropdownButtonFormField<String>(
                value: selectedLeader,
                items: leaders.map((String leader) {
                  return DropdownMenuItem<String>(
                    value: leader,
                    child: Text(leader),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLeader = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Chủ trì'),
              ),
              const SizedBox(height: 16.0),

              // Ghi chú
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 16.0),

              // Trạng thái (Dropdown)
              DropdownButtonFormField<String>(
                value: taskStatus,
                items: ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc']
                    .map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    taskStatus = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Trạng thái'),
              ),
              const SizedBox(height: 20.0),

              // Nút lưu
              ElevatedButton(
                onPressed: () {
                  if (contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Vui lòng nhập nội dung công việc')),
                    );
                    return;
                  }

                  final updatedTask = Task(
                    id: widget.task.id,
                    userId: widget.task.userId, // Giữ nguyên userId
                    dayOfWeek: selectedDayOfWeek,
                    content: contentController.text,
                    time: timeController.text,
                    location: locationController.text,
                    leader: selectedLeader,
                    note: noteController.text,
                    status: taskStatus,
                    reviewer: reviewerController.text,
                  );

                  context.read<WorkCubit>().updateTask(updatedTask);
                  Navigator.pop(context); // Đóng màn hình sau khi lưu
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
