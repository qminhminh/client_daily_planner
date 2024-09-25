// lib/repositories/task_repository.dart
// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:daily_planner_test/model/task.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl;
  final box = GetStorage();

  TaskRepository(this.baseUrl);

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/fetch-task/${box.read('userId')}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print("Fetch-task:" + e.toString());
      return [];
    }
  }

  Future<void> addTask(Task task) async {
    String token = box.read('token');
    String id = box.read('userId');
    String accessToken = jsonDecode(token);
    print('Token: $token, UserID: $id');

    if (token == null || id == null) {
      throw Exception("Missing token or userId");
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-task'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          "userId": id,
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
        print('Response body: ${response.body}');
        throw Exception('Failed to add task');
      }
    } catch (e) {
      print("Add-task:" + e.toString());
    }
  }

  Future<void> updateTask(Task task) async {
    try {
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
    } catch (e) {
      print("Update-task:" + e.toString());
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete-task/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print("Delete-task:" + e.toString());
    }
  }
}
