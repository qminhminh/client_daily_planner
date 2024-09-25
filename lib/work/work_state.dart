// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:daily_planner_test/model/task.dart';
import 'package:equatable/equatable.dart';

abstract class WorkState extends Equatable {
  const WorkState();

  @override
  List<Object> get props => [];
}

class WorkInitial extends WorkState {}

class WorkLoading extends WorkState {}

class WorkLoaded extends WorkState {
  final List<Task> tasks;

  WorkLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class WorkError extends WorkState {
  final String message;

  WorkError({required this.message});

  @override
  List<Object> get props => [message];
}
