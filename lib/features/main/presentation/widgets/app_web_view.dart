import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/webview_request_providers.dart';

class AppWebView extends ConsumerStatefulWidget {
  const AppWebView({
    super.key,
    required this.request,
    required this.onRequestRefresh,
  });

  final AsyncValue<TabWebRequest> request;
  final Future<void> Function() onRequestRefresh;

  @override
  ConsumerState<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends ConsumerState<AppWebView> {
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
            debugPrint(
              'WebView error (${_currentRequest?.uri}): ${error.description}',
            );
          },
        ),
      );
  }

  bool _isSameRequest(TabWebRequest request) {
    final previous = _currentRequest;
    if (previous == null) {
      return false;
    }
    return previous.uri == request.uri &&
        mapEquals(previous.headers, request.headers);
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

  Future<void> _handleRefresh() async {
    if (widget.request.hasError) {
      await widget.onRequestRefresh();
      return;
    }
    await _reloadCurrentRequest();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requestAsync = widget.request;

    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: _handleRefresh,
          edgeOffset: 8,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                      child: requestAsync.when(
                        data: (request) {
                          _loadRequest(request);
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ColoredBox(
                                color: Theme.of(context).colorScheme.surface,
                                child: WebViewWidget(controller: _controller),
                              ),
                              if (_lastError != null)
                                _WebViewErrorView(
                                  message: l10n.webviewErrorInlineMessage,
                                  hint: l10n.webviewPullToRefreshHint,
                                ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: AnimatedOpacity(
                                  opacity: _isLoading ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: LinearProgressIndicator(
                                    value: _progress > 0 && _progress < 1
                                        ? _progress
                                        : null,
                                    minHeight: 3,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => _WebViewErrorView(
                          message: l10n.webviewSettingsError,
                          hint: l10n.webviewPullToRefreshHint,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WebViewErrorView extends StatelessWidget {
  const _WebViewErrorView({required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
