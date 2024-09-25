import 'package:daily_planner_test/model/task.dart';
import 'package:equatable/equatable.dart';

abstract class TaskStatisticsState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskStatisticsInitial extends TaskStatisticsState {}

class TaskStatisticsLoading extends TaskStatisticsState {}

class TaskStatisticsLoaded extends TaskStatisticsState {
  final List<Task> tasks; // Thêm trường này
  final int createdTasks;
  final int inProgressTasks;
  final int successTasks;
  final int finishedTasks;

  TaskStatisticsLoaded({
    required this.tasks, // Thêm trường này
    required this.createdTasks,
    required this.inProgressTasks,
    required this.successTasks,
    required this.finishedTasks,
  });

  @override
  List<Object> get props => [
        tasks,
        createdTasks,
        inProgressTasks,
        successTasks,
        finishedTasks,
      ];
}

class TaskStatisticsError extends TaskStatisticsState {
  final String message;

  TaskStatisticsError(this.message);

  @override
  List<Object> get props => [message];
}
