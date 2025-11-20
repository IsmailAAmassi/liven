import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  String get appTitle;
  String get generalSkip;
  String get generalNext;
  String get generalGetStarted;
  String get generalSettings;
  String get navStatistics;
  String get navDailyRecords;
  String get navHome;
  String get navProfile;
  String get navMore;
  String get webviewErrorTitle;
  String get webviewErrorMessage;
  String get webviewConfigError;
  String get webviewSettingsError;
  String get webviewRetryButton;
  String get homeWelcomeTitle;
  String get homeWelcomeSubtitle;
  String get homeCardTitle;
  String get homeCardDescription;
  String get homeOpenSettings;
  String get homeZoomCardTitle;
  String get homeZoomCardDescription;
  String get homeZoomJoinButton;
  String get homeZoomMissingConfig;
  String get homeZoomError;
  String get homeZoomInitError;
  String get homeFeedTitle;
  String get homeFeedPlaceholderTitle;
  String get homeFeedPlaceholderSubtitle;
  String get statisticsTitle;
  String get statisticsOverview;
  String get statisticsSessionsLabel;
  String get statisticsStreakLabel;
  String get statisticsCompletedLabel;
  String get dailyRecordsTitle;
  String get dailyRecordsSubtitle;
  String get dailyRecordsEmpty;
  String get dailyRecordsSectionTitle;
  String dailyRecordItemTitle(int day);
  String get dailyRecordItemSubtitle;
  String get profileTitle;
  String get profileSubtitle;
  String get profileNameLabel;
  String get profileEmailLabel;
  String get profileStatusLabel;
  String get profileStatusGuest;
  String get profileStatusAuthenticated;
  String get profileEditAction;
  String get moreTitle;
  String get moreAbout;
  String get moreAboutSubtitle;
  String get moreTerms;
  String get moreTermsSubtitle;
  String get moreProfile;
  String get moreProfileSubtitle;
  String get moreLanguage;
  String get moreLanguageSubtitle;
  String get moreTheme;
  String get moreThemeSubtitle;
  String get moreLogout;
  String get moreLogoutSubtitle;
  String get morePermissions;
  String get morePermissionsSubtitle;
  String get languageSelectorTitle;
  String get languageEnglish;
  String get languageArabic;
  String get themeSelectorTitle;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get themeSystemDescription;
  String get themeLightDescription;
  String get themeDarkDescription;
  String get onboardingLanguageTitle;
  String get onboardingLanguageSubtitle;
  String get onboardingThemeTitle;
  String get onboardingThemeSubtitle;
  String get onboardingPageOneTitle;
  String get onboardingPageOneDescription;
  String get onboardingPageTwoTitle;
  String get onboardingPageTwoDescription;
  String get onboardingPageThreeTitle;
  String get onboardingPageThreeDescription;
  String get loginTitle;
  String get loginSubtitle;
  String get fieldEmailOrPhone;
  String get fieldPassword;
  String get fieldFullName;
  String get fieldEmail;
  String get fieldConfirmPassword;
  String get fieldNewPassword;
  String get validationRequiredField;
  String get validationEmailOrPhone;
  String get validationEmail;
  String get validationPasswordLength;
  String get validationPasswordsMismatch;
  String get loginButton;
  String get guestButton;
  String get registerLink;
  String get forgotPasswordLink;
  String get registerAppBar;
  String get registerTitle;
  String get registerTermsPrefix;
  String get registerTermsLink;
  String get registerButton;
  String get registerLoginCta;
  String get forgotPasswordAppBar;
  String get forgotPasswordTitle;
  String get sendOtpButton;
  String get otpAppBar;
  String otpRegisterMessage(String identifier);
  String otpResetMessage(String identifier);
  String get verifyButton;
  String get resetPasswordAppBar;
  String get resetPasswordButton;
  String get termsTitle;
  String get termsParagraphOne;
  String get termsParagraphTwo;
  String get aboutTitle;
  String get aboutDescription;
  String get aboutMissionTitle;
  String get aboutMissionDescription;
  String get settingsTitle;
  String get settingsThemeLabel;
  String get settingsLanguageLabel;
  String get settingsTermsLabel;
  String get settingsLogoutLabel;
  String get logoutConfirmationTitle;
  String get logoutConfirmationMessage;
  String get logoutConfirmationCancel;
  String get logoutConfirmationConfirm;
  String get mainBackToExitMessage;
  String get forgotPasswordDescription;
  String get errorInvalidCredentials;
  String get errorInvalidRegistration;
  String get errorIdentifierRequired;
  String get errorInvalidResetData;
  String get errorIncorrectOtp;
  String get settings_load_error;
  String get terms_load_error;
  String get settings_retry;
  String get terms_retry;
  String get errorGeneric;
  String get error_bad_request;
  String get error_unauthorized;
  String get error_not_found;
  String get error_validation;
  String get error_server;
  String get error_unknown;
  String get permissionsTitle;
  String get permissionsDescription;
  String get permissionNotificationsName;
  String get permissionStorageName;
  String get permissionCameraName;
  String get permissionNotificationsDialogTitle;
  String get permissionNotificationsDialogDescription;
  String get permissionStorageDialogTitle;
  String get permissionStorageDialogDescription;
  String get permissionCameraDialogTitle;
  String get permissionCameraDialogDescription;
  String get permissionNotificationsStatusDescription;
  String get permissionStorageStatusDescription;
  String get permissionCameraStatusDescription;
  String get permissionSettingsDialogTitle;
  String permissionSettingsDialogDescription(String permission);
  String get permissionDeniedDialogTitle;
  String permissionDeniedDialogDescription(String permission);
  String get permissionActionAllow;
  String get permissionActionNotNow;
  String get permissionActionRetry;
  String get permissionActionGoToSettings;
  String get permissionActionLater;
  String get permissionActionRequest;
  String get permissionStatusAllowed;
  String get permissionStatusDenied;
  String get permissionStatusRestricted;
  String get permissionStatusLimited;
  String get permissionStatusProvisional;
  String get permissionStatusPermanentlyDenied;
  String get permissionStatusUnknown;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }
  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale".');
}
