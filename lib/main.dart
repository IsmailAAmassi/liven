import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_providers.dart';
import 'core/services/auth_storage.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/fcm_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FcmService.registerBackgroundHandler();
  final storage = await LocalStorageService.create();
  final authStorage = await AuthStorage.create();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(storage),
        authStorageProvider.overrideWithValue(authStorage),
      ],
      child: const App(),
    ),
  );
}
