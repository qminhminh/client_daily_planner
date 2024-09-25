// ignore_for_file: prefer_const_constructors, avoid_print

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
  final Color createdColor = Colors.blueAccent; // Màu cho công việc "Tạo mới"
  final Color inProgressColor = Colors.orange; // Màu cho công việc "Thực hiện"
  final Color successColor = Colors.green; // Màu cho công việc "Thành công"
  final Color finishedColor = Colors.red; // Màu cho công việc "Kết thúc"

  // Danh sách mood tạm thời
  final List<String> moods = ['😞', '😟', '😊', '😁'];
  List<Map<String, dynamic>> temporaryTaskList = [];

  @override
  void initState() {
    super.initState();
    temporaryTaskList.clear();
    // Tải thống kê công việc khi màn hình được khởi tạo
    context.read<TaskStatisticsCubit>().loadTaskStatistics();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 159, 207, 219),
        title: const Text('Thống kê công việc'),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<TaskStatisticsCubit, TaskStatisticsState>(
        listener: (context, state) {
          if (state is TaskStatisticsLoaded) {
            // Cập nhật danh sách tạm thời với dữ liệu từ server
            temporaryTaskList = state.tasks.map((task) {
              return {
                'date': task.dayOfWeek,
                'mood': moods[(temporaryTaskList.length % moods.length)],
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
                                    // Hiển thị ngày tháng cho từng cột
                                    return Text(
                                      '${temporaryTaskList[value.toInt()]['date']}',
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
                              for (var i = 0; i < temporaryTaskList.length; i++)
                                generateGroupData(
                                    i, temporaryTaskList[i]['status']),
                            ],
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: true),
                          ),
                        ),
                        // Hiển thị status trên đỉnh cột
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (var i = 0; i < temporaryTaskList.length; i++)
                                Positioned(
                                  left: (MediaQuery.of(context).size.width /
                                              temporaryTaskList.length) *
                                          i +
                                      5, // Căn giữa
                                  bottom: 10 +
                                      (generateGroupData(
                                                  i,
                                                  temporaryTaskList[i]
                                                      ['status'])
                                              .barRods
                                              .first
                                              .toY *
                                          30), // Điều chỉnh vị trí y của text
                                  child: Center(
                                    child: Text(
                                      temporaryTaskList[i]['status'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // Bạn có thể thay đổi màu sắc nếu cần
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hiển thị mood và ngày tháng
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: temporaryTaskList.length,
                    itemBuilder: (context, index) {
                      final moodData = temporaryTaskList[index];

                      String mood; // Khai báo biến mood
                      switch (moodData['status']) {
                        case 'Tạo mới':
                          mood = '😔'; // Mood tương ứng
                          break;
                        case 'Thực hiện':
                          mood = '😟'; // Mood tương ứng
                          break;
                        case 'Thành công':
                          mood = '😊'; // Mood tương ứng
                          break;
                        case 'Kết thúc':
                          mood = '😁'; // Mood tương ứng
                          break;
                        default:
                          mood = '😁'; // Mood mặc định
                      }

                      return ListTile(
                        title: Text('Ngày: ${moodData['date']}'),
                        subtitle:
                            Text('Mood: $mood'), // Sử dụng mood đã xác định
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is TaskStatisticsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container(); // Kết thúc để tránh lỗi
        },
      ),
    );
  }
}
