import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr() : super('ar');

  @override
  String get appTitle => 'لايفن';
  @override
  String get generalSkip => 'تخطي';
  @override
  String get generalNext => 'التالي';
  @override
  String get generalGetStarted => 'ابدأ الآن';
  @override
  String get generalSettings => 'الإعدادات';
  @override
  String get navStatistics => 'الإحصائيات';
  @override
  String get navDailyRecords => 'السجلات اليومية';
  @override
  String get navHome => 'الرئيسية';
  @override
  String get navProfile => 'الملف الشخصي';
  @override
  String get navMore => 'المزيد';
  @override
  String get webviewErrorTitle => 'تعذّر تحميل المحتوى';
  @override
  String get webviewErrorMessage =>
      'لم نتمكن من تحميل تجربة ليفن عبر الويب. تأكد من اتصالك ثم أعد المحاولة.';
  @override
  String get webviewConfigError =>
      'عنوان الصفحة غير مهيأ. تأكد من قيمة ‎APP_WEB_APP_URL‎ في الإعدادات.';
  @override
  String get webviewSettingsError =>
      'تعذّر تحميل رابط الصفحة من الإعدادات. حدّث البيانات وحاول مجددًا.';
  @override
  String get webviewRetryButton => 'إعادة المحاولة';
  @override
  String get webviewErrorInlineMessage => 'تعذّر تحميل الصفحة الآن.';
  @override
  String get webviewPullToRefreshHint => 'اسحب للأسفل لتحديث الصفحة.';
  @override
  String get homeWelcomeTitle => 'مرحبًا 👋';
  @override
  String get homeWelcomeSubtitle =>
      'بدّل اللغة، غيّر المظهر، وتحكم بإعدادات الأمان من مكان واحد.';
  @override
  String get homeCardTitle => 'جاهز للانطلاق';
  @override
  String get homeCardDescription =>
      'ابدأ تجربتك فورًا أو خصصها بالوضع الداكن ودعم اللغة العربية.';
  @override
  String get homeOpenSettings => 'فتح الإعدادات';
  @override
  String get homeZoomCardTitle => 'اجتماعات عبر Zoom';
  @override
  String get homeZoomCardDescription =>
      'ابدأ جلسة Zoom Video SDK مباشرة من لايفن باستخدام بيانات الاعتماد الخاصة بمؤسستك.';
  @override
  String get homeZoomJoinButton => 'الانضمام إلى جلسة Zoom';
  @override
  String get homeZoomMissingConfig =>
      'يرجى تزويد التطبيق باسم الجلسة والرمز واسم المستخدم عبر ‎--dart-define‎ قبل الانضمام.';
  @override
  String get homeZoomError => 'تعذر فتح Zoom الآن. تحقق من الإعدادات وحاول مجددًا.';
  @override
  String get homeZoomInitError =>
      'خدمة Zoom غير متاحة على هذا الجهاز حاليًا. جرّب مرة أخرى على إصدار مدعوم.';
  @override
  String get homeFeedTitle => 'آخر التحديثات';
  @override
  String get homeFeedPlaceholderTitle => 'تحديث تجريبي';
  @override
  String get homeFeedPlaceholderSubtitle =>
      'سيتم إضافة المحتوى عند ربط التطبيق بالخادم.';
  @override
  String get statisticsTitle => 'الإحصائيات';
  @override
  String get statisticsOverview => 'نظرة عامة';
  @override
  String get statisticsSessionsLabel => 'الجلسات هذا الأسبوع';
  @override
  String get statisticsStreakLabel => 'سلسلة الاستمرار';
  @override
  String get statisticsCompletedLabel => 'الأهداف المكتملة';
  @override
  String get dailyRecordsTitle => 'السجلات اليومية';
  @override
  String get dailyRecordsSubtitle => 'تابع نشاطاتك وعاداتك يومًا بيوم.';
  @override
  String get dailyRecordsEmpty =>
      'لا توجد سجلات بعد. ابدأ بتوثيق تقدمك.';
  @override
  String get dailyRecordsSectionTitle => 'أحدث الإدخالات';
  @override
  String dailyRecordItemTitle(int day) => 'اليوم $day';
  @override
  String get dailyRecordItemSubtitle =>
      'أبرز الملاحظات والرؤى لهذا اليوم.';
  @override
  String get profileTitle => 'الملف الشخصي';
  @override
  String get profileSubtitle => 'حافظ على أمان حسابك وخصص تجربتك.';
  @override
  String get profileNameLabel => 'الاسم الكامل';
  @override
  String get profileEmailLabel => 'البريد الإلكتروني';
  @override
  String get profileStatusLabel => 'حالة الحساب';
  @override
  String get profileStatusGuest => 'وصول ضيف';
  @override
  String get profileStatusAuthenticated => 'عضو';
  @override
  String get profileEditAction => 'تعديل الملف';
  @override
  String get moreTitle => 'المزيد';
  @override
  String get moreAbout => 'حول التطبيق';
  @override
  String get moreAboutSubtitle => 'تعرّف على مهمة لايفن.';
  @override
  String get moreTerms => 'شروط الاستخدام';
  @override
  String get moreTermsSubtitle => 'اطلع على الشروط والسياسات.';
  @override
  String get moreProfile => 'الملف الشخصي';
  @override
  String get moreProfileSubtitle => 'راجع بياناتك الشخصية.';
  @override
  String get moreLanguage => 'اللغة';
  @override
  String get moreLanguageSubtitle => 'بدّل بين العربية والإنجليزية.';
  @override
  String get moreTheme => 'المظهر';
  @override
  String get moreThemeSubtitle => 'اختر طريقة عرض التطبيق.';
  @override
  String get moreLogout => 'تسجيل الخروج';
  @override
  String get moreLogoutSubtitle => 'تسجيل الخروج من هذا الجهاز.';
  @override
  String get morePermissions => 'الأذونات';
  @override
  String get morePermissionsSubtitle =>
      'إدارة الوصول للإشعارات والتخزين والكاميرا.';
  @override
  String get languageSelectorTitle => 'اختر اللغة';
  @override
  String get languageEnglish => 'الإنجليزية';
  @override
  String get languageArabic => 'العربية';
  @override
  String get themeSelectorTitle => 'اختر نمط المظهر';
  @override
  String get themeSystem => 'مطابق للنظام';
  @override
  String get themeLight => 'فاتح';
  @override
  String get themeDark => 'داكن';
  @override
  String get themeSystemDescription => 'مطابقة إعدادات الجهاز.';
  @override
  String get themeLightDescription => 'واجهة مشرقة للنهار.';
  @override
  String get themeDarkDescription => 'واجهة معتمة للمساء.';
  @override
  String get onboardingLanguageTitle => 'اختر لغتك المفضلة';
  @override
  String get onboardingLanguageSubtitle =>
      'استعمل العربية أو الإنجليزية في جميع أرجاء التطبيق.';
  @override
  String get onboardingThemeTitle => 'اختر نمط المظهر';
  @override
  String get onboardingThemeSubtitle =>
      'ضاعف راحتك بالوضع الفاتح أو الداكن أو باتباع إعدادات الجهاز.';
  @override
  String get onboardingPageOneTitle => 'اكتشف تجارب مخصصة';
  @override
  String get onboardingPageOneDescription =>
      'محتوى مصمم خصيصًا للجمهور العربي والإنجليزي.';
  @override
  String get onboardingPageTwoTitle => 'ابقَ متزامنًا في كل مكان';
  @override
  String get onboardingPageTwoDescription =>
      'ادخل إلى حسابك من أي جهاز مع مزامنة آمنة.';
  @override
  String get onboardingPageThreeTitle => 'تحكم في كل التفاصيل';
  @override
  String get onboardingPageThreeDescription =>
      'المظهر واللغة والخصوصية دائمًا على بعد نقرة واحدة.';
  @override
  String get loginTitle => 'مرحبًا بعودتك';
  @override
  String get loginSubtitle => 'سجّل دخولك لمواصلة رحلتك.';
  @override
  String get completeProfileTitle => 'أكمل ملفك الشخصي';
  @override
  String get completeProfilePlaceholder =>
      'أضف بياناتك للمتابعة. قادم قريبًا.';
  @override
  String get fieldPhone => 'رقم الجوال';
  @override
  String get fieldPassword => 'كلمة المرور';
  @override
  String get fieldFullName => 'الاسم الكامل';
  @override
  String get fieldEmail => 'البريد الإلكتروني';
  @override
  String get fieldConfirmPassword => 'تأكيد كلمة المرور';
  @override
  String get fieldNewPassword => 'كلمة المرور الجديدة';
  @override
  String get validationRequiredField => 'هذا الحقل مطلوب.';
  @override
  String get validationPhone => 'يرجى إدخال رقم الجوال.';
  @override
  String get validationEmail => 'أدخل بريدًا إلكترونيًا صالحًا.';
  @override
  String get validationPasswordLength =>
      'يجب ألا تقل كلمة المرور عن 6 أحرف.';
  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين.';
  @override
  String get loginButton => 'تسجيل الدخول';
  @override
  String get guestButton => 'التصفح كضيف';
  @override
  String get registerLink => 'إنشاء حساب';
  @override
  String get forgotPasswordLink => 'هل نسيت كلمة المرور؟';
  @override
  String get registerAppBar => 'إنشاء حساب';
  @override
  String get registerTitle => 'انضم إلى لايفن';
  @override
  String get registerTermsPrefix => 'بالتسجيل أنت توافق على ';
  @override
  String get registerTermsLink => 'شروط الاستخدام';
  @override
  String get registerButton => 'إنشاء حساب';
  @override
  String get registerLoginCta => 'لديك حساب بالفعل؟ سجّل الدخول';
  @override
  String get authRegisterSuccess => 'أهلاً بك في لايفن';
  @override
  String get authRegisterFailed =>
      'تعذر إنشاء الحساب، حاول مرة أخرى.';
  @override
  String get authErrorPhoneTaken => 'رقم الجوال مسجل بالفعل.';
  @override
  String get authErrorPasswordTooShort =>
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل.';
  @override
  String get forgotPasswordAppBar => 'نسيت كلمة المرور';
  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';
  @override
  String get sendOtpButton => 'إرسال الرمز';
  @override
  String get otpAppBar => 'أدخل رمز التحقق';
  @override
  String get otpEnterCodeMessage => 'أدخل رمز التحقق الذي وصلك.';
  @override
  String otpRegisterMessage(String identifier) =>
      'أرسلنا رمزًا إلى $identifier.';
  @override
  String otpResetMessage(String identifier) =>
      'تحقق من طلب إعادة التعيين لـ $identifier.';
  @override
  String get otpInvalid => 'رمز التحقق غير صحيح.';
  @override
  String get otpRequired => 'يرجى إدخال رمز التحقق.';
  @override
  String get otpSentMessage => 'تم إرسال رمز التحقق إلى هاتفك.';
  @override
  String get otpInvalidMobile => 'رقم الجوال غير صالح.';
  @override
  String get otpGenericError => 'تعذر التحقق من الرمز. حاول مرة أخرى.';
  @override
  String otpResendInXSeconds(int seconds) => 'إعادة الإرسال خلال ${seconds} ث';
  @override
  String get verifyButton => 'تحقق';
  @override
  String get resetPasswordAppBar => 'إعادة تعيين كلمة المرور';
  @override
  String get resetPasswordSuccessMessage => 'تم إعادة تعيين كلمة المرور بنجاح.';
  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';
  @override
  String get termsTitle => 'شروط الاستخدام';
  @override
  String get termsParagraphOne =>
      'باستخدامك لتطبيق لايفن فإنك توافق على احترام إرشادات المجتمع، وحماية معلوماتك الشخصية، وتجنب مشاركة أي بيانات حساسة في الأماكن العامة. هذه البنود مجرد نص مؤقت إلى أن يتم توفير الصياغة القانونية النهائية.';
  @override
  String get termsParagraphTwo =>
      'خصوصيتك وأمانك أولوية لدينا. يتم تخزين بيانات هذا الإصدار التجريبي على جهازك ولا يتم إرسالها إلى أي خادم خارجي.';
  @override
  String get aboutTitle => 'حول لايفن';
  @override
  String get aboutDescription =>
      'يساعدك لايفن على متابعة أهدافك اليومية بتصميم مدروس، ومحتوى ثنائي اللغة، وخيارات مظهر مرنة. كل شيء مجهز لتجربة onboarding سريعة وتنقل سلس.';
  @override
  String get aboutMissionTitle => 'مهمتنا';
  @override
  String get aboutMissionDescription =>
      'تمكين الجميع في المنطقة من إدارة روتينهم بأدوات تراعي الثقافة وتجارب تحترم الخصوصية.';
  @override
  String get settingsTitle => 'الإعدادات';
  @override
  String get settingsThemeLabel => 'المظهر';
  @override
  String get settingsLanguageLabel => 'اللغة';
  @override
  String get settingsTermsLabel => 'شروط الاستخدام';
  @override
  String get settingsLogoutLabel => 'تسجيل الخروج';
  @override
  String get logoutConfirmationTitle => 'تأكيد تسجيل الخروج';
  @override
  String get logoutConfirmationMessage =>
      'هل أنت متأكد من رغبتك في تسجيل الخروج؟';
  @override
  String get logoutConfirmationCancel => 'إلغاء';
  @override
  String get logoutConfirmationConfirm => 'تسجيل الخروج';
  @override
  String get mainBackToExitMessage => 'اضغط رجوع مرة أخرى للخروج';
  @override
  String get forgotPasswordDescription =>
      'أدخل رقم جوالك لاستلام رمز التحقق لإعادة تعيين كلمة المرور.';
  @override
  String get authLoginFailed => 'تعذر تسجيل الدخول، حاول مرة أخرى.';
  @override
  String get authInvalidCredentials => 'رقم الجوال أو كلمة المرور غير صحيحة.';
  @override
  String get errorInvalidRegistration =>
      'يرجى توفير بيانات تسجيل صحيحة.';
  @override
  String get errorIdentifierRequired => 'المعرف مطلوب.';
  @override
  String get errorInvalidResetData => 'بيانات إعادة التعيين غير صحيحة.';
  @override
  String get errorIncorrectOtp => 'رمز التحقق غير صحيح.';
  @override
  String get errorNetwork => 'خطأ في الشبكة، تحقق من الاتصال وحاول مجددًا.';
  @override
  String get settings_load_error =>
      'تعذر تحميل الإعدادات. يرجى المحاولة مرة أخرى.';
  @override
  String get terms_load_error =>
      'تعذر تحميل الشروط والأحكام. يرجى المحاولة مرة أخرى.';
  @override
  String get settings_retry => 'إعادة تحميل الإعدادات';
  @override
  String get terms_retry => 'إعادة تحميل الشروط';
  @override
  String get errorGeneric => 'حدث خطأ ما، الرجاء المحاولة مرة أخرى.';
  @override
  String get error_bad_request => 'طلب غير صالح، يرجى التحقق من البيانات والمحاولة مجددًا.';
  @override
  String get error_unauthorized => 'غير مصرح لك، يرجى تسجيل الدخول من جديد.';
  @override
  String get error_not_found => 'العنصر المطلوب غير موجود.';
  @override
  String get error_validation => 'يرجى مراجعة الحقول المطلوبة والمحاولة مرة أخرى.';
  @override
  String get error_server => 'خطأ في الخادم، حاول مرة أخرى لاحقًا.';
  @override
  String get error_unknown => 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا.';
  @override
  String get permissionsTitle => 'الأذونات';
  @override
  String get permissionsDescription =>
      'تحكم فيما يمكن لـ Liven الوصول إليه على جهازك.';
  @override
  String get permissionNotificationsName => 'الإشعارات';
  @override
  String get permissionStorageName => 'التخزين والصور';
  @override
  String get permissionCameraName => 'الكاميرا';
  @override
  String get permissionNotificationsDialogTitle => 'ابقَ على اطلاع';
  @override
  String get permissionNotificationsDialogDescription =>
      'اسمح بالإشعارات لتصلك التحديثات المهمة.';
  @override
  String get permissionStorageDialogTitle => 'حفظ ومشاركة الملفات';
  @override
  String get permissionStorageDialogDescription =>
      'اسمح بالوصول للتخزين حتى نتمكن من قراءة الوسائط وحفظها على جهازك.';
  @override
  String get permissionCameraDialogTitle => 'شارك صورتك';
  @override
  String get permissionCameraDialogDescription =>
      'اسمح للكاميرا بالعمل أثناء اجتماعات Zoom بالفيديو.';
  @override
  String get permissionNotificationsStatusDescription =>
      'مطلوبة للتنبيهات الفورية والمحلية.';
  @override
  String get permissionStorageStatusDescription =>
      'ضرورية لقراءة الصور والملفات وحفظها.';
  @override
  String get permissionCameraStatusDescription =>
      'ضرورية لاستخدام Zoom وميزات الكاميرا الأخرى.';
  @override
  String get permissionSettingsDialogTitle => 'التفعيل من الإعدادات';
  @override
  String permissionSettingsDialogDescription(String permission) =>
      'افتح إعدادات النظام واسمح لـ $permission للمتابعة.';
  @override
  String get permissionDeniedDialogTitle => 'نحتاج الإذن';
  @override
  String permissionDeniedDialogDescription(String permission) =>
      'الوصول إلى $permission ضروري للمتابعة. الرجاء السماح به.';
  @override
  String get permissionActionAllow => 'سماح';
  @override
  String get permissionActionNotNow => 'ليس الآن';
  @override
  String get permissionActionRetry => 'حاول مرة أخرى';
  @override
  String get permissionActionGoToSettings => 'افتح الإعدادات';
  @override
  String get permissionActionLater => 'لاحقًا';
  @override
  String get permissionActionRequest => 'طلب الإذن';
  @override
  String get permissionStatusAllowed => 'مسموح';
  @override
  String get permissionStatusDenied => 'مرفوض';
  @override
  String get permissionStatusRestricted => 'مقيّد';
  @override
  String get permissionStatusLimited => 'محدود';
  @override
  String get permissionStatusProvisional => 'مؤقت';
  @override
  String get permissionStatusPermanentlyDenied => 'مرفوض بشكل دائم';
  @override
  String get permissionStatusUnknown => 'غير معروف';
}
