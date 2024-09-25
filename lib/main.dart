import 'package:daily_planner_test/enviroment/environment.dart';
import 'package:daily_planner_test/firebase_options.dart';
import 'package:daily_planner_test/router/app_router.dart';
import 'package:daily_planner_test/work/task_reponse.dart';
import 'package:daily_planner_test/work/work_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: Environment.);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  final TaskRepository taskRepository =
      TaskRepository('${Environment().appBaseUrl}/api/tasks');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WorkCubit>(
          create: (context) => WorkCubit(taskRepository)..loadTasks(),
        ),
        // Add other cubits/blocs here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
