import 'package:bloc/bloc.dart';
import 'package:daily_planner_test/calendar/calendar_state.dart';
import 'package:daily_planner_test/work/task_reponse.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final TaskRepository taskRepository;

  CalendarCubit(this.taskRepository) : super(CalendarInitial());

  Future<void> fetchTasks() async {
    try {
      emit(CalendarLoading());
      final tasks = await taskRepository.fetchTasks();
      emit(CalendarLoaded(tasks));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  void selectDate(DateTime date) {
    if (state is CalendarLoaded) {
      final tasks = (state as CalendarLoaded).tasks;
      final selectedDateTasks = tasks
          .where((task) =>
              task.dayOfWeek.contains(date.toLocal().toString().split(' ')[0]))
          .toList();
      emit(CalendarDateSelected(selectedDateTasks));
    }
  }
}
