// lib/models/task.dart
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id; // Thêm trường id
  final String userId;
  final String dayOfWeek;
  final String content;
  final String time;
  final String location;
  final String leader;
  final String note;
  final String status;
  final String reviewer;

  Task({
    required this.id, // Thêm trường id vào constructor
    required this.userId,
    required this.dayOfWeek,
    required this.content,
    required this.time,
    required this.location,
    required this.leader,
    required this.note,
    required this.status,
    required this.reviewer,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        dayOfWeek,
        content,
        time,
        location,
        leader,
        note,
        status,
        reviewer
      ];

  // Factory method for creating Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'], // Lấy id từ _id
      userId: json['userId'],
      dayOfWeek: json['dayOfWeek'],
      content: json['content'],
      time: json['time'],
      location: json['location'],
      leader: json['leader'],
      note: json['note'],
      status: json['status'],
      reviewer: json['reviewer'],
    );
  }

  // Method for converting Task to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'dayOfWeek': dayOfWeek,
      'content': content,
      'time': time,
      'location': location,
      'leader': leader,
      'note': note,
      'status': status,
      'reviewer': reviewer,
    };
  }
}
