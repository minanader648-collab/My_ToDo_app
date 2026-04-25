import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/features/add_task_view/cubit/add_task_cubit.dart';
import 'package:project_mobile_application/features/add_task_view/cubit/add_task_state.dart';
import 'package:project_mobile_application/features/add_task_view/widgets/custom_label.dart';
import 'package:project_mobile_application/features/add_task_view/widgets/custom_chip.dart';
import 'package:project_mobile_application/features/add_task_view/widgets/picker_box.dart';

import 'package:intl/intl.dart';

import 'package:project_mobile_application/core/utils/responsive_extension.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, AddTaskCubit cubit) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      cubit.updateDate(DateFormat('MMM dd').format(picked));
    }
  }

  Future<void> _selectTime(BuildContext context, AddTaskCubit cubit) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!context.mounted) return;
      final formattedTime = picked.format(context);
      cubit.updateTime(formattedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: BlocConsumer<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          if (state is AddTaskSuccess) {
            Navigator.pop(context, true);
          } else if (state is AddTaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<AddTaskCubit>();
          
          return Scaffold(
            backgroundColor: surface,
            appBar: AppBar(
              backgroundColor: primary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: context.width(6)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Create New Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.width(5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(context.width(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomLabel(text: 'Task Title'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _titleController,
                    hint: 'Team meeting preparation',
                  ),
                  const SizedBox(height: 24),

                  const CustomLabel(text: 'Description'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _descController,
                    hint: 'Add a description...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomLabel(text: 'Date'),
                            const SizedBox(height: 8),
                            PickerBox(
                              icon: Icons.calendar_today_outlined, 
                              text: cubit.selectedDate,
                              onTap: () => _selectDate(context, cubit),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomLabel(text: 'Time'),
                            const SizedBox(height: 8),
                            PickerBox(
                              icon: Icons.access_time, 
                              text: cubit.selectedTime,
                              onTap: () => _selectTime(context, cubit),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const CustomLabel(text: 'Priority'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomChip(label: 'High', isSelected: cubit.selectedPriority == 'High', onTap: () => cubit.updatePriority('High')),
                      const SizedBox(width: 8),
                      CustomChip(label: 'Medium', isSelected: cubit.selectedPriority == 'Medium', onTap: () => cubit.updatePriority('Medium')),
                      const SizedBox(width: 8),
                      CustomChip(label: 'Low', isSelected: cubit.selectedPriority == 'Low', onTap: () => cubit.updatePriority('Low')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const CustomLabel(text: 'Category'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomChip(label: 'Work', isSelected: cubit.selectedCategory == 'Work', onTap: () => cubit.updateCategory('Work')),
                      const SizedBox(width: 8),
                      CustomChip(label: 'Personal', isSelected: cubit.selectedCategory == 'Personal', onTap: () => cubit.updateCategory('Personal')),
                      const SizedBox(width: 8),
                      CustomChip(label: 'Health', isSelected: cubit.selectedCategory == 'Health', onTap: () => cubit.updateCategory('Health')),
                    ],
                  ),
                  const SizedBox(height: 100), // Space for fixed button
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state is AddTaskLoading
                      ? null
                      : () {
                          if (_titleController.text.isNotEmpty) {
                            cubit.addTask(
                              title: _titleController.text,
                              description: _descController.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a task title')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: primary.withValues(alpha: 0.3),
                  ),
                  child: state is AddTaskLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Add Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: textGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
