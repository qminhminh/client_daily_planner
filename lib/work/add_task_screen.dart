// ignore_for_file: prefer_const_declarations, prefer_const_constructors, unnecessary_brace_in_string_interps, sort_child_properties_last, use_key_in_widget_constructors, deprecated_member_use

import 'package:daily_planner_test/color/color_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_planner_test/model/task.dart';
import 'package:daily_planner_test/work/work_cubit.dart';

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
    final Color primaryColor = ColorBackground.primaryColor;
    final Color buttonColor = primaryColor;

    final Color borderColor = primaryColor.withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm Công Việc',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: primaryColor),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Chọn Ngày: ${selectedDate.toLocal().toString().split(' ')[0]} (${selectedDayOfWeek})',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Nội dung công việc
            _buildTextField(
                controller: contentController,
                label: 'Nội dung công việc',
                borderColor: borderColor),
            const SizedBox(height: 16.0),

            // Thời gian
            _buildTextField(
                controller: timeController,
                label: 'Thời gian',
                borderColor: borderColor),
            const SizedBox(height: 16.0),

            // Địa điểm
            _buildTextField(
                controller: locationController,
                label: 'Địa điểm',
                borderColor: borderColor),
            const SizedBox(height: 16.0),

            // Chủ trì (Dropdown)
            _buildDropdown<String>(
              value: selectedLeader,
              items: leaders,
              onChanged: (newValue) {
                setState(() {
                  selectedLeader = newValue!;
                });
              },
              label: 'Chủ trì',
              borderColor: borderColor,
            ),
            const SizedBox(height: 16.0),

            // Ghi chú
            _buildTextField(
                controller: noteController,
                label: 'Ghi chú',
                borderColor: borderColor),
            const SizedBox(height: 16.0),

            // Trạng thái (Dropdown)
            _buildDropdown<String>(
              value: taskStatus,
              items: ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc'],
              onChanged: (newValue) {
                setState(() {
                  taskStatus = newValue!;
                });
              },
              label: 'Trạng thái',
              borderColor: borderColor,
            ),
            const SizedBox(height: 16.0),

            // Người thực hiện kiểm duyệt
            _buildTextField(
                controller: reviewerController,
                label: 'Người thực hiện kiểm duyệt',
                borderColor: borderColor),
            const SizedBox(height: 20.0),

            // Nút lưu
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập nội dung công việc')),
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
              child: Text('Lưu',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required Color borderColor}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String label,
    required Color borderColor,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
