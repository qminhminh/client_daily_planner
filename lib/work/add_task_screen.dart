// lib/screens/add_task_screen.dart
// ignore_for_file: use_key_in_widget_constructors, unnecessary_brace_in_string_interps, prefer_const_constructors

import 'package:daily_planner_test/model/task.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController reviewerController = TextEditingController();

  String selectedDayOfWeek = '';
  String selectedLeader = 'Thanh Ngân';
  DateTime selectedDate = DateTime.now();
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
    selectedDayOfWeek = _getDayOfWeek(selectedDate);
  }

  // Hàm lấy ngày trong tuần từ DateTime
  String _getDayOfWeek(DateTime date) {
    final dayIndex = date.weekday; // 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
    return daysOfWeek[dayIndex - 1]; // `daysOfWeek` bắt đầu từ 'Thứ 2'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Công Việc'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ngày (Chọn từ Dropdown)
              // DropdownButtonFormField<String>(
              //   value: selectedDayOfWeek,
              //   items: daysOfWeek.map((String day) {
              //     return DropdownMenuItem<String>(
              //       value: day,
              //       child: Text(day),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectedDayOfWeek = newValue!;
              //     });
              //   },
              //   decoration: const InputDecoration(labelText: 'Ngày'),
              // ),
              const SizedBox(height: 16.0),

              // Ngày (DatePicker)
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      selectedDayOfWeek = _getDayOfWeek(selectedDate);
                    });
                  }
                },
                child: Text(
                  'Chọn Ngày: ${selectedDate.toLocal().toString().split(' ')[0]} (${selectedDayOfWeek})',
                ),
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
              const SizedBox(height: 16.0),

              // Người thực hiện kiểm duyệt
              TextField(
                controller: reviewerController,
                decoration: const InputDecoration(
                    labelText: 'Người thực hiện kiểm duyệt'),
              ),
              const SizedBox(height: 20.0),

              // Nút lưu
              ElevatedButton(
                onPressed: () {
                  if (contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter task content')),
                    );
                    return;
                  }

                  final task = Task(
                    id: '',
                    userId: '',
                    dayOfWeek:
                        '${selectedDate.toLocal().toString().split(' ')[0]} ($selectedDayOfWeek)',
                    content: contentController.text,
                    time: timeController.text,
                    location: locationController.text,
                    leader: selectedLeader,
                    note: noteController.text,
                    status: taskStatus,
                    reviewer: reviewerController.text,
                  );
                  context.read<WorkCubit>().addTask(task);
                  Navigator.pop(context);
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
