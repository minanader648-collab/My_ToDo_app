import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';

class CustomLabel extends StatelessWidget {
  final String text;

  const CustomLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: textGray,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
