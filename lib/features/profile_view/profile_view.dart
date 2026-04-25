import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'package:project_mobile_application/features/login_view/login_view.dart';
import 'package:project_mobile_application/features/profile_view/widgets/profile_stat_card.dart';
import 'package:project_mobile_application/features/profile_view/widgets/profile_settings_tile.dart';
import 'package:project_mobile_application/features/profile_view/edit_profile_view.dart';
import 'package:project_mobile_application/core/utils/responsive_extension.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var sessionBox = Hive.box('sessionBox');
    var taskBox = Hive.box<TaskModel>('taskBox');

    String userName = sessionBox.get('userName', defaultValue: 'User');
    String userEmail = sessionBox.get('userEmail', defaultValue: 'user@email.com');

    int totalTasks = taskBox.length;
    int completedTasks = taskBox.values.where((t) => t.isDone).length;
    double completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== User Info Header (Scrollable) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // ===== Stats Cards (Equal Size) =====
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width(6), 
                vertical: context.height(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(title: 'Total\nTasks', value: totalTasks.toString(), color: primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ProfileStatCard(title: 'Completed', value: completedTasks.toString(), color: teal),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ProfileStatCard(title: 'Success\nRate', value: '${completionRate.toInt()}%', color: Colors.amber),
                  ),
                ],
              ),
            ),

            // ===== Settings List =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.width(6)),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileSettingsTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileView()),
                      );
                      if (result == true) {
                        setState(() {}); // Refresh data from Hive
                      }
                    },
                  ),
                  ProfileSettingsTile(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  ProfileSettingsTile(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Appearance',
                    trailing: Switch(
                      value: false,
                      onChanged: (v) {},
                      activeThumbColor: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileSettingsTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    isLogout: true,
                    onTap: () async {
                      var sBox = Hive.box('sessionBox');
                      await sBox.clear();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
