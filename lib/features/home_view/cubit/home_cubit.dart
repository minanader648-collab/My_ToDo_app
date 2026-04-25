import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  String _searchQuery = '';

  HomeCubit() : super(HomeInitial()) {
    // Listen to Hive box changes for real-time updates
    Hive.box<TaskModel>('taskBox').watch().listen((_) {
      loadTasks();
    });
  }

  void searchTasks(String query) {
    _searchQuery = query.toLowerCase();
    loadTasks();
  }

  void loadTasks() {
    var box = Hive.box<TaskModel>('taskBox');
    
    List<TaskModel> allTasks = box.values.toList();
    
    // Seed initial data if empty and it's the very first run
    var sessionBox = Hive.box('sessionBox');
    bool isSeeded = sessionBox.get('isSeeded', defaultValue: false);

    if (allTasks.isEmpty && !isSeeded) {
      box.addAll([
        TaskModel(
          id: '1',
          title: 'UI Design Review',
          subtitle: '10:00 AM - Work',
          priority: 'High Priority',
          isDone: false,
          colorHex: '#6C5CE7',
          description: 'Review the latest Figma mockups with the team.',
          date: 'Apr 25',
          time: '10:00 AM',
          category: 'Work',
        ),
      ]);
      sessionBox.put('isSeeded', true);
      allTasks = box.values.toList();
    }

    // Apply Search Filter
    List<TaskModel> filteredTasks = allTasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery) ||
             task.subtitle.toLowerCase().contains(_searchQuery) ||
             task.description.toLowerCase().contains(_searchQuery);
    }).toList();

    int total = allTasks.length;
    int done = allTasks.where((t) => t.isDone).length;
    int active = total - done;

    emit(HomeSuccess(
      tasks: filteredTasks,
      total: total,
      active: active,
      done: done,
    ));
  }

  void toggleTask(TaskModel task) {
    task.isDone = !task.isDone;
    task.save();
    // loadTasks() will be called automatically by the watcher
  }
}
