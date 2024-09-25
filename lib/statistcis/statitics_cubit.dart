import 'package:bloc/bloc.dart';
import 'package:daily_planner_test/statistcis/statitics_state.dart';
import 'package:daily_planner_test/work/task_reponse.dart';

class TaskStatisticsCubit extends Cubit<TaskStatisticsState> {
  final TaskRepository taskRepository;

  TaskStatisticsCubit(this.taskRepository) : super(TaskStatisticsInitial());

  Future<void> loadTaskStatistics() async {
    try {
      emit(TaskStatisticsLoading());
      final tasks = await taskRepository.fetchTasks();

      if (tasks.isEmpty) {
        emit(TaskStatisticsError('No tasks found'));
        return;
      }

      // Tính toán số lượng công việc theo trạng thái
      final createdTasks =
          tasks.where((task) => task.status == 'Tạo mới').length;
      final inProgressTasks =
          tasks.where((task) => task.status == 'Thực hiện').length;
      final successTasks =
          tasks.where((task) => task.status == 'Thành công').length;
      final finishedTasks =
          tasks.where((task) => task.status == 'Kết thúc').length;

      emit(TaskStatisticsLoaded(
        tasks: tasks, // Chuyển đổi thành danh sách mood và ngày tháng
        createdTasks: createdTasks,
        inProgressTasks: inProgressTasks,
        successTasks: successTasks,
        finishedTasks: finishedTasks,
      ));
    } catch (e) {
      emit(TaskStatisticsError('Failed to load statistics'));
    }
  }
}
