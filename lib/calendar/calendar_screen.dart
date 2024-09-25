// ignore_for_file: prefer_const_constructors

import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_cubit.dart';
import 'calendar_state.dart';
import 'package:daily_planner_test/model/task.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  List<Task> _selectedTasks = [];
  List<Task> _allTasks = []; // Danh sách chứa tất cả các nhiệm vụ

  // Màu chủ đạo của ứng dụng
  final Color primaryColor = const Color.fromARGB(255, 159, 207, 219);

  @override
  void initState() {
    super.initState();
    _clearTasks();
    context.read<CalendarCubit>().fetchTasks();
  }

  void _clearTasks() {
    setState(() {
      _selectedTasks = [];
      _allTasks = [];
    });
  }

  String _sanitizeDate(String rawDate) {
    return rawDate.split(' ').first; // Chỉ lấy phần ngày tháng năm
  }

  List<Task> _getTasksForDay(DateTime day) {
    return _allTasks.where((task) {
      final taskDate = DateTime.parse(_sanitizeDate(task.dayOfWeek));
      return isSameDay(taskDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Lịch Công Việc'),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CalendarLoaded) {
            _allTasks = state.tasks;

            return Column(
              children: [
                TableCalendar<Task>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _selectedTasks = _getTasksForDay(selectedDay);
                    });
                  },
                  eventLoader: _getTasksForDay,
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, tasks) {
                      if (tasks.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red, // Màu cho ngày có nhiệm vụ
                          ),
                          width: 15.0,
                          height: 15.0,
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _selectedTasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: _selectedTasks.length,
                          itemBuilder: (context, index) {
                            final task = _selectedTasks[index];
                            return Card(
                              color: primaryColor,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: ListTile(
                                title: Text(
                                  task.content,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(task.dayOfWeek),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/edittask",
                                            arguments: task);
                                      },
                                      color: Colors
                                          .black, // Màu của biểu tượng chỉnh sửa
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: primaryColor,
                                              title: const Text("Xác nhận xóa",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25)),
                                              content: const Text(
                                                  "Bạn có chắc chắn muốn xóa task này không?",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 23)),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("Hủy"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    "Xóa",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<WorkCubit>()
                                                        .deleteTask(task.id);

                                                    setState(() {
                                                      _selectedTasks
                                                          .removeAt(index);
                                                      _allTasks.removeWhere(
                                                          (element) =>
                                                              element.id ==
                                                              task.id);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/taskdetail",
                                    arguments: task,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Không có công việc nào cho ngày này.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ],
            );
          }
          return const Center(child: Text('Không có công việc nào.'));
        },
      ),
    );
  }
}
