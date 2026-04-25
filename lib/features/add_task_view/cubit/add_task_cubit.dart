import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  String selectedDate = 'Apr 25';
  String selectedTime = '10:00 AM';
  String selectedPriority = 'Medium';
  String selectedCategory = 'Work';

  void updateDate(String date) {
    selectedDate = date;
    emit(AddTaskUpdated());
  }

  void updateTime(String time) {
    selectedTime = time;
    emit(AddTaskUpdated());
  }

  void updatePriority(String priority) {
    selectedPriority = priority;
    emit(AddTaskUpdated());
  }

  void updateCategory(String category) {
    selectedCategory = category;
    emit(AddTaskUpdated());
  }

  void addTask({
    required String title,
    required String description,
  }) async {
    emit(AddTaskLoading());
    try {
      var box = Hive.box<TaskModel>('taskBox');
      
      // Determine color based on priority
      String colorHex = '#A29BFE'; // Default secondary
      if (selectedPriority == 'High') colorHex = '#6C5CE7'; // Primary
      if (selectedPriority == 'Medium') colorHex = '#00CEC9'; // Teal
      if (selectedPriority == 'Low') colorHex = '#FDCB6E'; // Amber

      TaskModel task = TaskModel(
        id: DateTime.now().toString(),
        title: title,
        subtitle: '$selectedTime - $selectedCategory',
        description: description,
        date: selectedDate,
        time: selectedTime,
        priority: selectedPriority,
        category: selectedCategory,
        isDone: false,
        colorHex: colorHex,
      );

      await box.add(task);
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskFailure(errMessage: e.toString()));
    }
  }
}
