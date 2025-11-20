import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Provides a preconfigured [Logger] instance for application-wide logging.
///
/// Logging is enabled only in non-release modes to avoid leaking sensitive
/// information or incurring performance penalties in production builds.
final Logger appLogger = Logger(
  filter: _DevelopmentOnlyFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 80,
    colors: !kReleaseMode,
    printEmojis: true,
    printTime: true,
  ),
);

class _DevelopmentOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => !kReleaseMode;
}
