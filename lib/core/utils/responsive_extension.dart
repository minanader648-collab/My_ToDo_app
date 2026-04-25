import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Function to get proportional width
  double width(double percent) => screenWidth * (percent / 100);
  
  // Function to get proportional height
  double height(double percent) => screenHeight * (percent / 100);
}
