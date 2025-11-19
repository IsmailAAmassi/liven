import 'package:flutter/material.dart';

/// Defines reusable text styles aligned with the design system.
abstract class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.black54,
  );
}
