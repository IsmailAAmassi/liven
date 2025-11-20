import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'Liven';
  @override
  String get generalSkip => 'Skip';
  @override
  String get generalNext => 'Next';
  @override
  String get generalGetStarted => 'Get started';
  @override
  String get generalSettings => 'Settings';
  @override
  String get navStatistics => 'Statistics';
  @override
  String get navDailyRecords => 'Daily Records';
  @override
  String get navHome => 'Home';
  @override
  String get navProfile => 'Profile';
  @override
  String get navMore => 'More';
  @override
  String get webviewErrorTitle => "Can't load content";
  @override
  String get webviewErrorMessage =>
      "We couldn't load the Liven web experience. Check your connection and try again.";
  @override
  String get webviewConfigError =>
      "We're missing the home web URL. Verify APP_WEB_APP_URL in your environment.";
  @override
  String get webviewSettingsError =>
      "We couldn't load the page URL from settings. Refresh and try again.";
  @override
  String get webviewRetryButton => 'Try again';
  @override
  String get webviewErrorInlineMessage => 'Unable to load the page right now.';
  @override
  String get webviewPullToRefreshHint => 'Pull down to refresh the page.';
  @override
  String get homeWelcomeTitle => 'Hello there 👋';
  @override
  String get homeWelcomeSubtitle =>
      'Switch languages, toggle the theme, and manage security from settings.';
  @override
  String get homeCardTitle => 'Ready for action';
  @override
  String get homeCardDescription =>
      'Jump straight into the experience or customize it with dark mode and Arabic localization.';
  @override
  String get homeOpenSettings => 'Open settings';
  @override
  String get homeZoomCardTitle => 'Meet live on Zoom';
  @override
  String get homeZoomCardDescription =>
      'Launch the Zoom Video SDK experience directly from Liven using your organization credentials.';
  @override
  String get homeZoomJoinButton => 'Join Zoom session';
  @override
  String get homeZoomMissingConfig =>
      'Provide session name, token, and username via --dart-define or remote config before joining.';
  @override
  String get homeZoomError =>
      'Unable to open Zoom right now. Double-check your configuration and try again.';
  @override
  String get homeZoomInitError =>
      "Zoom calling isn't supported on this device yet. Please try again on a supported build.";
  @override
  String get homeFeedTitle => 'Latest updates';
  @override
  String get homeFeedPlaceholderTitle => 'Placeholder update';
  @override
  String get homeFeedPlaceholderSubtitle =>
      'Content will arrive once backend is connected.';
  @override
  String get statisticsTitle => 'Statistics';
  @override
  String get statisticsOverview => 'Overview';
  @override
  String get statisticsSessionsLabel => 'Sessions this week';
  @override
  String get statisticsStreakLabel => 'Current streak';
  @override
  String get statisticsCompletedLabel => 'Completed goals';
  @override
  String get dailyRecordsTitle => 'Daily records';
  @override
  String get dailyRecordsSubtitle =>
      'Track your activities and habits day by day.';
  @override
  String get dailyRecordsEmpty =>
      'No records yet. Start logging your progress.';
  @override
  String get dailyRecordsSectionTitle => 'Recent entries';
  @override
  String dailyRecordItemTitle(int day) => 'Day $day';
  @override
  String get dailyRecordItemSubtitle =>
      'Insights and notes collected for this day.';
  @override
  String get profileTitle => 'Profile';
  @override
  String get profileSubtitle =>
      'Keep your account secure and personalized.';
  @override
  String get profileNameLabel => 'Full name';
  @override
  String get profileEmailLabel => 'Email';
  @override
  String get profileStatusLabel => 'Account status';
  @override
  String get profileStatusGuest => 'Guest access';
  @override
  String get profileStatusAuthenticated => 'Member';
  @override
  String get profileEditAction => 'Edit profile';
  @override
  String get moreTitle => 'More';
  @override
  String get moreAbout => 'About';
  @override
  String get moreAboutSubtitle => "Learn about Liven's mission.";
  @override
  String get moreTerms => 'Terms of Use';
  @override
  String get moreTermsSubtitle => 'Read the terms and policies.';
  @override
  String get moreProfile => 'Profile';
  @override
  String get moreProfileSubtitle => 'Review your personal info.';
  @override
  String get moreLanguage => 'Language';
  @override
  String get moreLanguageSubtitle => 'Switch between Arabic and English.';
  @override
  String get moreTheme => 'Theme';
  @override
  String get moreThemeSubtitle => 'Choose how the app looks.';
  @override
  String get moreLogout => 'Logout';
  @override
  String get moreLogoutSubtitle => 'Sign out from this device.';
  @override
  String get morePermissions => 'Permissions';
  @override
  String get morePermissionsSubtitle =>
      'Manage notification, storage, and camera access.';
  @override
  String get languageSelectorTitle => 'Choose language';
  @override
  String get languageEnglish => 'English';
  @override
  String get languageArabic => 'العربية';
  @override
  String get themeSelectorTitle => 'Choose theme';
  @override
  String get themeSystem => 'System default';
  @override
  String get themeLight => 'Light';
  @override
  String get themeDark => 'Dark';
  @override
  String get themeSystemDescription => 'Match your device settings.';
  @override
  String get themeLightDescription => 'Bright interface for daylight.';
  @override
  String get themeDarkDescription => 'Dimmed interface for night.';
  @override
  String get onboardingLanguageTitle => 'Choose your language';
  @override
  String get onboardingLanguageSubtitle =>
      'Use English or Arabic across the entire experience.';
  @override
  String get onboardingThemeTitle => 'Choose your theme';
  @override
  String get onboardingThemeSubtitle =>
      'Light, dark, or follow your device preference.';
  @override
  String get onboardingPageOneTitle => 'Discover tailored experiences';
  @override
  String get onboardingPageOneDescription =>
      'Personalized content crafted for both Arabic and English audiences.';
  @override
  String get onboardingPageTwoTitle => 'Stay in sync everywhere';
  @override
  String get onboardingPageTwoDescription =>
      'Access your account on any device with secure cloud sync.';
  @override
  String get onboardingPageThreeTitle => 'Control every detail';
  @override
  String get onboardingPageThreeDescription =>
      'Themes, language, and privacy controls are always one tap away.';
  @override
  String get loginTitle => 'Welcome back';
  @override
  String get loginSubtitle => 'Sign in to continue your journey.';
  @override
  String get fieldEmailOrPhone => 'Email or phone';
  @override
  String get fieldPassword => 'Password';
  @override
  String get fieldFullName => 'Full name';
  @override
  String get fieldEmail => 'Email';
  @override
  String get fieldConfirmPassword => 'Confirm password';
  @override
  String get fieldNewPassword => 'New password';
  @override
  String get validationRequiredField => 'This field is required.';
  @override
  String get validationEmailOrPhone => 'Please enter your email or phone.';
  @override
  String get validationEmail => 'Enter a valid email.';
  @override
  String get validationPasswordLength =>
      'Password must be at least 6 characters.';
  @override
  String get validationPasswordsMismatch => 'Passwords do not match.';
  @override
  String get loginButton => 'Login';
  @override
  String get guestButton => 'Browse as guest';
  @override
  String get registerLink => 'Register';
  @override
  String get forgotPasswordLink => 'Forgot password?';
  @override
  String get registerAppBar => 'Create account';
  @override
  String get registerTitle => 'Join Liven';
  @override
  String get registerTermsPrefix => 'By signing up you agree to our ';
  @override
  String get registerTermsLink => 'Terms of Use';
  @override
  String get registerButton => 'Create account';
  @override
  String get registerLoginCta => 'Already have an account? Login';
  @override
  String get forgotPasswordAppBar => 'Forgot password';
  @override
  String get forgotPasswordTitle => 'Request reset link';
  @override
  String get sendOtpButton => 'Send OTP';
  @override
  String get otpAppBar => 'Enter OTP';
  @override
  String otpRegisterMessage(String identifier) =>
      'We have sent a code to $identifier.';
  @override
  String otpResetMessage(String identifier) =>
      'Verify your reset request for $identifier.';
  @override
  String get verifyButton => 'Verify';
  @override
  String get resetPasswordAppBar => 'Reset password';
  @override
  String get resetPasswordButton => 'Reset password';
  @override
  String get termsTitle => 'Terms of Use';
  @override
  String get termsParagraphOne =>
      'By using Liven you agree to respect our community guidelines, protect your personal information, and refrain from sharing sensitive data in public spaces. These terms are placeholders for the legal copy that will be provided later.';
  @override
  String get termsParagraphTwo =>
      'Your privacy and security are important to us. We keep all data on your device for this demo build and never send it to an external backend.';
  @override
  String get aboutTitle => 'About Liven';
  @override
  String get aboutDescription =>
      'Liven helps you stay connected to your daily goals with thoughtful design, bilingual content, and flexible theming. Everything is optimized for fast onboarding and effortless navigation.';
  @override
  String get aboutMissionTitle => 'Our mission';
  @override
  String get aboutMissionDescription =>
      'Empower people across the region to manage their routines with culturally aware tools and privacy-first experiences.';
  @override
  String get settingsTitle => 'Settings';
  @override
  String get settingsThemeLabel => 'Appearance';
  @override
  String get settingsLanguageLabel => 'Language';
  @override
  String get settingsTermsLabel => 'Terms of Use';
  @override
  String get settingsLogoutLabel => 'Logout';
  @override
  String get logoutConfirmationTitle => 'Confirm logout';
  @override
  String get logoutConfirmationMessage =>
      'Are you sure you want to logout?';
  @override
  String get logoutConfirmationCancel => 'Cancel';
  @override
  String get logoutConfirmationConfirm => 'Logout';
  @override
  String get mainBackToExitMessage => 'Press back again to exit';
  @override
  String get forgotPasswordDescription =>
      'Enter the identifier used on your account to receive a reset code.';
  @override
  String get errorInvalidCredentials => 'Please enter valid credentials.';
  @override
  String get errorInvalidRegistration =>
      'Please provide valid registration data.';
  @override
  String get errorIdentifierRequired => 'Identifier is required.';
  @override
  String get errorInvalidResetData => 'Invalid reset data.';
  @override
  String get errorIncorrectOtp => 'Incorrect OTP code.';
  @override
  String get settings_load_error =>
      'Could not load settings. Please try again.';
  @override
  String get terms_load_error =>
      'Could not load terms and conditions. Please try again.';
  @override
  String get settings_retry => 'Retry loading settings';
  @override
  String get terms_retry => 'Retry loading terms';
  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
  @override
  String get error_bad_request => 'Bad request. Please double-check your data and try again.';
  @override
  String get error_unauthorized => 'You are not authorized. Please login again.';
  @override
  String get error_not_found => 'Requested resource was not found.';
  @override
  String get error_validation => 'Please review the highlighted fields and try again.';
  @override
  String get error_server => 'Server error. Please try again later.';
  @override
  String get error_unknown => 'Unexpected error. Please try again.';
  @override
  String get permissionsTitle => 'Permissions';
  @override
  String get permissionsDescription =>
      'Control what Liven can access on your device.';
  @override
  String get permissionNotificationsName => 'Notifications';
  @override
  String get permissionStorageName => 'Storage & Photos';
  @override
  String get permissionCameraName => 'Camera';
  @override
  String get permissionNotificationsDialogTitle => 'Stay informed';
  @override
  String get permissionNotificationsDialogDescription =>
      'Allow notifications to get important reminders.';
  @override
  String get permissionStorageDialogTitle => 'Save and share files';
  @override
  String get permissionStorageDialogDescription =>
      'Grant storage access so we can read and save media on your device.';
  @override
  String get permissionCameraDialogTitle => 'Share your video';
  @override
  String get permissionCameraDialogDescription =>
      'Allow the camera to join Zoom meetings with live video.';
  @override
  String get permissionNotificationsStatusDescription =>
      'Required for push and local alerts.';
  @override
  String get permissionStorageStatusDescription =>
      'Needed to read and save photos or documents.';
  @override
  String get permissionCameraStatusDescription =>
      'Needed for Zoom and other camera features.';
  @override
  String get permissionSettingsDialogTitle => 'Enable from settings';
  @override
  String permissionSettingsDialogDescription(String permission) =>
      'Open system settings and allow $permission to continue.';
  @override
  String get permissionDeniedDialogTitle => 'Permission needed';
  @override
  String permissionDeniedDialogDescription(String permission) =>
      '$permission access is required to continue. Please allow the permission.';
  @override
  String get permissionActionAllow => 'Allow';
  @override
  String get permissionActionNotNow => 'Not now';
  @override
  String get permissionActionRetry => 'Try again';
  @override
  String get permissionActionGoToSettings => 'Open Settings';
  @override
  String get permissionActionLater => 'Later';
  @override
  String get permissionActionRequest => 'Request';
  @override
  String get permissionStatusAllowed => 'Allowed';
  @override
  String get permissionStatusDenied => 'Denied';
  @override
  String get permissionStatusRestricted => 'Restricted';
  @override
  String get permissionStatusLimited => 'Limited';
  @override
  String get permissionStatusProvisional => 'Provisional';
  @override
  String get permissionStatusPermanentlyDenied => 'Permanently denied';
  @override
  String get permissionStatusUnknown => 'Unknown';
}
