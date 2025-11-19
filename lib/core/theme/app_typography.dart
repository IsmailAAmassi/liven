import 'package:flutter/material.dart';

abstract class AppTypography {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w500, height: 1.2),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, height: 1.25),
      headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, height: 1.28),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1.3),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, height: 1.5),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, height: 1.3),
    );
  }
}
