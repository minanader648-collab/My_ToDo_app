import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/features/home_view/cubit/home_cubit.dart';
import 'package:project_mobile_application/features/home_view/cubit/home_state.dart';
import 'package:project_mobile_application/features/add_task_view/add_task_view.dart';
import 'package:project_mobile_application/features/home_view/widgets/home_header.dart';
import 'package:project_mobile_application/features/home_view/widgets/stat_card.dart';
import 'package:project_mobile_application/features/home_view/widgets/task_card.dart';
import 'package:project_mobile_application/features/profile_view/profile_view.dart';

import 'package:project_mobile_application/core/utils/responsive_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadTasks(),
      child: Scaffold(
        backgroundColor: surface,
        body: SafeArea(
          child: Column(
            children: [
              // ===== Header =====
              const HomeHeader(),

              // ===== Body =====
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is! HomeSuccess) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      padding: EdgeInsets.all(context.width(6)),
                      children: [
                        // ===== Stats =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatCard(title: 'Total', count: state.total, color: primary),
                            StatCard(title: 'Active', count: state.active, color: teal),
                            StatCard(title: 'Done', count: state.done, color: success),
                          ],
                        ),
                        SizedBox(height: context.height(4)),

                        // ===== Tasks List =====
                        Text(
                          "Today's Tasks",
                          style: TextStyle(
                            fontSize: context.width(5.5),
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: context.height(2)),
                        ...state.tasks.map((task) => TaskCard(task: task)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // ===== Bottom Nav Bar =====
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskView()),
            );
            if (!context.mounted) return;
            if (result == true) {
              context.read<HomeCubit>().loadTasks();
            }
          },
          backgroundColor: primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.grid_view, color: primary),
                label: const Text('Home', style: TextStyle(color: primary)),
              ),
              const SizedBox(width: 48), // Space for FAB
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileView()),
                  );
                },
                icon: const Icon(Icons.person_outline, color: Colors.grey),
                label: const Text('Profile', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

