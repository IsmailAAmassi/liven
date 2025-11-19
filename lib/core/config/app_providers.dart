import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls the selected [ThemeMode] across the app.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Controls the current [Locale] used for localization.
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
