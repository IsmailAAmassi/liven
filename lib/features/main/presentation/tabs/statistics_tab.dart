import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/webview_request_providers.dart';
import '../widgets/app_web_view.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  static const routePath = '/main/statistics';
  static const routeName = 'statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(statisticsWebRequestProvider);

    return AppWebView(
      request: requestAsync,
      onRequestRefresh: () => ref.refresh(statisticsWebRequestProvider.future),
    );
  }
}
