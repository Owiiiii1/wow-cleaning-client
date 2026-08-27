import 'package:flutter/widgets.dart';
import 'package:wow_cleaning/l10n/app_locales.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';

/// Lightweight app strings. Use [S.of] / [S.current].
class S {
  S._(this._code);

  final String _code;

  static S get current =>
      S._(AppLocales.codeOf(LocaleController.instance.locale));

  static S of(BuildContext context) => current;

  String _t(String key) => (_tables[_code] ?? _tables['en']!)[key] ??
      _tables['en']![key] ??
      key;

  // Common / menu
  String get menu => _t('menu');
  String get aboutApp => _t('aboutApp');
  String get settings => _t('settings');
  String get logout => _t('logout');
  String get language => _t('language');
  String get changeLanguage => _t('changeLanguage');
  String get selectLanguage => _t('selectLanguage');
  String get back => _t('back');
  String get versionLabel => _t('versionLabel');
  String get releaseDateLabel => _t('releaseDateLabel');
  String get releaseDateValue => _t('releaseDateValue');
  String get developedBy => _t('developedBy');
  String get openLinkFailed => _t('openLinkFailed');

  // Auth
  String get email => _t('email');
  String get password => _t('password');
  String get logIn => _t('logIn');
  String get signUp => _t('signUp');
  String get noAccount => _t('noAccount');
  String get createAccount => _t('createAccount');
  String get name => _t('name');
  String get phone => _t('phone');
  String get confirmPassword => _t('confirmPassword');
  String get createAccountBtn => _t('createAccountBtn');
  String get loginUnexpectedError => _t('loginUnexpectedError');
  String get invalidCredentials => _t('invalidCredentials');
  String get registerUnexpectedError => _t('registerUnexpectedError');

  // Home / nav
  String get home => _t('home');
  String get schedule => _t('schedule');
  String get chat => _t('chat');
  String get profile => _t('profile');
  String get accountStatus => _t('accountStatus');
  String get bitrixLinkStatus => _t('bitrixLinkStatus');
  String get bitrixContactId => _t('bitrixContactId');
  String get linkedClient => _t('linkedClient');
  String get noClientLinked => _t('noClientLinked');
  String get connectedToLaravel => _t('connectedToLaravel');
  String get activeOrders => _t('activeOrders');
  String get upcomingOrders => _t('upcomingOrders');
  String get recentOrders => _t('recentOrders');
  String get address => _t('address');
  String get cancel => _t('cancel');
  String get chatHint => _t('chatHint');
  String get chatLoadFailed => _t('chatLoadFailed');
  String get chatMessageDeleted => _t('chatMessageDeleted');
  String get chatEdited => _t('chatEdited');
  String get chatEditing => _t('chatEditing');
  String get chatEdit => _t('chatEdit');
  String get chatDelete => _t('chatDelete');
  String get chatNotLinked => _t('chatNotLinked');
  String get welcomeBack => _t('welcomeBack');
  String hiName(String name) => _t('hiName').replaceAll('{name}', name);
  String get hiGuest => _t('hiGuest');
  String get homeTagline => _t('homeTagline');
  String get bookNewCleaning => _t('bookNewCleaning');
  String get upcomingService => _t('upcomingService');
  String get serviceNotOrdered => _t('serviceNotOrdered');
  String specialistRushing(String name) =>
      _t('specialistRushing').replaceAll('{name}', name);
  String get specialistOnTheWayHint => _t('specialistOnTheWayHint');
  String get news => _t('news');
  String get newsEmpty => _t('newsEmpty');
  String get newsLoadFailed => _t('newsLoadFailed');
  String get homeLoadFailed => _t('homeLoadFailed');
  String get mySchedule => _t('mySchedule');
  String get scheduleSubtitle => _t('scheduleSubtitle');
  String get thisWeek => _t('thisWeek');
  String get futureCleanings => _t('futureCleanings');
  String get recurringCleanings => _t('recurringCleanings');
  String get scheduleRequests => _t('scheduleRequests');
  String get scheduleOrders => _t('scheduleOrders');
  String get subscribeCleaning => _t('subscribeCleaning');
  String get scheduleDatePending => _t('scheduleDatePending');
  String get scheduleStatusPending => _t('scheduleStatusPending');
  String get scheduleStatusScheduled => _t('scheduleStatusScheduled');
  String get scheduleStatusAccepted => _t('scheduleStatusAccepted');
  String get scheduleStatusOnTheWay => _t('scheduleStatusOnTheWay');
  String get scheduleStatusStarted => _t('scheduleStatusStarted');
  String get scheduleStatusFinished => _t('scheduleStatusFinished');
  String get scheduleStatusCancelled => _t('scheduleStatusCancelled');
  String get scheduleSectionEmpty => _t('scheduleSectionEmpty');
  String get scheduleLoadFailed => _t('scheduleLoadFailed');
  String get cleaningDetails => _t('cleaningDetails');
  String get orderLoadFailed => _t('orderLoadFailed');
  String get deleteRequest => _t('deleteRequest');
  String get deleteRequestTitle => _t('deleteRequestTitle');
  String get deleteRequestConfirm => _t('deleteRequestConfirm');
  String get deleteRequestFailed => _t('deleteRequestFailed');
  String get dateLabel => _t('dateLabel');
  String get timeLabel => _t('timeLabel');
  String get paymentStatusLabel => _t('paymentStatusLabel');
  String get typeLabel => _t('typeLabel');
  String get specialistLabel => _t('specialistLabel');
  String get durationLabel => _t('durationLabel');
  String get instructionsLabel => _t('instructionsLabel');
  String get propertyLabel => _t('propertyLabel');
  String get serviceLabel => _t('serviceLabel');
  String get addonsLabel => _t('addonsLabel');
  String get notesLabel => _t('notesLabel');
  String get priceLabel => _t('priceLabel');
  String get statusTimelineLabel => _t('statusTimelineLabel');
  String get orderVisit => _t('orderVisit');
  String get orderWindows => _t('orderWindows');
  String get moreDetails => _t('moreDetails');
  String get paymentPaid => _t('paymentPaid');
  String get paymentUnpaid => _t('paymentUnpaid');
  String get paymentPending => _t('paymentPending');
  String get paymentFailed => _t('paymentFailed');
  String get inboxTitle => _t('inboxTitle');
  String get inboxEmpty => _t('inboxEmpty');
  String get inboxLoadFailed => _t('inboxLoadFailed');
  String get inboxMessage => _t('inboxMessage');
  String get inboxNew => _t('inboxNew');
  String get inboxRead => _t('inboxRead');
  String get inboxMarkFailed => _t('inboxMarkFailed');
  String get inboxConfirm => _t('inboxConfirm');
  String get inboxDecline => _t('inboxDecline');
  String get inboxPostpone => _t('inboxPostpone');
  String get inboxActionFailed => _t('inboxActionFailed');
  String get orderFinishedTitle => _t('orderFinishedTitle');
  String get orderFinishedBody => _t('orderFinishedBody');
  String get ratingSubmitFailed => _t('ratingSubmitFailed');
  String get cleaningHistoryEmpty => _t('cleaningHistoryEmpty');
  String get cleaningHistoryLoadFailed => _t('cleaningHistoryLoadFailed');
  String get profileSettingsSection => _t('profileSettingsSection');
  String get supportSecuritySection => _t('supportSecuritySection');
  String get savedProperties => _t('savedProperties');
  String get cleaningHistory => _t('cleaningHistory');
  String get faq => _t('faq');
  String get addProperty => _t('addProperty');
  String get editProperty => _t('editProperty');
  String get fixProperty => _t('fixProperty');
  String get saveProperty => _t('saveProperty');
  String get propertiesEmpty => _t('propertiesEmpty');
  String get propertiesLoadFailed => _t('propertiesLoadFailed');
  String get propertyLoadFailed => _t('propertyLoadFailed');
  String get propertySaveFailed => _t('propertySaveFailed');
  String get propertyTitleRequired => _t('propertyTitleRequired');
  String get propertyHousingRequired => _t('propertyHousingRequired');
  String get propertyIncomplete => _t('propertyIncomplete');
  String get propertySquareFootage => _t('propertySquareFootage');
  String get propertySquareFootageHint => _t('propertySquareFootageHint');
  String get propertyBedrooms => _t('propertyBedrooms');
  String get propertyBathrooms => _t('propertyBathrooms');
  String get propertyTitle => _t('propertyTitle');
  String get propertyTitleHint => _t('propertyTitleHint');
  String get propertyMainPhoto => _t('propertyMainPhoto');
  String get propertyPickMainPhoto => _t('propertyPickMainPhoto');
  String get propertyAddress => _t('propertyAddress');
  String get propertyAddressHint => _t('propertyAddressHint');
  String get propertyDescription => _t('propertyDescription');
  String get propertyDescriptionHint => _t('propertyDescriptionHint');
  String get propertyAdditionalPhotos => _t('propertyAdditionalPhotos');
  String get propertyEntryInstructions => _t('propertyEntryInstructions');
  String get propertyEntryHint => _t('propertyEntryHint');
  String get next => _t('next');
  String get payNow => _t('payNow');
  String bookingStepOf(int current, int total) =>
      _t('bookingStepOf').replaceAll('{current}', '$current').replaceAll('{total}', '$total');
  String get bookingStepProperty => _t('bookingStepProperty');
  String get bookingStepService => _t('bookingStepService');
  String get bookingStepAddons => _t('bookingStepAddons');
  String get bookingAddonsTitle => _t('bookingAddonsTitle');
  String get bookingAddonsSubtitle => _t('bookingAddonsSubtitle');
  String get bookingAddonsNone => _t('bookingAddonsNone');
  String get bookingWindowsLabel => _t('bookingWindowsLabel');
  String get bookingWindowsHint => _t('bookingWindowsHint');
  String get bookingWindowsRequired => _t('bookingWindowsRequired');
  String get bookingEstimateTitle => _t('bookingEstimateTitle');
  String get bookingEstimateNote => _t('bookingEstimateNote');
  String get bookingEstimatePrice => _t('bookingEstimatePrice');
  String get bookingEstimateTime => _t('bookingEstimateTime');
  String get bookingEstimateFailed => _t('bookingEstimateFailed');
  String get bookingSummaryAddons => _t('bookingSummaryAddons');
  String bookingHoursValue(String hours) =>
      _t('bookingHoursValue').replaceAll('{hours}', hours);
  String get bookingStepSchedule => _t('bookingStepSchedule');
  String get bookingStepWishes => _t('bookingStepWishes');
  String get bookingStepPayment => _t('bookingStepPayment');
  String get bookingPropertyTitle => _t('bookingPropertyTitle');
  String get bookingPropertySubtitle => _t('bookingPropertySubtitle');
  String get bookingServiceTitle => _t('bookingServiceTitle');
  String get bookingServiceSubtitle => _t('bookingServiceSubtitle');
  String get bookingScheduleTitle => _t('bookingScheduleTitle');
  String get bookingScheduleSubtitle => _t('bookingScheduleSubtitle');
  String get bookingOneTime => _t('bookingOneTime');
  String get bookingRecurring => _t('bookingRecurring');
  String get bookingWeekly => _t('bookingWeekly');
  String get bookingBiweekly => _t('bookingBiweekly');
  String get bookingMonthly => _t('bookingMonthly');
  String get bookingDate => _t('bookingDate');
  String get bookingTime => _t('bookingTime');
  String get bookingPickDate => _t('bookingPickDate');
  String get bookingPickTime => _t('bookingPickTime');
  String get bookingScheduleDisclaimer => _t('bookingScheduleDisclaimer');
  String get bookingCheckAvailability => _t('bookingCheckAvailability');
  String get bookingNoSlots => _t('bookingNoSlots');
  String get bookingSelectSlot => _t('bookingSelectSlot');
  String get bookingPreferredStart => _t('bookingPreferredStart');
  String get bookingPreferredStartHint => _t('bookingPreferredStartHint');
  String get bookingAvailabilityFailed => _t('bookingAvailabilityFailed');
  String get bookingHoldFailed => _t('bookingHoldFailed');
  String get bookingHeld => _t('bookingHeld');
  String get bookingWishesTitle => _t('bookingWishesTitle');
  String get bookingWishesSubtitle => _t('bookingWishesSubtitle');
  String get bookingWishesHint => _t('bookingWishesHint');
  String get bookingPaymentTitle => _t('bookingPaymentTitle');
  String get bookingPaymentSubtitle => _t('bookingPaymentSubtitle');
  String get bookingSummaryProperty => _t('bookingSummaryProperty');
  String get bookingSummaryService => _t('bookingSummaryService');
  String get bookingSummarySchedule => _t('bookingSummarySchedule');
  String get bookingSummaryNotes => _t('bookingSummaryNotes');
  String get bookingSubmitFailed => _t('bookingSubmitFailed');
  String get servicesLoadFailed => _t('servicesLoadFailed');
  String get servicesEmpty => _t('servicesEmpty');
  String get bookingConfirmedTitle => _t('bookingConfirmedTitle');
  String get bookingConfirmedSubtitle => _t('bookingConfirmedSubtitle');
  String get viewBookingDetails => _t('viewBookingDetails');
  String get backToHome => _t('backToHome');
  String get sparkleGuaranteed => _t('sparkleGuaranteed');

  static const Map<String, Map<String, String>> _tables = {
    'en': {
      'menu': 'Menu',
      'aboutApp': 'About',
      'settings': 'Settings',
      'logout': 'Log out',
      'language': 'Language',
      'changeLanguage': 'Change language',
      'selectLanguage': 'Select language',
      'back': 'Back',
      'versionLabel': 'VERSION',
      'releaseDateLabel': 'RELEASE DATE',
      'releaseDateValue': 'July 2026',
      'developedBy': 'DEVELOPED BY: ',
      'openLinkFailed': 'Could not open the link',
      'email': 'Email',
      'password': 'Password',
      'logIn': 'LOG IN',
      'signUp': 'Sign Up',
      'noAccount': "Don't have an account? ",
      'createAccount': 'Create account',
      'name': 'Name',
      'phone': 'Phone',
      'confirmPassword': 'Confirm password',
      'createAccountBtn': 'CREATE ACCOUNT',
      'loginUnexpectedError': 'Unexpected error during login',
      'invalidCredentials': 'Incorrect email or password',
      'registerUnexpectedError': 'Unexpected error during registration',
      'home': 'Home',
      'schedule': 'Schedule',
      'chat': 'Chat',
      'profile': 'Profile',
      'accountStatus': 'Account status',
      'bitrixLinkStatus': 'Bitrix link status',
      'bitrixContactId': 'Bitrix Contact ID',
      'linkedClient': 'Linked client',
      'noClientLinked': 'No Bitrix client linked yet.',
      'connectedToLaravel': 'Connected to Laravel cache',
      'activeOrders': 'Active orders',
      'upcomingOrders': 'Upcoming orders',
      'recentOrders': 'Recent orders',
      'address': 'Address',
      'cancel': 'Cancel',
      'chatHint': 'Message…',
      'chatLoadFailed': 'Failed to load chat',
      'chatMessageDeleted': 'Message deleted',
      'chatEdited': 'edited',
      'chatEditing': 'Editing message',
      'chatEdit': 'Edit',
      'chatDelete': 'Delete',
      'chatNotLinked': 'Link your client account to use chat.',
      'welcomeBack': 'WELCOME BACK',
      'hiName': 'Hi, {name}!',
      'hiGuest': 'Hi!',
      'homeTagline': 'Your home is due for its next sparkle.',
      'bookNewCleaning': '+ Book New Cleaning',
      'upcomingService': 'UPCOMING SERVICE',
      'serviceNotOrdered': 'Service has not been ordered yet.',
      'specialistRushing': '{name} is already rushing to you',
      'specialistOnTheWayHint': 'Your cleaner is on the way',
      'news': 'NEWS',
      'newsEmpty': 'No news yet.',
      'newsLoadFailed': 'Failed to load news',
      'homeLoadFailed': 'Failed to refresh home',
      'mySchedule': 'My Schedule',
      'scheduleSubtitle': 'Manage your upcoming refreshing visits.',
      'thisWeek': 'THIS WEEK',
      'futureCleanings': 'FUTURE',
      'recurringCleanings': 'RECURRING',
      'scheduleRequests': 'REQUESTS',
      'scheduleOrders': 'ORDERS',
      'subscribeCleaning': 'Subscribe to cleaning',
      'scheduleDatePending': 'Date to confirm',
      'scheduleStatusPending': 'Awaiting confirmation',
      'scheduleStatusScheduled': 'Scheduled',
      'scheduleStatusAccepted': 'Accepted',
      'scheduleStatusOnTheWay': 'On the way',
      'scheduleStatusStarted': 'In progress',
      'scheduleStatusFinished': 'Finished',
      'scheduleStatusCancelled': 'Cancelled',
      'propertyLabel': 'Property',
      'serviceLabel': 'Service',
      'addonsLabel': 'Add-ons',
      'notesLabel': 'Notes',
      'priceLabel': 'Price',
      'scheduleSectionEmpty': 'Nothing here yet',
      'scheduleLoadFailed': 'Failed to load schedule',
      'cleaningDetails': 'Cleaning details',
      'orderLoadFailed': 'Failed to load cleaning',
      'deleteRequest': 'DELETE',
      'deleteRequestTitle': 'Delete request?',
      'deleteRequestConfirm':
          'This request will be deleted and the reserved time will become available again.',
      'deleteRequestFailed': 'Failed to delete the request',
      'dateLabel': 'Date',
      'timeLabel': 'Time',
      'paymentStatusLabel': 'Payment',
      'typeLabel': 'Type',
      'specialistLabel': 'Specialist',
      'durationLabel': 'Duration (h)',
      'instructionsLabel': 'Instructions',
      'statusTimelineLabel': 'Status timeline',
      'orderVisit': 'Visit',
      'orderWindows': 'Windows',
      'moreDetails': 'More details',
      'paymentPaid': 'Paid',
      'paymentUnpaid': 'Unpaid',
      'paymentPending': 'Payment pending',
      'paymentFailed': 'Payment failed',
      'inboxTitle': 'Messages',
      'inboxEmpty': 'No messages yet',
      'inboxLoadFailed': 'Failed to load messages',
      'inboxMessage': 'Message',
      'inboxNew': 'New',
      'inboxRead': "I've read it",
      'inboxMarkFailed': 'Could not mark the message as read',
      'inboxConfirm': 'Confirm',
      'inboxDecline': 'I do not confirm',
      'inboxPostpone': 'Postpone',
      'inboxActionFailed': 'Could not send the response',
      'orderFinishedTitle': 'ORDER COMPLETED SUCCESSFULLY',
      'orderFinishedBody': 'Please rate the cleaning',
      'ratingSubmitFailed': 'Could not save the rating',
      'profileSettingsSection': 'SETTINGS',
      'supportSecuritySection': 'SUPPORT & SECURITY',
      'savedProperties': 'Saved properties',
      'cleaningHistory': 'Cleaning history',
      'cleaningHistoryEmpty': 'No completed cleanings yet',
      'cleaningHistoryLoadFailed': 'Failed to load cleaning history',
      'faq': 'FAQ',
      'addProperty': 'Add property',
      'editProperty': 'Edit property',
      'fixProperty': 'Fix',
      'saveProperty': 'Save',
      'propertiesEmpty': 'No saved properties yet',
      'propertiesLoadFailed': 'Failed to load properties',
      'propertyLoadFailed': 'Failed to load property',
      'propertySaveFailed': 'Failed to save property',
      'propertyTitleRequired': 'Title is required',
      'propertyHousingRequired': 'Square footage, bedrooms and bathrooms are required',
      'propertyIncomplete': 'Missing square footage, bedrooms or bathrooms.',
      'propertySquareFootage': 'Square footage',
      'propertySquareFootageHint': 'Total sqft',
      'propertyBedrooms': 'Bedrooms',
      'propertyBathrooms': 'Bathrooms',
      'propertyTitle': 'Title',
      'propertyTitleHint': 'e.g. Home, Office',
      'propertyMainPhoto': 'Main photo',
      'propertyPickMainPhoto': 'Tap to add a photo',
      'propertyAddress': 'Address',
      'propertyAddressHint': 'Street, city',
      'propertyDescription': 'House description',
      'propertyDescriptionHint': 'Rooms, notes about the place',
      'propertyAdditionalPhotos': 'Additional photos',
      'propertyEntryInstructions': 'Entry instructions',
      'propertyEntryHint': 'Codes, keys, how to enter',
      'next': 'Next',
      'payNow': 'Pay',
      'bookingStepOf': 'STEP {current} OF {total}',
      'bookingStepProperty': 'Choose property',
      'bookingStepService': 'Choose service',
      'bookingStepAddons': 'Add-ons',
      'bookingAddonsTitle': 'Any extras?',
      'bookingAddonsSubtitle': 'You can select several add-ons or skip this step.',
      'bookingAddonsNone': 'None selected',
      'bookingWindowsLabel': 'How many windows?',
      'bookingWindowsHint': 'Number of windows',
      'bookingWindowsRequired': 'Enter the number of windows',
      'bookingEstimateTitle': 'Preliminary estimate',
      'bookingEstimateNote': 'This is a preliminary estimate. The final price and time may change after a manager reviews the order.',
      'bookingEstimatePrice': 'Estimated price',
      'bookingEstimateTime': 'Estimated time',
      'bookingEstimateFailed': 'Could not calculate the estimate',
      'bookingSummaryAddons': 'Add-ons',
      'bookingHoursValue': '{hours} h',
      'bookingStepSchedule': 'Schedule',
      'bookingStepWishes': 'Special wishes',
      'bookingStepPayment': 'Payment',
      'bookingPropertyTitle': 'Where should we clean?',
      'bookingPropertySubtitle': 'Select a saved property or add a new one.',
      'bookingServiceTitle': 'What needs a glow-up?',
      'bookingServiceSubtitle': 'Choose one main cleaning service.',
      'bookingScheduleTitle': 'When should we come?',
      'bookingScheduleSubtitle':
          'Pick a date, then check available time slots.',
      'bookingOneTime': 'One-time',
      'bookingRecurring': 'Recurring',
      'bookingWeekly': 'Weekly',
      'bookingBiweekly': 'Every 2 weeks',
      'bookingMonthly': 'Monthly',
      'bookingDate': 'Date',
      'bookingTime': 'Time',
      'bookingPickDate': 'Select date',
      'bookingPickTime': 'Select time',
      'bookingScheduleDisclaimer':
          'Date and time require confirmation with a manager. A manager will contact you to confirm.',
      'bookingCheckAvailability': 'Check availability',
      'bookingNoSlots': 'No free slots for this date',
      'bookingSelectSlot': 'Available slots',
      'bookingPreferredStart': 'Preferred start time',
      'bookingPreferredStartHint':
          'This window is longer than the job. Choose a start so the visit fits inside it.',
      'bookingAvailabilityFailed': 'Could not check availability',
      'bookingHoldFailed': 'Could not reserve this time. Try another slot.',
      'bookingHeld': 'Time reserved. Finish the booking to keep it.',
      'bookingWishesTitle': 'Any special wishes?',
      'bookingWishesSubtitle': 'Tell us instructions for the cleaning.',
      'bookingWishesHint': 'e.g. focus on kitchen, leave keys under the mat…',
      'bookingPaymentTitle': 'Review & pay',
      'bookingPaymentSubtitle': 'Check your booking details before payment.',
      'bookingSummaryProperty': 'Property',
      'bookingSummaryService': 'Service',
      'bookingSummarySchedule': 'Schedule type',
      'bookingSummaryNotes': 'Special wishes',
      'bookingSubmitFailed': 'Failed to create booking request',
      'servicesLoadFailed': 'Failed to load services',
      'servicesEmpty': 'No services available yet',
      'bookingConfirmedTitle': 'Booking Confirmed!',
      'bookingConfirmedSubtitle': 'Benjamin is getting your team ready.',
      'viewBookingDetails': 'VIEW BOOKING DETAILS',
      'backToHome': 'BACK TO HOME',
      'sparkleGuaranteed': 'SPARKLE GUARANTEED',
    },
    'uk': {
      'menu': 'Меню',
      'aboutApp': 'Про додаток',
      'settings': 'Налаштування',
      'logout': 'Вийти',
      'language': 'Мова',
      'changeLanguage': 'Зміна мови',
      'selectLanguage': 'Оберіть мову',
      'back': 'Назад',
      'versionLabel': 'ВЕРСІЯ',
      'releaseDateLabel': 'ДАТА ВИПУСКУ',
      'releaseDateValue': 'липень 2026 р.',
      'developedBy': 'РОЗРОБЛЕНО: ',
      'openLinkFailed': 'Не вдалося відкрити посилання',
      'email': 'Email',
      'password': 'Пароль',
      'logIn': 'УВІЙТИ',
      'signUp': 'Зареєструватися',
      'noAccount': 'Немає акаунта? ',
      'createAccount': 'Створити акаунт',
      'name': "Ім'я",
      'phone': 'Телефон',
      'confirmPassword': 'Підтвердіть пароль',
      'createAccountBtn': 'СТВОРИТИ АКАУНТ',
      'loginUnexpectedError': 'Неочікувана помилка під час входу',
      'invalidCredentials': 'Невірний email або пароль',
      'registerUnexpectedError': 'Неочікувана помилка під час реєстрації',
      'home': 'Головна',
      'schedule': 'Розклад',
      'chat': 'Чат',
      'profile': 'Профіль',
      'accountStatus': 'Статус акаунта',
      'bitrixLinkStatus': 'Статус звʼязку Bitrix',
      'bitrixContactId': 'Bitrix Contact ID',
      'linkedClient': 'Повʼязаний клієнт',
      'noClientLinked': 'Клієнта Bitrix ще не повʼязано.',
      'connectedToLaravel': 'Підключено до кешу Laravel',
      'activeOrders': 'Активні замовлення',
      'upcomingOrders': 'Найближчі замовлення',
      'recentOrders': 'Останні замовлення',
      'address': 'Адреса',
      'cancel': 'Скасувати',
      'chatHint': 'Повідомлення…',
      'chatLoadFailed': 'Не вдалося завантажити чат',
      'chatMessageDeleted': 'Повідомлення видалено',
      'chatEdited': 'змінено',
      'chatEditing': 'Редагування повідомлення',
      'chatEdit': 'Редагувати',
      'chatDelete': 'Видалити',
      'chatNotLinked': 'Привʼяжіть клієнтський акаунт, щоб користуватися чатом.',
      'welcomeBack': 'З ПОВЕРНЕННЯМ',
      'hiName': 'Привіт, {name}!',
      'hiGuest': 'Привіт!',
      'homeTagline': 'Час для наступного блиску вашого дому.',
      'bookNewCleaning': '+ Замовити клінінг',
      'upcomingService': 'НАЙБЛИЖЧИЙ СЕРВІС',
      'serviceNotOrdered': 'Сервіс ще не замовлено.',
      'specialistRushing': '{name} вже поспішає до вас',
      'specialistOnTheWayHint': 'Ваш клінер у дорозі',
      'news': 'НОВИНИ',
      'newsEmpty': 'Новин ще немає.',
      'newsLoadFailed': 'Не вдалося завантажити новину',
      'homeLoadFailed': 'Не вдалося оновити головну',
      'mySchedule': 'Мій розклад',
      'scheduleSubtitle': 'Керуйте найближчими візитами.',
      'thisWeek': 'ЦЕЙ ТИЖДЕНЬ',
      'futureCleanings': 'МАЙБУТНІ',
      'recurringCleanings': 'ПЕРІОДИЧНІ',
      'scheduleRequests': 'ЗАЯВКИ',
      'scheduleOrders': 'ЗАМОВЛЕННЯ',
      'subscribeCleaning': 'Підписатися на прибирання',
      'scheduleDatePending': 'Дату підтвердять',
      'scheduleStatusPending': 'Очікує підтвердження',
      'scheduleStatusScheduled': 'Заплановано',
      'scheduleStatusAccepted': 'Прийнято',
      'scheduleStatusOnTheWay': 'В дорозі',
      'scheduleStatusStarted': 'Триває',
      'scheduleStatusFinished': 'Завершено',
      'scheduleStatusCancelled': 'Скасовано',
      'propertyLabel': 'Обʼєкт',
      'serviceLabel': 'Послуга',
      'addonsLabel': 'Додатки',
      'notesLabel': 'Побажання',
      'priceLabel': 'Ціна',
      'scheduleSectionEmpty': 'Поки порожньо',
      'scheduleLoadFailed': 'Не вдалося завантажити розклад',
      'cleaningDetails': 'Деталі прибирання',
      'orderLoadFailed': 'Не вдалося завантажити прибирання',
      'deleteRequest': 'ВИДАЛИТИ',
      'deleteRequestTitle': 'Видалити заявку?',
      'deleteRequestConfirm':
          'Заявку буде видалено, а зарезервований час знову стане вільним.',
      'deleteRequestFailed': 'Не вдалося видалити заявку',
      'dateLabel': 'Дата',
      'timeLabel': 'Час',
      'paymentStatusLabel': 'Оплата',
      'typeLabel': 'Тип',
      'specialistLabel': 'Спеціаліст',
      'durationLabel': 'Тривалість (год)',
      'instructionsLabel': 'Інструкції',
      'statusTimelineLabel': 'Історія статусів',
      'orderVisit': 'Візит',
      'orderWindows': 'Вікна',
      'moreDetails': 'Докладніше',
      'paymentPaid': 'Оплачено',
      'paymentUnpaid': 'Не оплачено',
      'paymentPending': 'Очікує оплати',
      'paymentFailed': 'Помилка оплати',
      'inboxTitle': 'Повідомлення',
      'inboxEmpty': 'Повідомлень ще немає',
      'inboxLoadFailed': 'Не вдалося завантажити повідомлення',
      'inboxMessage': 'Повідомлення',
      'inboxNew': 'Нове',
      'inboxRead': 'Прочитав',
      'inboxMarkFailed': 'Не вдалося позначити повідомлення прочитаним',
      'inboxConfirm': 'Підтверджую',
      'inboxDecline': 'Не підтверджую',
      'inboxPostpone': 'Відкласти',
      'inboxActionFailed': 'Не вдалося надіслати відповідь',
      'orderFinishedTitle': 'ЗАМОВЛЕННЯ УСПІШНО ВИКОНАНО',
      'orderFinishedBody': 'Будь ласка, оцініть прибирання',
      'ratingSubmitFailed': 'Не вдалося зберегти оцінку',
      'profileSettingsSection': 'НАЛАШТУВАННЯ',
      'supportSecuritySection': 'ПІДТРИМКА ТА БЕЗПЕКА',
      'savedProperties': 'Збережені обʼєкти',
      'cleaningHistory': 'Історія прибирань',
      'cleaningHistoryEmpty': 'Завершених прибирань ще немає',
      'cleaningHistoryLoadFailed': 'Не вдалося завантажити історію',
      'faq': 'FAQ',
      'addProperty': 'Додати обʼєкт',
      'editProperty': 'Редагувати обʼєкт',
      'fixProperty': 'Виправити',
      'saveProperty': 'Зберегти',
      'propertiesEmpty': 'Поки немає збережених обʼєктів',
      'propertiesLoadFailed': 'Не вдалося завантажити обʼєкти',
      'propertyLoadFailed': 'Не вдалося завантажити обʼєкт',
      'propertySaveFailed': 'Не вдалося зберегти обʼєкт',
      'propertyTitleRequired': 'Вкажіть назву',
      'propertyHousingRequired': 'Вкажіть метраж, кількість спалень і ванних',
      'propertyIncomplete': 'Немає метражу, спалень або ванних.',
      'propertySquareFootage': 'Метраж (sqft)',
      'propertySquareFootageHint': 'Загальна площа',
      'propertyBedrooms': 'Спальні',
      'propertyBathrooms': 'Ванні',
      'propertyTitle': 'Назва',
      'propertyTitleHint': 'напр. Дім, Офіс',
      'propertyMainPhoto': 'Головне фото',
      'propertyPickMainPhoto': 'Натисніть, щоб додати фото',
      'propertyAddress': 'Адреса',
      'propertyAddressHint': 'Вулиця, місто',
      'propertyDescription': 'Опис будинку',
      'propertyDescriptionHint': 'Кімнати, нотатки про місце',
      'propertyAdditionalPhotos': 'Додаткові фото',
      'propertyEntryInstructions': 'Інструкції для входу',
      'propertyEntryHint': 'Коди, ключі, як увійти',
      'next': 'Далі',
      'payNow': 'Оплатити',
      'bookingStepOf': 'КРОК {current} З {total}',
      'bookingStepProperty': 'Обʼєкт уборки',
      'bookingStepService': 'Тип уборки',
      'bookingStepAddons': 'Доп. послуги',
      'bookingAddonsTitle': 'Потрібні допи?',
      'bookingAddonsSubtitle': 'Можна обрати кілька послуг або пропустити крок.',
      'bookingAddonsNone': 'Не обрано',
      'bookingWindowsLabel': 'Скільки вікон?',
      'bookingWindowsHint': 'Кількість вікон',
      'bookingWindowsRequired': 'Вкажіть кількість вікон',
      'bookingEstimateTitle': 'Попередній розрахунок',
      'bookingEstimateNote': 'Це попередній розрахунок. Фінальні ціна і час можуть змінитися після перевірки менеджером.',
      'bookingEstimatePrice': 'Орієнтовна ціна',
      'bookingEstimateTime': 'Орієнтовний час',
      'bookingEstimateFailed': 'Не вдалося розрахувати кошторис',
      'bookingSummaryAddons': 'Доп. послуги',
      'bookingHoursValue': '{hours} год',
      'bookingStepSchedule': 'Розклад',
      'bookingStepWishes': 'Побажання',
      'bookingStepPayment': 'Оплата',
      'bookingPropertyTitle': 'Де прибирати?',
      'bookingPropertySubtitle': 'Оберіть збережений обʼєкт або додайте новий.',
      'bookingServiceTitle': 'Яка уборка потрібна?',
      'bookingServiceSubtitle': 'Оберіть одну основну послугу.',
      'bookingScheduleTitle': 'Коли приїхати?',
      'bookingScheduleSubtitle':
          'Оберіть дату, потім перевірте вільні слоти.',
      'bookingOneTime': 'Разова',
      'bookingRecurring': 'Періодична',
      'bookingWeekly': 'Щотижня',
      'bookingBiweekly': 'Кожні 2 тижні',
      'bookingMonthly': 'Щомісяця',
      'bookingDate': 'Дата',
      'bookingTime': 'Час',
      'bookingPickDate': 'Оберіть дату',
      'bookingPickTime': 'Оберіть час',
      'bookingScheduleDisclaimer':
          'Дата і час потребують узгодження з менеджером. Менеджер звʼяжеться з вами для підтвердження.',
      'bookingCheckAvailability': 'Перевірити доступність',
      'bookingNoSlots': 'На цю дату немає вільних слотів',
      'bookingSelectSlot': 'Вільні слоти',
      'bookingPreferredStart': 'Бажаний час початку',
      'bookingPreferredStartHint':
          'Вільне вікно довше за тривалість уборки. Оберіть старт так, щоб візит вмістився в нього.',
      'bookingAvailabilityFailed': 'Не вдалося перевірити доступність',
      'bookingHoldFailed': 'Не вдалося зарезервувати час. Спробуйте інший слот.',
      'bookingHeld': 'Час зарезервовано. Завершіть заявку, щоб залишити його.',
      'bookingWishesTitle': 'Особливі побажання?',
      'bookingWishesSubtitle': 'Вкажіть інструкції до прибирання.',
      'bookingWishesHint': 'напр. більше уваги кухні, ключі під килимком…',
      'bookingPaymentTitle': 'Перевірка та оплата',
      'bookingPaymentSubtitle': 'Перевірте дані перед оплатою.',
      'bookingSummaryProperty': 'Обʼєкт',
      'bookingSummaryService': 'Послуга',
      'bookingSummarySchedule': 'Тип розкладу',
      'bookingSummaryNotes': 'Побажання',
      'bookingSubmitFailed': 'Не вдалося створити запит',
      'servicesLoadFailed': 'Не вдалося завантажити послуги',
      'servicesEmpty': 'Послуг поки немає',
      'bookingConfirmedTitle': 'Бронювання підтверджено!',
      'bookingConfirmedSubtitle': 'Benjamin готує вашу команду.',
      'viewBookingDetails': 'ДЕТАЛІ БРОНЮВАННЯ',
      'backToHome': 'НА ГОЛОВНУ',
      'sparkleGuaranteed': 'SPARKLE GUARANTEED',
    },
    'es_US': {
      'menu': 'Menú',
      'aboutApp': 'Acerca de',
      'settings': 'Configuración',
      'logout': 'Cerrar sesión',
      'language': 'Idioma',
      'changeLanguage': 'Cambiar idioma',
      'selectLanguage': 'Seleccionar idioma',
      'back': 'Atrás',
      'versionLabel': 'VERSIÓN',
      'releaseDateLabel': 'FECHA DE LANZAMIENTO',
      'releaseDateValue': 'julio de 2026',
      'developedBy': 'DESARROLLADO: ',
      'openLinkFailed': 'No se pudo abrir el enlace',
      'email': 'Correo',
      'password': 'Contraseña',
      'logIn': 'INICIAR SESIÓN',
      'signUp': 'Regístrate',
      'noAccount': '¿No tienes una cuenta? ',
      'createAccount': 'Crear cuenta',
      'name': 'Nombre',
      'phone': 'Teléfono',
      'confirmPassword': 'Confirmar contraseña',
      'createAccountBtn': 'CREAR CUENTA',
      'loginUnexpectedError': 'Error inesperado al iniciar sesión',
      'invalidCredentials': 'Correo o contraseña incorrectos',
      'registerUnexpectedError': 'Error inesperado al registrarse',
      'home': 'Inicio',
      'schedule': 'Horario',
      'chat': 'Chat',
      'profile': 'Perfil',
      'accountStatus': 'Estado de la cuenta',
      'bitrixLinkStatus': 'Estado de enlace Bitrix',
      'bitrixContactId': 'ID de contacto Bitrix',
      'linkedClient': 'Cliente vinculado',
      'noClientLinked': 'Aún no hay cliente de Bitrix vinculado.',
      'connectedToLaravel': 'Conectado al caché de Laravel',
      'activeOrders': 'Pedidos activos',
      'upcomingOrders': 'Próximos pedidos',
      'recentOrders': 'Pedidos recientes',
      'address': 'Dirección',
      'cancel': 'Cancelar',
      'chatHint': 'Mensaje…',
      'chatLoadFailed': 'No se pudo cargar el chat',
      'chatMessageDeleted': 'Mensaje eliminado',
      'chatEdited': 'editado',
      'chatEditing': 'Editando mensaje',
      'chatEdit': 'Editar',
      'chatDelete': 'Eliminar',
      'chatNotLinked': 'Vincula tu cuenta de cliente para usar el chat.',
      'welcomeBack': 'BIENVENIDO',
      'hiName': 'Hola, {name}!',
      'hiGuest': 'Hola!',
      'homeTagline': 'Tu hogar espera su próximo brillo.',
      'bookNewCleaning': '+ Reservar limpieza',
      'upcomingService': 'PRÓXIMO SERVICIO',
      'serviceNotOrdered': 'Aún no has pedido un servicio.',
      'specialistRushing': '{name} ya va hacia ti',
      'specialistOnTheWayHint': 'Tu limpiador está en camino',
      'news': 'NOTICIAS',
      'newsEmpty': 'Aún no hay noticias.',
      'newsLoadFailed': 'No se pudo cargar la noticia',
      'homeLoadFailed': 'No se pudo actualizar el inicio',
      'mySchedule': 'Mi horario',
      'scheduleSubtitle': 'Gestiona tus próximas visitas.',
      'thisWeek': 'ESTA SEMANA',
      'futureCleanings': 'FUTURAS',
      'recurringCleanings': 'PERIÓDICAS',
      'scheduleRequests': 'SOLICITUDES',
      'scheduleOrders': 'PEDIDOS',
      'subscribeCleaning': 'Suscribirse a la limpieza',
      'scheduleDatePending': 'Fecha por confirmar',
      'scheduleStatusPending': 'Pendiente de confirmación',
      'scheduleStatusScheduled': 'Programada',
      'scheduleStatusAccepted': 'Aceptada',
      'scheduleStatusOnTheWay': 'En camino',
      'scheduleStatusStarted': 'En curso',
      'scheduleStatusFinished': 'Finalizada',
      'scheduleStatusCancelled': 'Cancelada',
      'propertyLabel': 'Propiedad',
      'serviceLabel': 'Servicio',
      'addonsLabel': 'Extras',
      'notesLabel': 'Notas',
      'priceLabel': 'Precio',
      'scheduleSectionEmpty': 'Aún vacío',
      'scheduleLoadFailed': 'No se pudo cargar el horario',
      'cleaningDetails': 'Detalles de la limpieza',
      'orderLoadFailed': 'No se pudo cargar la limpieza',
      'deleteRequest': 'ELIMINAR',
      'deleteRequestTitle': '¿Eliminar solicitud?',
      'deleteRequestConfirm':
          'La solicitud se eliminará y el horario reservado volverá a estar disponible.',
      'deleteRequestFailed': 'No se pudo eliminar la solicitud',
      'dateLabel': 'Fecha',
      'timeLabel': 'Hora',
      'paymentStatusLabel': 'Pago',
      'typeLabel': 'Tipo',
      'specialistLabel': 'Especialista',
      'durationLabel': 'Duración (h)',
      'instructionsLabel': 'Instrucciones',
      'statusTimelineLabel': 'Historial de estados',
      'orderVisit': 'Visita',
      'orderWindows': 'Ventanas',
      'moreDetails': 'Más detalles',
      'paymentPaid': 'Pagado',
      'paymentUnpaid': 'Sin pagar',
      'paymentPending': 'Pago pendiente',
      'paymentFailed': 'Pago fallido',
      'inboxTitle': 'Mensajes',
      'inboxEmpty': 'Aún no hay mensajes',
      'inboxLoadFailed': 'No se pudieron cargar los mensajes',
      'inboxMessage': 'Mensaje',
      'inboxNew': 'Nuevo',
      'inboxRead': 'Ya lo leí',
      'inboxMarkFailed': 'No se pudo marcar el mensaje como leído',
      'inboxConfirm': 'Confirmo',
      'inboxDecline': 'No confirmo',
      'inboxPostpone': 'Posponer',
      'inboxActionFailed': 'No se pudo enviar la respuesta',
      'orderFinishedTitle': 'PEDIDO COMPLETADO CON ÉXITO',
      'orderFinishedBody': 'Por favor, valora la limpieza',
      'ratingSubmitFailed': 'No se pudo guardar la valoración',
      'profileSettingsSection': 'AJUSTES',
      'supportSecuritySection': 'SOPORTE Y SEGURIDAD',
      'savedProperties': 'Propiedades guardadas',
      'cleaningHistory': 'Historial de limpiezas',
      'cleaningHistoryEmpty': 'Aún no hay limpiezas completadas',
      'cleaningHistoryLoadFailed': 'No se pudo cargar el historial',
      'faq': 'FAQ',
      'addProperty': 'Añadir propiedad',
      'editProperty': 'Editar propiedad',
      'fixProperty': 'Corregir',
      'saveProperty': 'Guardar',
      'propertiesEmpty': 'Aún no hay propiedades guardadas',
      'propertiesLoadFailed': 'No se pudieron cargar las propiedades',
      'propertyLoadFailed': 'No se pudo cargar la propiedad',
      'propertySaveFailed': 'No se pudo guardar la propiedad',
      'propertyTitleRequired': 'El título es obligatorio',
      'propertyHousingRequired': 'Se requieren pies cuadrados, habitaciones y baños',
      'propertyIncomplete': 'Faltan el metraje, las habitaciones o los baños.',
      'propertySquareFootage': 'Metraje (sqft)',
      'propertySquareFootageHint': 'Área total',
      'propertyBedrooms': 'Habitaciones',
      'propertyBathrooms': 'Baños',
      'propertyTitle': 'Título',
      'propertyTitleHint': 'p. ej. Casa, Oficina',
      'propertyMainPhoto': 'Foto principal',
      'propertyPickMainPhoto': 'Toca para añadir una foto',
      'propertyAddress': 'Dirección',
      'propertyAddressHint': 'Calle, ciudad',
      'propertyDescription': 'Descripción de la casa',
      'propertyDescriptionHint': 'Habitaciones, notas del lugar',
      'propertyAdditionalPhotos': 'Fotos adicionales',
      'propertyEntryInstructions': 'Instrucciones de entrada',
      'propertyEntryHint': 'Códigos, llaves, cómo entrar',
      'next': 'Siguiente',
      'payNow': 'Pagar',
      'bookingStepOf': 'PASO {current} DE {total}',
      'bookingStepProperty': 'Propiedad',
      'bookingStepService': 'Servicio',
      'bookingStepAddons': 'Extras',
      'bookingAddonsTitle': '¿Quieres extras?',
      'bookingAddonsSubtitle': 'Puedes elegir varios extras o saltar este paso.',
      'bookingAddonsNone': 'Ninguno',
      'bookingWindowsLabel': '¿Cuántas ventanas?',
      'bookingWindowsHint': 'Número de ventanas',
      'bookingWindowsRequired': 'Indica el número de ventanas',
      'bookingEstimateTitle': 'Estimación preliminar',
      'bookingEstimateNote': 'Esta es una estimación preliminar. El precio y el tiempo finales pueden cambiar después de la revisión del gerente.',
      'bookingEstimatePrice': 'Precio estimado',
      'bookingEstimateTime': 'Tiempo estimado',
      'bookingEstimateFailed': 'No se pudo calcular la estimación',
      'bookingSummaryAddons': 'Extras',
      'bookingHoursValue': '{hours} h',
      'bookingStepSchedule': 'Horario',
      'bookingStepWishes': 'Deseos',
      'bookingStepPayment': 'Pago',
      'bookingPropertyTitle': '¿Dónde limpiamos?',
      'bookingPropertySubtitle': 'Elige una propiedad guardada o añade una nueva.',
      'bookingServiceTitle': '¿Qué servicio necesitas?',
      'bookingServiceSubtitle': 'Elige un solo servicio principal.',
      'bookingScheduleTitle': '¿Cuándo vamos?',
      'bookingScheduleSubtitle':
          'Elige una fecha y comprueba los huecos disponibles.',
      'bookingOneTime': 'Única',
      'bookingRecurring': 'Periódica',
      'bookingWeekly': 'Semanal',
      'bookingBiweekly': 'Cada 2 semanas',
      'bookingMonthly': 'Mensual',
      'bookingDate': 'Fecha',
      'bookingTime': 'Hora',
      'bookingPickDate': 'Elegir fecha',
      'bookingPickTime': 'Elegir hora',
      'bookingScheduleDisclaimer':
          'La fecha y hora requieren confirmación del gerente. Un gerente te contactará para confirmar.',
      'bookingCheckAvailability': 'Comprobar disponibilidad',
      'bookingNoSlots': 'No hay huecos libres para esta fecha',
      'bookingSelectSlot': 'Huecos disponibles',
      'bookingPreferredStart': 'Hora de inicio preferida',
      'bookingPreferredStartHint':
          'La ventana es más larga que el trabajo. Elige un inicio para que la visita quepa.',
      'bookingAvailabilityFailed': 'No se pudo comprobar la disponibilidad',
      'bookingHoldFailed': 'No se pudo reservar esta hora. Prueba otro hueco.',
      'bookingHeld': 'Hora reservada. Termina la reserva para conservarla.',
      'bookingWishesTitle': '¿Deseos especiales?',
      'bookingWishesSubtitle': 'Escribe instrucciones para la limpieza.',
      'bookingWishesHint': 'p. ej. más atención a la cocina…',
      'bookingPaymentTitle': 'Revisar y pagar',
      'bookingPaymentSubtitle': 'Verifica los datos antes del pago.',
      'bookingSummaryProperty': 'Propiedad',
      'bookingSummaryService': 'Servicio',
      'bookingSummarySchedule': 'Tipo de horario',
      'bookingSummaryNotes': 'Deseos',
      'bookingSubmitFailed': 'No se pudo crear la solicitud',
      'servicesLoadFailed': 'No se pudieron cargar los servicios',
      'servicesEmpty': 'Aún no hay servicios',
      'bookingConfirmedTitle': '¡Reserva confirmada!',
      'bookingConfirmedSubtitle': 'Benjamin está preparando tu equipo.',
      'viewBookingDetails': 'VER DETALLES',
      'backToHome': 'VOLVER AL INICIO',
      'sparkleGuaranteed': 'SPARKLE GUARANTEED',
    },
    'ru': {
      'menu': 'Меню',
      'aboutApp': 'О приложении',
      'settings': 'Настройки',
      'logout': 'Выйти',
      'language': 'Язык',
      'changeLanguage': 'Смена языка',
      'selectLanguage': 'Выберите язык',
      'back': 'Назад',
      'versionLabel': 'ВЕРСИЯ',
      'releaseDateLabel': 'ДАТА ВЫПУСКА',
      'releaseDateValue': 'июль 2026 г.',
      'developedBy': 'РАЗРАБОТАНО: ',
      'openLinkFailed': 'Не удалось открыть ссылку',
      'email': 'Email',
      'password': 'Пароль',
      'logIn': 'ВОЙТИ',
      'signUp': 'Зарегистрироваться',
      'noAccount': 'Нет аккаунта? ',
      'createAccount': 'Создать аккаунт',
      'name': 'Имя',
      'phone': 'Телефон',
      'confirmPassword': 'Подтвердите пароль',
      'createAccountBtn': 'СОЗДАТЬ АККАУНТ',
      'loginUnexpectedError': 'Неожиданная ошибка при входе',
      'invalidCredentials': 'Неверный email или пароль',
      'registerUnexpectedError': 'Неожиданная ошибка при регистрации',
      'home': 'Главная',
      'schedule': 'Расписание',
      'chat': 'Чат',
      'profile': 'Профиль',
      'accountStatus': 'Статус аккаунта',
      'bitrixLinkStatus': 'Статус связи Bitrix',
      'bitrixContactId': 'Bitrix Contact ID',
      'linkedClient': 'Связанный клиент',
      'noClientLinked': 'Клиент Bitrix ещё не связан.',
      'connectedToLaravel': 'Подключено к кешу Laravel',
      'activeOrders': 'Активные заказы',
      'upcomingOrders': 'Ближайшие заказы',
      'recentOrders': 'Недавние заказы',
      'address': 'Адрес',
      'cancel': 'Отмена',
      'chatHint': 'Сообщение…',
      'chatLoadFailed': 'Не удалось загрузить чат',
      'chatMessageDeleted': 'Сообщение удалено',
      'chatEdited': 'изменено',
      'chatEditing': 'Редактирование сообщения',
      'chatEdit': 'Изменить',
      'chatDelete': 'Удалить',
      'chatNotLinked': 'Привяжите клиентский аккаунт, чтобы пользоваться чатом.',
      'welcomeBack': 'С ВОЗВРАЩЕНИЕМ',
      'hiName': 'Привет, {name}!',
      'hiGuest': 'Привет!',
      'homeTagline': 'Пора для следующего блеска вашего дома.',
      'bookNewCleaning': '+ Заказать клининг',
      'upcomingService': 'БЛИЖАЙШИЙ СЕРВИС',
      'serviceNotOrdered': 'Сервис ещё не заказан.',
      'specialistRushing': '{name} уже спешит к вам',
      'specialistOnTheWayHint': 'Ваш клинер в пути',
      'news': 'НОВОСТИ',
      'newsEmpty': 'Новостей пока нет.',
      'newsLoadFailed': 'Не удалось загрузить новость',
      'homeLoadFailed': 'Не удалось обновить главную',
      'mySchedule': 'Моё расписание',
      'scheduleSubtitle': 'Управляйте ближайшими визитами.',
      'thisWeek': 'ЭТА НЕДЕЛЯ',
      'futureCleanings': 'БУДУЩИЕ',
      'recurringCleanings': 'ПЕРИОДИЧЕСКИЕ',
      'scheduleRequests': 'ЗАЯВКИ',
      'scheduleOrders': 'ЗАКАЗЫ',
      'subscribeCleaning': 'Подписаться на уборку',
      'scheduleDatePending': 'Дату подтвердят',
      'scheduleStatusPending': 'Ожидает подтверждения',
      'scheduleStatusScheduled': 'Запланирован',
      'scheduleStatusAccepted': 'Принят',
      'scheduleStatusOnTheWay': 'В пути',
      'scheduleStatusStarted': 'В работе',
      'scheduleStatusFinished': 'Завершён',
      'scheduleStatusCancelled': 'Отменён',
      'propertyLabel': 'Объект',
      'serviceLabel': 'Услуга',
      'addonsLabel': 'Допы',
      'notesLabel': 'Пожелания',
      'priceLabel': 'Цена',
      'scheduleSectionEmpty': 'Пока пусто',
      'scheduleLoadFailed': 'Не удалось загрузить расписание',
      'cleaningDetails': 'Детали уборки',
      'orderLoadFailed': 'Не удалось загрузить уборку',
      'deleteRequest': 'УДАЛИТЬ',
      'deleteRequestTitle': 'Удалить заявку?',
      'deleteRequestConfirm':
          'Заявка будет удалена, а зарезервированное время снова станет свободным.',
      'deleteRequestFailed': 'Не удалось удалить заявку',
      'dateLabel': 'Дата',
      'timeLabel': 'Время',
      'paymentStatusLabel': 'Оплата',
      'typeLabel': 'Тип',
      'specialistLabel': 'Специалист',
      'durationLabel': 'Длительность (ч)',
      'instructionsLabel': 'Инструкции',
      'statusTimelineLabel': 'История статусов',
      'orderVisit': 'Визит',
      'orderWindows': 'Окна',
      'moreDetails': 'Подробнее',
      'paymentPaid': 'Оплачено',
      'paymentUnpaid': 'Не оплачено',
      'paymentPending': 'Ожидает оплаты',
      'paymentFailed': 'Ошибка оплаты',
      'inboxTitle': 'Сообщения',
      'inboxEmpty': 'Сообщений пока нет',
      'inboxLoadFailed': 'Не удалось загрузить сообщения',
      'inboxMessage': 'Сообщение',
      'inboxNew': 'Новое',
      'inboxRead': 'Прочитал',
      'inboxMarkFailed': 'Не удалось отметить сообщение прочитанным',
      'inboxConfirm': 'Подтверждаю',
      'inboxDecline': 'Не подтверждаю',
      'inboxPostpone': 'Отложить',
      'inboxActionFailed': 'Не удалось отправить ответ',
      'orderFinishedTitle': 'ЗАКАЗ УСПЕШНО ВЫПОЛНЕН',
      'orderFinishedBody': 'Пожалуйста, оцените уборку',
      'ratingSubmitFailed': 'Не удалось сохранить оценку',
      'profileSettingsSection': 'НАСТРОЙКИ',
      'supportSecuritySection': 'ПОДДЕРЖКА И БЕЗОПАСНОСТЬ',
      'savedProperties': 'Сохранённые объекты',
      'cleaningHistory': 'История уборок',
      'cleaningHistoryEmpty': 'Завершённых уборок пока нет',
      'cleaningHistoryLoadFailed': 'Не удалось загрузить историю',
      'faq': 'FAQ',
      'addProperty': 'Добавить объект',
      'editProperty': 'Редактировать объект',
      'fixProperty': 'Исправить',
      'saveProperty': 'Сохранить',
      'propertiesEmpty': 'Пока нет сохранённых объектов',
      'propertiesLoadFailed': 'Не удалось загрузить объекты',
      'propertyLoadFailed': 'Не удалось загрузить объект',
      'propertySaveFailed': 'Не удалось сохранить объект',
      'propertyTitleRequired': 'Укажите название',
      'propertyHousingRequired': 'Укажите метраж, количество спален и ванных',
      'propertyIncomplete': 'Нет метража, спален или ванных.',
      'propertySquareFootage': 'Метраж (sqft)',
      'propertySquareFootageHint': 'Общая площадь',
      'propertyBedrooms': 'Спальни',
      'propertyBathrooms': 'Ванные',
      'propertyTitle': 'Название',
      'propertyTitleHint': 'например, Дом, Офис',
      'propertyMainPhoto': 'Главное фото',
      'propertyPickMainPhoto': 'Нажмите, чтобы добавить фото',
      'propertyAddress': 'Адрес',
      'propertyAddressHint': 'Улица, город',
      'propertyDescription': 'Описание дома',
      'propertyDescriptionHint': 'Комнаты, заметки о месте',
      'propertyAdditionalPhotos': 'Дополнительные фото',
      'propertyEntryInstructions': 'Инструкции для входа',
      'propertyEntryHint': 'Коды, ключи, как войти',
      'next': 'Далее',
      'payNow': 'Оплатить',
      'bookingStepOf': 'ШАГ {current} ИЗ {total}',
      'bookingStepProperty': 'Объект уборки',
      'bookingStepService': 'Тип уборки',
      'bookingStepAddons': 'Доп. услуги',
      'bookingAddonsTitle': 'Нужны допы?',
      'bookingAddonsSubtitle': 'Можно выбрать несколько услуг или пропустить шаг.',
      'bookingAddonsNone': 'Не выбрано',
      'bookingWindowsLabel': 'Сколько окон?',
      'bookingWindowsHint': 'Количество окон',
      'bookingWindowsRequired': 'Укажите количество окон',
      'bookingEstimateTitle': 'Предварительный расчёт',
      'bookingEstimateNote': 'Это предварительный расчёт. Итоговые цена и время могут измениться после проверки менеджером.',
      'bookingEstimatePrice': 'Ориентировочная цена',
      'bookingEstimateTime': 'Ориентировочное время',
      'bookingEstimateFailed': 'Не удалось посчитать смету',
      'bookingSummaryAddons': 'Доп. услуги',
      'bookingHoursValue': '{hours} ч',
      'bookingStepSchedule': 'Расписание',
      'bookingStepWishes': 'Пожелания',
      'bookingStepPayment': 'Оплата',
      'bookingPropertyTitle': 'Где убирать?',
      'bookingPropertySubtitle': 'Выберите сохранённый объект или добавьте новый.',
      'bookingServiceTitle': 'Какая уборка нужна?',
      'bookingServiceSubtitle': 'Выберите одну основную услугу.',
      'bookingScheduleTitle': 'Когда приехать?',
      'bookingScheduleSubtitle':
          'Выберите дату, затем проверьте свободные слоты.',
      'bookingOneTime': 'Разовая',
      'bookingRecurring': 'Периодическая',
      'bookingWeekly': 'Каждую неделю',
      'bookingBiweekly': 'Раз в 2 недели',
      'bookingMonthly': 'Раз в месяц',
      'bookingDate': 'Дата',
      'bookingTime': 'Время',
      'bookingPickDate': 'Выберите дату',
      'bookingPickTime': 'Выберите время',
      'bookingScheduleDisclaimer':
          'Дата и время требуют согласования с менеджером. Для подтверждения с вами свяжется менеджер.',
      'bookingCheckAvailability': 'Проверить доступность',
      'bookingNoSlots': 'На эту дату нет свободных слотов',
      'bookingSelectSlot': 'Свободные слоты',
      'bookingPreferredStart': 'Предпочтительное время старта',
      'bookingPreferredStartHint':
          'Свободное окно длиннее уборки. Выберите старт так, чтобы визит поместился в него.',
      'bookingAvailabilityFailed': 'Не удалось проверить доступность',
      'bookingHoldFailed': 'Не удалось зарезервировать время. Выберите другой слот.',
      'bookingHeld': 'Время зарезервировано. Завершите заявку, чтобы сохранить слот.',
      'bookingWishesTitle': 'Особые пожелания?',
      'bookingWishesSubtitle': 'Укажите инструкции к уборке.',
      'bookingWishesHint': 'например, больше внимания кухне, ключи под ковриком…',
      'bookingPaymentTitle': 'Проверка и оплата',
      'bookingPaymentSubtitle': 'Проверьте данные перед оплатой.',
      'bookingSummaryProperty': 'Объект',
      'bookingSummaryService': 'Услуга',
      'bookingSummarySchedule': 'Тип расписания',
      'bookingSummaryNotes': 'Пожелания',
      'bookingSubmitFailed': 'Не удалось создать запрос',
      'servicesLoadFailed': 'Не удалось загрузить услуги',
      'servicesEmpty': 'Услуг пока нет',
      'bookingConfirmedTitle': 'Бронирование подтверждено!',
      'bookingConfirmedSubtitle': 'Benjamin готовит вашу команду.',
      'viewBookingDetails': 'ДЕТАЛИ БРОНИРОВАНИЯ',
      'backToHome': 'НА ГЛАВНУЮ',
      'sparkleGuaranteed': 'SPARKLE GUARANTEED',
    },
  };
}
