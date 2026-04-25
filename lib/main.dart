import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_mobile_application/core/models/user_model.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'package:project_mobile_application/core/models/sub_task_model.dart';
import 'package:project_mobile_application/features/splash_view/spalsh_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(SubTaskModelAdapter());
  await Hive.openBox<UserModel>("userBox");
  await Hive.openBox<TaskModel>("taskBox");
  await Hive.openBox("sessionBox");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'My ToDo',
      home: const SplashView(),
    );
  }
}
