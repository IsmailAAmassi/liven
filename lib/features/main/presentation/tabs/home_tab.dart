import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/webview_request_providers.dart';
import '../widgets/tab_web_view.dart';

class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  static const routePath = '/main/home';
  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final requestAsync = ref.watch(homeWebRequestProvider);

    return TabWebView(
      title: l10n.navHome,
      request: requestAsync,
      onRequestRefresh: () => ref.invalidate(homeWebRequestProvider),
    );
  }
}
