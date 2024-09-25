// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:daily_planner_test/color/color_background.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_planner_test/statistcis/statitics_cubit.dart';
import 'package:daily_planner_test/statistcis/statitics_state.dart';

class TaskStatisticsScreen extends StatefulWidget {
  const TaskStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<TaskStatisticsScreen> createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  final Color createdColor = Colors.blueAccent;
  final Color inProgressColor = Colors.orange;
  final Color successColor = Colors.green;
  final Color finishedColor = Colors.red;

  List<Map<String, dynamic>> temporaryTaskList = [];

  @override
  void initState() {
    super.initState();
    temporaryTaskList.clear();
    // Load task statistics when the screen is initialized
    context.read<TaskStatisticsCubit>().loadTaskStatistics();
  }

  // Filter tasks based on their status
  List<Map<String, dynamic>> _filterTasks(String status) {
    return temporaryTaskList.where((task) => task['status'] == status).toList();
  }

  BarChartGroupData generateGroupData(int x, String status) {
    double barHeight;

    switch (status) {
      case 'Tạo mới':
        barHeight = 4;
        break;
      case 'Thực hiện':
        barHeight = 3;
        break;
      case 'Thành công':
        barHeight = 2;
        break;
      case 'Kết thúc':
        barHeight = 1;
        break;
      default:
        barHeight = 0;
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: barHeight,
          color: status == 'Tạo mới'
              ? createdColor
              : status == 'Thực hiện'
                  ? inProgressColor
                  : status == 'Thành công'
                      ? successColor
                      : finishedColor,
          width: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorBackground.primaryColor,
          title: const Text('Thống kê công việc'),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            padding: EdgeInsets.symmetric(horizontal: 16),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: 'Tạo mới'),
              Tab(text: 'Thực hiện'),
              Tab(text: 'Thành công'),
              Tab(text: 'Kết thúc'),
            ],
          ),
        ),
        body: BlocConsumer<TaskStatisticsCubit, TaskStatisticsState>(
          listener: (context, state) {
            if (state is TaskStatisticsLoaded) {
              temporaryTaskList = state.tasks.map((task) {
                return {
                  'content': task.content,
                  'date': task.dayOfWeek,
                  'status': task.status,
                };
              }).toList();

              print(
                  "Statistics Loaded: Created ${state.createdTasks}, In Progress ${state.inProgressTasks}, Success ${state.successTasks}, Finished ${state.finishedTasks}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loaded tasks: ${state.createdTasks}')),
              );
            } else if (state is TaskStatisticsError) {
              print("Error: ${state.message}");
            }
          },
          builder: (context, state) {
            if (state is TaskStatisticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskStatisticsLoaded) {
              return TabBarView(
                children: [
                  _buildTaskTab('Tạo mới'),
                  _buildTaskTab('Thực hiện'),
                  _buildTaskTab('Thành công'),
                  _buildTaskTab('Kết thúc'),
                ],
              );
            } else if (state is TaskStatisticsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container(); // End with a default case to avoid errors
          },
        ),
      ),
    );
  }

  // Build each tab with filtered tasks and the corresponding bar chart
  Widget _buildTaskTab(String status) {
    List<Map<String, dynamic>> filteredTasks = _filterTasks(status);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            // Display dates on the x-axis
                            return Text(
                              '${filteredTasks[value.toInt()]['date']}',
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < filteredTasks.length; i++)
                        generateGroupData(i, filteredTasks[i]['status']),
                    ],
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ],
            ),
          ),

          // Display the task list below the bar chart
          ListView.builder(
            shrinkWrap: true,
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return ListTile(
                title: Text('Ngày: ${task['date']}'),
                subtitle: Text('Công việc: ${task['content']}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
