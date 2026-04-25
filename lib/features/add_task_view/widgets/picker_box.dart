import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';

class PickerBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const PickerBox({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: textDark),
          ),
        ],
      ),
    ),
   );
  }
}
