import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/data/settings_repository.dart';
import '../../../settings/domain/models/terms_data.dart';

final termsContentProvider = FutureProvider<TermsData>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.fetchTerms();
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});
