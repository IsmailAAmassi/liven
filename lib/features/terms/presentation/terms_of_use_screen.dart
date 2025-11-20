import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/network/api_result.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import 'providers/terms_providers.dart';

class TermsOfUseScreen extends ConsumerStatefulWidget {
  const TermsOfUseScreen({super.key});

  static const routePath = '/terms';
  static const routeName = 'terms';

  @override
  ConsumerState<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends ConsumerState<TermsOfUseScreen> {
  late final WebViewController _controller;
  String? _renderedContent;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final termsAsync = ref.watch(termsContentProvider);

    return Scaffold(
      appBar: AppPageAppBar(
        title: l10n.termsTitle,
        onBackPressed: () => context.go(MainScreen.routePath),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: termsAsync.when(
          data: (terms) {
            _renderIfNeeded(terms.htmlContent);
            return WebViewWidget(controller: _controller);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            final failure = error is ApiFailure ? error : null;
            final message = _mapFailure(l10n, failure);
            return _ErrorView(
              message: message,
              onRetry: () => ref.refresh(termsContentProvider),
            );
          },
        ),
      ),
    );
  }

  void _renderIfNeeded(String htmlContent) {
    if (_renderedContent == htmlContent) {
      return;
    }
    _renderedContent = htmlContent;
    _controller.loadHtmlString(htmlContent);
  }

  String _mapFailure(AppLocalizations l10n, ApiFailure? failure) {
    final key = failure?.messageKey;
    switch (key) {
      case 'terms_load_error':
        return l10n.terms_load_error;
      case 'error_bad_request':
        return l10n.error_bad_request;
      case 'error_unauthorized':
        return l10n.error_unauthorized;
      case 'error_not_found':
        return l10n.error_not_found;
      case 'error_validation':
        return l10n.error_validation;
      case 'error_server':
        return l10n.error_server;
      default:
        return l10n.terms_load_error;
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.terms_retry),
          ),
        ],
      ),
    );
  }
}
