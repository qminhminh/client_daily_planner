// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_declarations, use_key_in_widget_constructors

import 'package:daily_planner_test/color/color_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_planner_test/enviroment/environment.dart';
import 'package:daily_planner_test/work/task_reponse.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:daily_planner_test/work/work_state.dart';

class WorkScreen extends StatefulWidget {
  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final TaskRepository repository =
      TaskRepository('${Environment().appBaseUrl}/api/tasks');

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = ColorBackground.primaryColor;
    final Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Danh sách công việc'),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: BlocConsumer<WorkCubit, WorkState>(
        listener: (context, state) {
          if (state is WorkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is WorkLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkLoaded) {
            // Danh sách các task có thể reorder
            return ReorderableListView.builder(
              itemCount: state.tasks.length,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final task = state.tasks.removeAt(oldIndex);
                  state.tasks.insert(newIndex, task);

                  // Cập nhật Cubit sau khi reorder
                  context.read<WorkCubit>().reorderTasks(state.tasks);
                });
              },
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  key: ValueKey(task.id), // Sử dụng id của task làm key
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: primaryColor, // Màu nền của Card
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      task.content,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 23),
                    ),
                    subtitle: Text(
                      '${task.dayOfWeek}, ${task.time}',
                      style: TextStyle(
                        color: subtitleColor, // Màu chữ phụ đề
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, "/edittask",
                                arguments: task);
                          },
                          color: Colors.black, // Màu của biểu tượng chỉnh sửa
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: primaryColor,
                                  title: const Text("Xác nhận xóa",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  content: const Text(
                                      "Bạn có chắc chắn muốn xóa task này không?",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 23)),
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
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<WorkCubit>()
                                            .deleteTask(task.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          color: Colors.red, // Màu của biểu tượng xóa
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Không có công việc nào'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addtask');
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor, // Màu của nút thêm
      ),
    );
  }
}
