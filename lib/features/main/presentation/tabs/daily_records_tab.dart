import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/webview_request_providers.dart';
import '../widgets/tab_web_view.dart';

class DailyRecordsScreen extends ConsumerWidget {
  const DailyRecordsScreen({super.key});

  static const routePath = '/main/records';
  static const routeName = 'records';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final requestAsync = ref.watch(dailyRecordsWebRequestProvider);

    return TabWebView(
      title: l10n.navDailyRecords,
      request: requestAsync,
      onRequestRefresh: () => ref.invalidate(dailyRecordsWebRequestProvider),
    );
  }
}
