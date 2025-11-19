// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Starter App';

  @override
  String get homeGreeting => 'Hello';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get toggleTheme => 'Toggle theme';
}
