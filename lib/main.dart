// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import

import 'package:daily_planner_test/auth/login_cubit.dart';
import 'package:daily_planner_test/calendar/calendar_cubit.dart';
import 'package:daily_planner_test/calendar/calendar_screen.dart';
import 'package:daily_planner_test/enviroment/environment.dart';
import 'package:daily_planner_test/firebase_options.dart';
import 'package:daily_planner_test/router/app_router.dart';
import 'package:daily_planner_test/setting/setting_cubit.dart';
import 'package:daily_planner_test/setting/setting_state.dart';
import 'package:daily_planner_test/statistcis/statitics_cubit.dart';
import 'package:daily_planner_test/statistcis/statitics_screen.dart';
import 'package:daily_planner_test/work/task_reponse.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init(); // Initialize GetStorage
  tz.initializeTimeZones(); // Khởi tạo múi giờ

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  final TaskRepository taskRepository =
      TaskRepository('${Environment().appBaseUrl}/api/tasks');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WorkCubit>(
          create: (context) => WorkCubit(taskRepository)..loadTasks(),
        ),
        BlocProvider(
          create: (context) => CalendarCubit(taskRepository),
          child: CalendarScreen(),
        ),
        BlocProvider(
          create: (context) => TaskStatisticsCubit(taskRepository),
          child: TaskStatisticsScreen(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(httpClient: http.Client()),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: state.isDarkMode ? Brightness.dark : Brightness.light,
            primaryColor: state.primaryColor,
            fontFamily: state.fontFamily,
          ),
          initialRoute: '/splash',
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
