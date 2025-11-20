import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/webview_request_providers.dart';
import '../widgets/app_web_view.dart';

class DailyRecordsScreen extends ConsumerWidget {
  const DailyRecordsScreen({super.key});

  static const routePath = '/main/records';
  static const routeName = 'records';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(dailyRecordsWebRequestProvider);

    return AppWebView(
      request: requestAsync,
      onRequestRefresh: () => ref.refresh(dailyRecordsWebRequestProvider.future),
    );
  }
}
