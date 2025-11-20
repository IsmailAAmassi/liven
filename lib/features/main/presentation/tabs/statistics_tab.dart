import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/webview_request_providers.dart';
import '../widgets/tab_web_view.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  static const routePath = '/main/statistics';
  static const routeName = 'statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final requestAsync = ref.watch(statisticsWebRequestProvider);

    return TabWebView(
      title: l10n.navStatistics,
      request: requestAsync,
      onRequestRefresh: () => ref.invalidate(statisticsWebRequestProvider),
    );
  }
}
