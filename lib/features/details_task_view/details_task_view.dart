import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'package:project_mobile_application/core/models/sub_task_model.dart';
import 'package:project_mobile_application/features/details_task_view/cubit/details_task_cubit.dart';
import 'package:project_mobile_application/features/details_task_view/cubit/details_task_state.dart';
import 'package:project_mobile_application/features/details_task_view/widgets/info_card.dart';
import 'package:project_mobile_application/features/details_task_view/widgets/sub_task_tile.dart';

import 'package:project_mobile_application/core/utils/responsive_extension.dart';

class DetailsTaskView extends StatelessWidget {
  final TaskModel task;

  const DetailsTaskView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsTaskCubit(),
      child: BlocConsumer<DetailsTaskCubit, DetailsTaskState>(
        listener: (context, state) {
          if (state is DetailsTaskSuccess) {
            Navigator.pop(context, true); // Return true to refresh home
          } else if (state is DetailsTaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          if (!context.mounted) return const SizedBox();
          var cubit = context.read<DetailsTaskCubit>();

          int totalSubTasks = task.subTasks?.length ?? 0;
          int doneSubTasks = task.subTasks?.where((st) => st.isDone).length ?? 0;

          return Scaffold(
            backgroundColor: surface,
            body: Stack(
              children: [
                // ===== Purple Background =====
                Container(
                  height: context.height(40),
                  width: double.infinity,
                  color: primary,
                  padding: EdgeInsets.only(
                    top: context.height(6), 
                    left: context.width(6), 
                    right: context.width(6)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white, size: context.width(6)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Text(
                            'Task Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.width(5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, color: Colors.white, size: context.width(6)),
                            onPressed: () {
                              // TODO: Edit feature
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: context.height(3)),

                      // Tags
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${task.priority} • ${task.category}',
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                            fontSize: context.width(3.5),
                          ),
                        ),
                      ),
                      SizedBox(height: context.height(2)),

                      // Title
                      Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.width(7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== White Card Content =====
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & Time Cards
                        Row(
                          children: [
                            InfoCard(icon: Icons.calendar_today_outlined, title: 'Date', value: task.date, color: primary),
                            const SizedBox(width: 16),
                            InfoCard(icon: Icons.access_time, title: 'Time', value: task.time, color: primary),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            color: textGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: textDark,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sub-tasks
                        if (totalSubTasks > 0) ...[
                          Text(
                            'Sub-tasks ($doneSubTasks/$totalSubTasks)',
                            style: const TextStyle(
                              fontSize: 16,
                              color: textGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: totalSubTasks,
                              itemBuilder: (context, index) {
                                SubTaskModel subTask = task.subTasks![index];
                                return SubTaskTile(cubit: cubit, task: task, subTask: subTask, color: primary);
                              },
                            ),
                          ),
                        ] else ...[
                          const Spacer(),
                        ],

                        // Bottom Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: state is DetailsTaskLoading
                                    ? null
                                    : () => cubit.deleteTask(task),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: primary.withValues(alpha: 0.2)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: state is DetailsTaskLoading || task.isDone
                                    ? null
                                    : () => cubit.markAsComplete(task),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: state is DetailsTaskLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        'Mark Complete',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

