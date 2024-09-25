// lib/repositories/task_repository.dart
import 'dart:convert';
import 'package:daily_planner_test/model/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl;

  TaskRepository(this.baseUrl);

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/fetch-task'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-task'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'dayOfWeek': task.dayOfWeek,
        'content': task.content,
        'time': task.time,
        'location': task.location,
        'leader': task.leader,
        'note': task.note,
        'status': task.status,
        'reviewer': task.reviewer,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-task/${task.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'dayOfWeek': task.dayOfWeek,
        'content': task.content,
        'time': task.time,
        'location': task.location,
        'leader': task.leader,
        'note': task.note,
        'status': task.status,
        'reviewer': task.reviewer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-task/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
