import 'package:daily_planner_test/model/task.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<Task> tasks;

  CalendarLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);

  @override
  List<Object> get props => [message];
}

class CalendarDateSelected extends CalendarState {
  final List<Task> tasks;

  CalendarDateSelected(this.tasks);

  @override
  List<Object> get props => [tasks];
}
