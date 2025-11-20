import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings_repository.dart';
import '../../domain/models/settings_data.dart';

final settingsFutureProvider = FutureProvider<SettingsData>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.fetchSettings();
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});
