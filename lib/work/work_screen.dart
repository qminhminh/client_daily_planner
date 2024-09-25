// lib/screens/work_screen.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:daily_planner_test/enviroment/environment.dart';
import 'package:daily_planner_test/work/task_reponse.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:daily_planner_test/work/work_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkScreen extends StatelessWidget {
  final TaskRepository repository =
      TaskRepository('${Environment().appBaseUrl}/api/tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Công Việc'),
        automaticallyImplyLeading: false,
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
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.content),
                  subtitle: Text('${task.dayOfWeek}, ${task.time}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, "/edittask",
                              arguments: task);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận xóa"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn xóa task này không?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Hủy"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng hộp thoại
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Xóa"),
                                    onPressed: () {
                                      context
                                          .read<WorkCubit>()
                                          .deleteTask(task.id); // Gọi hàm xóa
                                      Navigator.of(context)
                                          .pop(); // Đóng hộp thoại
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
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
      ),
    );
  }
}
