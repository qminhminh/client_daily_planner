// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors, sort_child_properties_last, deprecated_member_use

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
  DateTime selectedDate = DateTime.now(); // Thêm biến selectedDate
  String selectedLeader = 'Thanh Ngân';
  String taskStatus = 'Tạo mới';

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
    selectedLeader = widget.task.leader;
    taskStatus = widget.task.status;

    // Khởi tạo ngày từ task và lấy thứ trong tuần
    selectedDate = DateTime.parse(widget.task.dayOfWeek.split(' ')[0]);
    selectedDayOfWeek = _getDayOfWeek(selectedDate);
  }

  // Hàm lấy ngày trong tuần từ DateTime
  String _getDayOfWeek(DateTime date) {
    final dayIndex = date.weekday; // 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
    const List<String> daysOfWeek = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ Nhật'
    ];
    return daysOfWeek[dayIndex - 1]; // daysOfWeek bắt đầu từ 'Thứ 2'
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 159, 207, 219);
    final Color buttonColor = primaryColor;
    final Color textColor = Colors.black87;
    final Color borderColor = primaryColor.withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Công Việc',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: primaryColor),
                    Text(
                      style: TextStyle(color: textColor),
                      'Chọn Ngày: ${selectedDate.toLocal().toString().split(' ')[0]} ($selectedDayOfWeek),',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Nội dung công việc
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
              const SizedBox(height: 20.0),
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
                      SnackBar(
                          content: Text('Vui lòng nhập nội dung công việc')),
                    );
                    return;
                  }

                  final updatedTask = Task(
                    id: widget.task.id,
                    userId: widget.task.userId, // Giữ nguyên userId
                    dayOfWeek:
                        '${selectedDate.toLocal().toString().split(' ')[0]} ($selectedDayOfWeek)', // Cập nhật ngày và thứ
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
