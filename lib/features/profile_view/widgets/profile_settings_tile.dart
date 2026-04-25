import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLogout;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.withValues(alpha: 0.05) : surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon, 
          color: isLogout ? Colors.redAccent : primary
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
            color: isLogout ? Colors.redAccent : textDark,
          ),
        ),
        trailing: trailing ?? (isLogout ? null : const Icon(Icons.chevron_right, color: Colors.grey)),
      ),
    );
  }
}
