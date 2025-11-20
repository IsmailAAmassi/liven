import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/webview_request_providers.dart';
import '../widgets/app_web_view.dart';

class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  static const routePath = '/main/home';
  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(homeWebRequestProvider);

    return AppWebView(
      request: requestAsync,
      onRequestRefresh: () => ref.refresh(homeWebRequestProvider.future),
    );
  }
}
