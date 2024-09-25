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
    return BlocProvider(
      create: (_) => WorkCubit(repository)..loadTasks(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh Sách Công Việc'),
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
                            // Handle edit task
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<WorkCubit>().deleteTask(task.id);
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
      ),
    );
  }
}
