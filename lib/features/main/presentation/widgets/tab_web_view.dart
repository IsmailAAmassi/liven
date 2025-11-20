import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/webview_request_providers.dart';

class TabWebView extends ConsumerStatefulWidget {
  const TabWebView({
    super.key,
    required this.title,
    required this.request,
    required this.onRequestRefresh,
  });

  final String title;
  final AsyncValue<TabWebRequest> request;
  final VoidCallback onRequestRefresh;

  @override
  ConsumerState<TabWebView> createState() => _TabWebViewState();
}

class _TabWebViewState extends ConsumerState<TabWebView> {
  late final WebViewController _controller;
  double _progress = 0;
  bool _isLoading = true;
  WebResourceError? _lastError;
  TabWebRequest? _currentRequest;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _lastError = null;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _lastError = error;
            });
          },
        ),
      );
  }

  bool _isSameRequest(TabWebRequest request) {
    final previous = _currentRequest;
    if (previous == null) {
      return false;
    }
    return previous.uri == request.uri && mapEquals(previous.headers, request.headers);
  }

  void _loadRequest(TabWebRequest request) {
    if (_isSameRequest(request)) {
      return;
    }
    _currentRequest = request;
    _controller.loadRequest(request.uri, headers: request.headers);
  }

  Future<void> _reloadCurrentRequest() async {
    setState(() {
      _lastError = null;
      _isLoading = true;
    });
    final request = _currentRequest;
    if (request != null) {
      await _controller.loadRequest(request.uri, headers: request.headers);
      return;
    }
    await _controller.reload();
  }

  Future<bool> _handleBackPressed() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requestAsync = widget.request;
    final canManuallyReload = requestAsync.hasValue || _currentRequest != null;

    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l10n.webviewRetryButton,
              onPressed: canManuallyReload ? _reloadCurrentRequest : null,
            ),
          ],
        ),
        body: SafeArea(
          child: requestAsync.when(
            data: (request) {
              _loadRequest(request);
              return Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: WebViewWidget(controller: _controller),
                    ),
                  ),
                  if (_lastError != null)
                    Positioned.fill(
                      child: _WebViewErrorView(
                        title: l10n.webviewErrorTitle,
                        message: l10n.webviewErrorMessage,
                        buttonLabel: l10n.webviewRetryButton,
                        onRetry: _reloadCurrentRequest,
                      ),
                    ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: _isLoading ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: LinearProgressIndicator(
                        value: _progress > 0 && _progress < 1 ? _progress : null,
                        minHeight: 3,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _WebViewErrorView(
              title: l10n.webviewErrorTitle,
              message: l10n.webviewSettingsError,
              buttonLabel: l10n.webviewRetryButton,
              onRetry: widget.onRequestRefresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _WebViewErrorView extends StatelessWidget {
  const _WebViewErrorView({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onRetry,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(buttonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
