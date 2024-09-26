import 'package:daily_planner_test/model/task.dart';
import 'package:daily_planner_test/work/task_reponse.dart';
import 'package:daily_planner_test/work/work_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkCubit extends Cubit<WorkState> {
  final TaskRepository repository;

  WorkCubit(this.repository) : super(WorkInitial());

  void loadTasks() async {
    try {
      emit(WorkLoading());
      final tasks = await repository.fetchTasks();
      emit(WorkLoaded(tasks: tasks));
    } catch (e) {
      emit(WorkError(message: e.toString()));
    }
  }

  void addTask(Task task) async {
    try {
      emit(WorkLoading());
      await repository.addTask(task);
      loadTasks(); // Reload tasks after adding
    } catch (e) {
      emit(WorkError(message: e.toString()));
    }
  }

  void updateTask(Task task) async {
    try {
      emit(WorkLoading());
      await repository.updateTask(task);
      loadTasks(); // Reload tasks after updating
    } catch (e) {
      emit(WorkError(message: e.toString()));
    }
  }

  void deleteTask(String id) async {
    try {
      emit(WorkLoading());
      await repository.deleteTask(id);
      loadTasks(); // Reload tasks after deleting
    } catch (e) {
      emit(WorkError(message: e.toString()));
    }
  }

  void reorderTasks(List<Task> tasks) {
    emit(WorkLoaded(
        tasks: tasks)); // Cập nhật lại trạng thái Cubit với danh sách mới
  }
}
