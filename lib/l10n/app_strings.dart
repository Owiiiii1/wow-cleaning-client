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

  String _t(String key) =>
      (_tables[_code] ?? _tables['en']!)[key] ?? _tables['en']![key] ?? key;

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
  String get currentService => _t('currentService');
  String get serviceNotOrdered => _t('serviceNotOrdered');
  String specialistRushing(String name) =>
      _t('specialistRushing').replaceAll('{name}', name);
  String get specialistOnTheWayHint => _t('specialistOnTheWayHint');
  String get trackingButton => _t('trackingButton');
  String get callOperator => _t('callOperator');
  String get operatorButton => _t('operatorButton');
  String get callOperatorConfirmTitle => _t('callOperatorConfirmTitle');
  String get callOperatorConfirmBody => _t('callOperatorConfirmBody');
  String get callOperatorConfirmAction => _t('callOperatorConfirmAction');
  String get updateAppTitle => _t('updateAppTitle');
  String get updateAppBody => _t('updateAppBody');
  String get updateAppButton => _t('updateAppButton');
  String get trackingTitle => _t('trackingTitle');
  String get trackingLive => _t('trackingLive');
  String get trackingIdle => _t('trackingIdle');
  String get trackingNoPoint => _t('trackingNoPoint');
  String get trackingLoadFailed => _t('trackingLoadFailed');
  String get stageAccepted => _t('stageAccepted');
  String get stageOnTheWay => _t('stageOnTheWay');
  String get stageCleaning => _t('stageCleaning');
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
  String get orderFrozen => _t('orderFrozen');
  String get frozenPaymentFailed => _t('frozenPaymentFailed');
  String get frozenNoCard => _t('frozenNoCard');
  String get frozenAuthTimeout => _t('frozenAuthTimeout');
  String get retryPayment => _t('retryPayment');
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
  String get surveyTitle => _t('surveyTitle');
  String get surveyBody => _t('surveyBody');
  String get surveyCleaningQuality => _t('surveyCleaningQuality');
  String get surveyPunctuality => _t('surveyPunctuality');
  String get surveyCommunication => _t('surveyCommunication');
  String get surveyConvenience => _t('surveyConvenience');
  String get surveyComment => _t('surveyComment');
  String get surveyCommentHint => _t('surveyCommentHint');
  String get surveySubmit => _t('surveySubmit');
  String get surveySkip => _t('surveySkip');
  String get surveySubmitFailed => _t('surveySubmitFailed');
  String get cleaningHistoryEmpty => _t('cleaningHistoryEmpty');
  String get cleaningHistoryLoadFailed => _t('cleaningHistoryLoadFailed');
  String get profileSettingsSection => _t('profileSettingsSection');
  String get paymentCardSection => _t('paymentCardSection');
  String get paymentCardNone => _t('paymentCardNone');
  String paymentCardExpiry(String date) =>
      _t('paymentCardExpiry').replaceAll('{date}', date);
  String get paymentCardUnlink => _t('paymentCardUnlink');
  String get paymentCardAdd => _t('paymentCardAdd');
  String get paymentCardUnlinkTitle => _t('paymentCardUnlinkTitle');
  String get paymentCardUnlinkConfirm => _t('paymentCardUnlinkConfirm');
  String get paymentCardUnlinked => _t('paymentCardUnlinked');
  String get paymentCardUnlinkFailed => _t('paymentCardUnlinkFailed');
  String get paymentCardUnlinkRequested => _t('paymentCardUnlinkRequested');
  String get ok => _t('ok');
  String get supportSecuritySection => _t('supportSecuritySection');
  String get savedProperties => _t('savedProperties');
  String get cleaningHistory => _t('cleaningHistory');
  String get faq => _t('faq');
  String get requests => _t('requests');
  String get newRequest => _t('newRequest');
  String get requestDetails => _t('requestDetails');
  String get requestActive => _t('requestActive');
  String get requestCompleted => _t('requestCompleted');
  String get requestAll => _t('requestAll');
  String get requestsEmpty => _t('requestsEmpty');
  String get requestsLoadFailed => _t('requestsLoadFailed');
  String get feedbackPrompt => _t('feedbackPrompt');
  String get disputePrompt => _t('disputePrompt');
  String get requestMessageHint => _t('requestMessageHint');
  String get addPhotos => _t('addPhotos');
  String get photos => _t('photos');
  String requestPhotos(int count) =>
      _t('requestPhotos').replaceAll('{count}', '$count');
  String get sendRequest => _t('sendRequest');
  String get requestSubmitFailed => _t('requestSubmitFailed');
  String get reportProblem => _t('reportProblem');
  String get problemReported => _t('problemReported');
  String reportProblemUntil(String date) =>
      _t('reportProblemUntil').replaceAll('{date}', date);
  String get operatorUpdates => _t('operatorUpdates');
  String get noOperatorUpdates => _t('noOperatorUpdates');
  String get contactSupport => _t('contactSupport');
  String get relatedCleaning => _t('relatedCleaning');
  String get remediationCleaning => _t('remediationCleaning');
  String get resolution => _t('resolution');
  String requestTypeLabel(String type) => type == 'cleaning_dispute'
      ? _t('cleaningDispute')
      : _t('generalFeedback');
  String requestStatusLabel(String status) {
    const known = {
      'new': 'requestStatusNew',
      'open': 'requestStatusOpen',
      'in_progress': 'requestStatusInProgress',
      'waiting_client': 'requestStatusWaitingClient',
      'resolved': 'requestStatusResolved',
      'completed': 'requestStatusCompleted',
      'closed': 'requestStatusClosed',
    };
    final key = known[status];
    return key == null ? status.replaceAll('_', ' ') : _t(key);
  }

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
  String get propertyAddressLine1 => _t('propertyAddressLine1');
  String get propertyAddressLine1Hint => _t('propertyAddressLine1Hint');
  String get propertyAddressLine2 => _t('propertyAddressLine2');
  String get propertyAddressLine2Hint => _t('propertyAddressLine2Hint');
  String get propertyCity => _t('propertyCity');
  String get propertyState => _t('propertyState');
  String get propertyZip => _t('propertyZip');
  String get propertySelectState => _t('propertySelectState');
  String get propertyAddressRequired => _t('propertyAddressRequired');
  String get propertyZipInvalid => _t('propertyZipInvalid');
  String get propertyStepAddress => _t('propertyStepAddress');
  String get propertyStepDescription => _t('propertyStepDescription');
  String get propertyStepInstructions => _t('propertyStepInstructions');
  String get propertyStepPhotos => _t('propertyStepPhotos');
  String get propertyInstructionsPhotosHint =>
      _t('propertyInstructionsPhotosHint');
  String get propertyBedroomsShort => _t('propertyBedroomsShort');
  String get propertyBathroomsShort => _t('propertyBathroomsShort');
  String get propertyDelete => _t('propertyDelete');
  String get propertyDeleteTitle => _t('propertyDeleteTitle');
  String get propertyDeleteConfirm => _t('propertyDeleteConfirm');
  String get propertyDeleteFailed => _t('propertyDeleteFailed');
  String get propertyMyTitle => _t('propertyMyTitle');
  String get next => _t('next');
  String get payNow => _t('payNow');
  String get securePaymentMethod => _t('securePaymentMethod');
  String get cardSetupHint => _t('cardSetupHint');
  String get cardSetupBefore => _t('cardSetupBefore');
  String get cardAlreadyLinked => _t('cardAlreadyLinked');
  String get cardSetupCancelled => _t('cardSetupCancelled');
  String get cardSetupPending => _t('cardSetupPending');
  String get cardSetupContinue => _t('cardSetupContinue');
  String bookingStepOf(int current, int total) => _t(
    'bookingStepOf',
  ).replaceAll('{current}', '$current').replaceAll('{total}', '$total');
  String get bookingStepProperty => _t('bookingStepProperty');
  String get bookingStepService => _t('bookingStepService');
  String get bookingStepAddons => _t('bookingStepAddons');
  String get bookingAddonsTitle => _t('bookingAddonsTitle');
  String get bookingAddonsSubtitle => _t('bookingAddonsSubtitle');
  String get bookingAddonsNone => _t('bookingAddonsNone');
  String get bookingWindowsLabel => _t('bookingWindowsLabel');
  String get bookingWindowsHint => _t('bookingWindowsHint');
  String get bookingWindowsRequired => _t('bookingWindowsRequired');
  String get bookingWindowsInside => _t('bookingWindowsInside');
  String get bookingWindowsOutside => _t('bookingWindowsOutside');
  String get bookingWindowsSidesRequired => _t('bookingWindowsSidesRequired');
  String get bookingWindowsFormula => _t('bookingWindowsFormula');
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
      'currentService': 'CURRENT SERVICE',
      'serviceNotOrdered': 'Service has not been ordered yet.',
      'specialistRushing': '{name} is already rushing to you',
      'specialistOnTheWayHint': 'Your cleaner is on the way',
      'trackingButton': 'Tracking',
      'callOperator': 'Call operator',
      'operatorButton': 'Operator',
      'callOperatorConfirmTitle': 'Call the operator?',
      'callOperatorConfirmBody': 'Open the phone app and call {phone}?',
      'callOperatorConfirmAction': 'Call',
      'updateAppTitle': 'Update the app',
      'updateAppBody':
          'This version is no longer supported. Please install the latest version from the store.',
      'updateAppButton': 'Update',
      'trackingTitle': 'LIVE TRACKING',
      'trackingLive': 'Live',
      'trackingIdle': 'Waiting',
      'trackingNoPoint': 'The cleaner location is not available yet.',
      'trackingLoadFailed': 'Could not load the location.',
      'stageAccepted': 'Accepted',
      'stageOnTheWay': 'On the way',
      'stageCleaning': 'Cleaning',
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
      'orderFrozen': 'ORDER FROZEN',
      'frozenPaymentFailed':
          'The payment was declined. Replace the card or retry payment.',
      'frozenNoCard': 'A payment card is required to restore this visit.',
      'frozenAuthTimeout':
          'The payment confirmation deadline expired. Retry payment.',
      'retryPayment': 'Restore payment',
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
      'surveyTitle': 'HELP US IMPROVE',
      'surveyBody': 'A few quick answers will help us make the service better.',
      'surveyCleaningQuality': 'Cleaning quality',
      'surveyPunctuality': 'Team punctuality',
      'surveyCommunication': 'Communication and courtesy',
      'surveyConvenience': 'Service convenience',
      'surveyComment': 'What could we improve? (optional)',
      'surveyCommentHint': 'Share any suggestions',
      'surveySubmit': 'Send feedback',
      'surveySkip': 'Not now',
      'surveySubmitFailed': 'Could not send the survey. Please try again.',
      'profileSettingsSection': 'SETTINGS',
      'paymentCardSection': 'PAYMENT CARD',
      'paymentCardNone': 'No card linked',
      'paymentCardExpiry': 'Exp {date}',
      'paymentCardUnlink': 'Unlink card',
      'paymentCardAdd': 'Add card',
      'paymentCardUnlinkTitle': 'UNLINK CARD',
      'paymentCardUnlinkConfirm':
          'The card will be removed from Stripe and will no longer be saved on your account.',
      'paymentCardUnlinked': 'Card unlinked',
      'paymentCardUnlinkFailed': 'Could not unlink the card. Please try again.',
      'paymentCardUnlinkRequested':
          'Request to unlink the card has been sent to the operator',
      'ok': 'OK',
      'supportSecuritySection': 'SUPPORT & SECURITY',
      'savedProperties': 'Saved properties',
      'cleaningHistory': 'Cleaning history',
      'cleaningHistoryEmpty': 'No completed cleanings yet',
      'cleaningHistoryLoadFailed': 'Failed to load cleaning history',
      'faq': 'FAQ',
      'requests': 'Requests',
      'newRequest': 'New request',
      'requestDetails': 'Request details',
      'requestActive': 'Active',
      'requestCompleted': 'Completed',
      'requestAll': 'All',
      'requestsEmpty': 'No requests here yet',
      'requestsLoadFailed': 'Failed to load requests',
      'feedbackPrompt': 'Tell us how we can help or improve our service.',
      'disputePrompt': 'Describe the problem with this cleaning.',
      'requestMessageHint': 'Describe the situation…',
      'addPhotos': 'Add photos',
      'photos': 'Photos',
      'requestPhotos': 'Photos ({count}/5)',
      'sendRequest': 'SEND REQUEST',
      'requestSubmitFailed': 'Could not send the request. Please try again.',
      'reportProblem': 'Report a problem',
      'problemReported': 'Problem reported',
      'reportProblemUntil': 'Available until {date}',
      'operatorUpdates': 'Operator updates',
      'noOperatorUpdates': 'No updates yet.',
      'contactSupport': 'Open support chat',
      'relatedCleaning': 'Related cleaning',
      'remediationCleaning': 'Remediation cleaning',
      'resolution': 'Resolution',
      'generalFeedback': 'General feedback',
      'cleaningDispute': 'Cleaning problem',
      'requestStatusNew': 'New',
      'requestStatusOpen': 'Open',
      'requestStatusInProgress': 'In progress',
      'requestStatusWaitingClient': 'Waiting for you',
      'requestStatusResolved': 'Resolved',
      'requestStatusCompleted': 'Completed',
      'requestStatusClosed': 'Closed',
      'addProperty': 'Add property',
      'editProperty': 'Edit property',
      'fixProperty': 'Fix',
      'saveProperty': 'Save',
      'propertiesEmpty': 'No saved properties yet',
      'propertiesLoadFailed': 'Failed to load properties',
      'propertyLoadFailed': 'Failed to load property',
      'propertySaveFailed': 'Failed to save property',
      'propertyTitleRequired': 'Title is required',
      'propertyHousingRequired':
          'Square footage, bedrooms and bathrooms are required',
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
      'propertyAddressLine1': 'Street address',
      'propertyAddressLine1Hint': '123 Main St',
      'propertyAddressLine2': 'Apt, suite, unit',
      'propertyAddressLine2Hint': 'Apt 4B (optional)',
      'propertyCity': 'City',
      'propertyState': 'State',
      'propertyZip': 'ZIP code',
      'propertySelectState': 'Select state',
      'propertyAddressRequired': 'Enter street, city, state and ZIP',
      'propertyZipInvalid': 'Enter a 5-digit ZIP code',
      'propertyStepAddress': 'ADDRESS',
      'propertyStepDescription': 'HOME DETAILS',
      'propertyStepInstructions': 'INSTRUCTIONS',
      'propertyStepPhotos': 'NAME & PHOTOS',
      'propertyInstructionsPhotosHint':
          'If you need photos of the home or access, you can add them on the next step.',
      'propertyBedroomsShort': 'bd',
      'propertyBathroomsShort': 'ba',
      'propertyDelete': 'Delete property',
      'propertyDeleteTitle': 'DELETE PROPERTY',
      'propertyDeleteConfirm':
          'This property will be removed from your saved list.',
      'propertyDeleteFailed': 'Could not delete the property.',
      'propertyMyTitle': 'MY PROPERTIES',
      'next': 'Next',
      'payNow': 'Pay',
      'securePaymentMethod': 'Secure payment method',
      'cardSetupHint':
          'You will not be charged now. Your card is saved securely by Stripe.',
      'cardSetupBefore': 'Add a card to confirm your booking.',
      'cardAlreadyLinked': 'A payment card is already linked to your account.',
      'cardSetupCancelled':
          'Card setup was cancelled. Please add a card to confirm your booking.',
      'cardSetupPending': 'Waiting for card confirmation...',
      'cardSetupContinue': 'Continue',
      'bookingStepOf': 'STEP {current} OF {total}',
      'bookingStepProperty': 'Choose property',
      'bookingStepService': 'Choose service',
      'bookingStepAddons': 'Add-ons',
      'bookingAddonsTitle': 'Any extras?',
      'bookingAddonsSubtitle':
          'You can select several add-ons or skip this step.',
      'bookingAddonsNone': 'None selected',
      'bookingWindowsLabel': 'How many windows?',
      'bookingWindowsHint': 'Number of windows',
      'bookingWindowsRequired': 'Enter the number of windows',
      'bookingWindowsInside': 'Inside',
      'bookingWindowsOutside': 'Outside',
      'bookingWindowsSidesRequired': 'Choose inside, outside, or both',
      'bookingWindowsFormula':
          '\$5 inside, \$10 outside, \$15 both — per window',
      'bookingEstimateTitle': 'Preliminary estimate',
      'bookingEstimateNote':
          'This is a preliminary estimate. The final price may change after a manager reviews the order.',
      'bookingEstimatePrice': 'Estimated price',
      'bookingEstimateTime': 'Estimated time',
      'bookingEstimateFailed': 'Could not calculate the estimate',
      'bookingSummaryAddons': 'Add-ons',
      'bookingHoursValue': '{hours} h',
      'bookingStepSchedule': 'Schedule',
      'bookingStepWishes': 'Special wishes',
      'bookingStepPayment': 'Confirm',
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
      'bookingPaymentTitle': 'Review & confirm',
      'bookingPaymentSubtitle': 'Add a card to confirm your booking.',
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
      'chatNotLinked':
          'Привʼяжіть клієнтський акаунт, щоб користуватися чатом.',
      'welcomeBack': 'З ПОВЕРНЕННЯМ',
      'hiName': 'Привіт, {name}!',
      'hiGuest': 'Привіт!',
      'homeTagline': 'Час для наступного блиску вашого дому.',
      'bookNewCleaning': '+ Замовити клінінг',
      'upcomingService': 'НАЙБЛИЖЧИЙ СЕРВІС',
      'currentService': 'ПОТОЧНИЙ СЕРВІС',
      'serviceNotOrdered': 'Сервіс ще не замовлено.',
      'specialistRushing': '{name} вже поспішає до вас',
      'specialistOnTheWayHint': 'Ваш клінер у дорозі',
      'trackingButton': 'Трекінг',
      'callOperator': 'Подзвонити оператору',
      'operatorButton': 'Оператор',
      'callOperatorConfirmTitle': 'Подзвонити оператору?',
      'callOperatorConfirmBody': 'Відкрити телефон і зателефонувати {phone}?',
      'callOperatorConfirmAction': 'Подзвонити',
      'updateAppTitle': 'Оновіть додаток',
      'updateAppBody':
          'Ця версія більше не підтримується. Встановіть останню версію з магазину.',
      'updateAppButton': 'Оновити',
      'trackingTitle': 'ТРЕКІНГ',
      'trackingLive': 'Наживо',
      'trackingIdle': 'Очікування',
      'trackingNoPoint': 'Геопозиція клінера ще недоступна.',
      'trackingLoadFailed': 'Не вдалося завантажити геопозицію.',
      'stageAccepted': 'Прийнято',
      'stageOnTheWay': 'В дорозі',
      'stageCleaning': 'Уборка',
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
      'orderFrozen': 'ЗАМОВЛЕННЯ ЗАМОРОЖЕНО',
      'frozenPaymentFailed':
          'Платіж відхилено. Замініть картку або повторіть оплату.',
      'frozenNoCard': 'Щоб відновити візит, додайте платіжну картку.',
      'frozenAuthTimeout':
          'Строк підтвердження оплати минув. Повторіть оплату.',
      'retryPayment': 'Відновити оплату',
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
      'surveyTitle': 'ДОПОМОЖІТЬ НАМ СТАТИ КРАЩИМИ',
      'surveyBody':
          'Кілька коротких відповідей допоможуть нам покращити сервіс.',
      'surveyCleaningQuality': 'Якість прибирання',
      'surveyPunctuality': 'Пунктуальність команди',
      'surveyCommunication': 'Спілкування та ввічливість',
      'surveyConvenience': 'Зручність сервісу',
      'surveyComment': 'Що ми можемо покращити? (необов’язково)',
      'surveyCommentHint': 'Поділіться своїми побажаннями',
      'surveySubmit': 'Надіслати відгук',
      'surveySkip': 'Не зараз',
      'surveySubmitFailed': 'Не вдалося надіслати анкету. Спробуйте ще раз.',
      'profileSettingsSection': 'НАЛАШТУВАННЯ',
      'paymentCardSection': 'ПЛАТІЖНА КАРТКА',
      'paymentCardNone': 'Картка не прив’язана',
      'paymentCardExpiry': 'До {date}',
      'paymentCardUnlink': 'Відв’язати картку',
      'paymentCardAdd': 'Додати картку',
      'paymentCardUnlinkTitle': 'ВІДВ’ЯЗАТИ КАРТКУ',
      'paymentCardUnlinkConfirm':
          'Картку буде видалено зі Stripe і вона більше не зберігатиметься в акаунті.',
      'paymentCardUnlinked': 'Картку відв’язано',
      'paymentCardUnlinkFailed':
          'Не вдалося відв’язати картку. Спробуйте ще раз.',
      'paymentCardUnlinkRequested':
          'Запит на відв’язування картки надіслано оператору',
      'ok': 'OK',
      'supportSecuritySection': 'ПІДТРИМКА ТА БЕЗПЕКА',
      'savedProperties': 'Збережені обʼєкти',
      'cleaningHistory': 'Історія прибирань',
      'cleaningHistoryEmpty': 'Завершених прибирань ще немає',
      'cleaningHistoryLoadFailed': 'Не вдалося завантажити історію',
      'faq': 'FAQ',
      'requests': 'Звернення',
      'newRequest': 'Нове звернення',
      'requestDetails': 'Деталі звернення',
      'requestActive': 'Активні',
      'requestCompleted': 'Завершені',
      'requestAll': 'Усі',
      'requestsEmpty': 'Звернень поки немає',
      'requestsLoadFailed': 'Не вдалося завантажити звернення',
      'feedbackPrompt':
          'Розкажіть, як ми можемо допомогти або покращити сервіс.',
      'disputePrompt': 'Опишіть проблему з цим прибиранням.',
      'requestMessageHint': 'Опишіть ситуацію…',
      'addPhotos': 'Додати фото',
      'photos': 'Фото',
      'requestPhotos': 'Фото ({count}/5)',
      'sendRequest': 'НАДІСЛАТИ',
      'requestSubmitFailed':
          'Не вдалося надіслати звернення. Спробуйте ще раз.',
      'reportProblem': 'Повідомити про проблему',
      'problemReported': 'Про проблему повідомлено',
      'reportProblemUntil': 'Доступно до {date}',
      'operatorUpdates': 'Оновлення оператора',
      'noOperatorUpdates': 'Оновлень поки немає.',
      'contactSupport': 'Відкрити чат підтримки',
      'relatedCleaning': 'Пов’язане прибирання',
      'remediationCleaning': 'Повторне прибирання',
      'resolution': 'Рішення',
      'generalFeedback': 'Загальний відгук',
      'cleaningDispute': 'Проблема з прибиранням',
      'requestStatusNew': 'Нове',
      'requestStatusOpen': 'Відкрите',
      'requestStatusInProgress': 'В роботі',
      'requestStatusWaitingClient': 'Очікує на вас',
      'requestStatusResolved': 'Вирішено',
      'requestStatusCompleted': 'Завершено',
      'requestStatusClosed': 'Закрито',
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
      'propertyAddressLine1': 'Вулиця',
      'propertyAddressLine1Hint': '123 Main St',
      'propertyAddressLine2': 'Квартира, suite, unit',
      'propertyAddressLine2Hint': 'Apt 4B (необовʼязково)',
      'propertyCity': 'Місто',
      'propertyState': 'Штат',
      'propertyZip': 'ZIP-код',
      'propertySelectState': 'Оберіть штат',
      'propertyAddressRequired': 'Вкажіть вулицю, місто, штат і ZIP',
      'propertyZipInvalid': 'Введіть 5-значний ZIP',
      'propertyStepAddress': 'АДРЕСА',
      'propertyStepDescription': 'ПРО БУДИНОК',
      'propertyStepInstructions': 'ІНСТРУКЦІЇ',
      'propertyStepPhotos': 'НАЗВА І ФОТО',
      'propertyInstructionsPhotosHint':
          'Якщо потрібні фото будинку чи доступу, їх можна додати на наступному кроці.',
      'propertyBedroomsShort': 'сп.',
      'propertyBathroomsShort': 'ван.',
      'propertyDelete': 'Видалити обʼєкт',
      'propertyDeleteTitle': 'ВИДАЛИТИ ОБʼЄКТ',
      'propertyDeleteConfirm': 'Обʼєкт буде видалено зі збережених.',
      'propertyDeleteFailed': 'Не вдалося видалити обʼєкт.',
      'propertyMyTitle': 'МОЇ ОБʼЄКТИ',
      'next': 'Далі',
      'payNow': 'Оплатити',
      'securePaymentMethod': 'Надійний спосіб оплати',
      'cardSetupHint':
          'Зараз списання не буде. Картка зберігається безпечно в Stripe.',
      'cardSetupBefore': 'Додайте картку, щоб підтвердити бронювання.',
      'cardAlreadyLinked': 'Платіжна картка вже прив’язана до вашого акаунта.',
      'cardSetupCancelled':
          'Додавання картки скасовано. Додайте картку, щоб підтвердити бронювання.',
      'cardSetupPending': 'Очікуємо підтвердження картки...',
      'cardSetupContinue': 'Продовжити',
      'bookingStepOf': 'КРОК {current} З {total}',
      'bookingStepProperty': 'Обʼєкт уборки',
      'bookingStepService': 'Тип уборки',
      'bookingStepAddons': 'Доп. послуги',
      'bookingAddonsTitle': 'Потрібні допи?',
      'bookingAddonsSubtitle':
          'Можна обрати кілька послуг або пропустити крок.',
      'bookingAddonsNone': 'Не обрано',
      'bookingWindowsLabel': 'Скільки вікон?',
      'bookingWindowsHint': 'Кількість вікон',
      'bookingWindowsRequired': 'Вкажіть кількість вікон',
      'bookingWindowsInside': 'Зсередини',
      'bookingWindowsOutside': 'Ззовні',
      'bookingWindowsSidesRequired':
          'Оберіть зсередини, ззовні або обидва варіанти',
      'bookingWindowsFormula':
          '\$5 зсередини, \$10 ззовні, \$15 і так і так — за одне вікно',
      'bookingEstimateTitle': 'Попередній розрахунок',
      'bookingEstimateNote':
          'Це попередній розрахунок. Фінальна ціна може змінитися після перевірки менеджером.',
      'bookingEstimatePrice': 'Орієнтовна ціна',
      'bookingEstimateTime': 'Орієнтовний час',
      'bookingEstimateFailed': 'Не вдалося розрахувати кошторис',
      'bookingSummaryAddons': 'Доп. послуги',
      'bookingHoursValue': '{hours} год',
      'bookingStepSchedule': 'Розклад',
      'bookingStepWishes': 'Побажання',
      'bookingStepPayment': 'Підтвердження',
      'bookingPropertyTitle': 'Де прибирати?',
      'bookingPropertySubtitle': 'Оберіть збережений обʼєкт або додайте новий.',
      'bookingServiceTitle': 'Яка уборка потрібна?',
      'bookingServiceSubtitle': 'Оберіть одну основну послугу.',
      'bookingScheduleTitle': 'Коли приїхати?',
      'bookingScheduleSubtitle': 'Оберіть дату, потім перевірте вільні слоти.',
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
      'bookingHoldFailed':
          'Не вдалося зарезервувати час. Спробуйте інший слот.',
      'bookingHeld': 'Час зарезервовано. Завершіть заявку, щоб залишити його.',
      'bookingWishesTitle': 'Особливі побажання?',
      'bookingWishesSubtitle': 'Вкажіть інструкції до прибирання.',
      'bookingWishesHint': 'напр. більше уваги кухні, ключі під килимком…',
      'bookingPaymentTitle': 'Перевірка та підтвердження',
      'bookingPaymentSubtitle': 'Додайте картку, щоб підтвердити бронювання.',
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
      'currentService': 'SERVICIO ACTUAL',
      'serviceNotOrdered': 'Aún no has pedido un servicio.',
      'specialistRushing': '{name} ya va hacia ti',
      'specialistOnTheWayHint': 'Tu limpiador está en camino',
      'trackingButton': 'Seguimiento',
      'callOperator': 'Llamar al operador',
      'operatorButton': 'Operador',
      'callOperatorConfirmTitle': '¿Llamar al operador?',
      'callOperatorConfirmBody':
          '¿Abrir la app de teléfono y llamar a {phone}?',
      'callOperatorConfirmAction': 'Llamar',
      'updateAppTitle': 'Actualiza la app',
      'updateAppBody':
          'Esta versión ya no es compatible. Instala la última versión desde la tienda.',
      'updateAppButton': 'Actualizar',
      'trackingTitle': 'SEGUIMIENTO',
      'trackingLive': 'En vivo',
      'trackingIdle': 'En espera',
      'trackingNoPoint': 'La ubicación aún no está disponible.',
      'trackingLoadFailed': 'No se pudo cargar la ubicación.',
      'stageAccepted': 'Aceptada',
      'stageOnTheWay': 'En camino',
      'stageCleaning': 'Limpieza',
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
      'orderFrozen': 'PEDIDO CONGELADO',
      'frozenPaymentFailed':
          'El pago fue rechazado. Cambia la tarjeta o vuelve a intentarlo.',
      'frozenNoCard': 'Añade una tarjeta para restaurar esta visita.',
      'frozenAuthTimeout':
          'El plazo de confirmación venció. Vuelve a intentar el pago.',
      'retryPayment': 'Restaurar pago',
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
      'surveyTitle': 'AYÚDANOS A MEJORAR',
      'surveyBody':
          'Unas respuestas rápidas nos ayudarán a mejorar el servicio.',
      'surveyCleaningQuality': 'Calidad de la limpieza',
      'surveyPunctuality': 'Puntualidad del equipo',
      'surveyCommunication': 'Comunicación y amabilidad',
      'surveyConvenience': 'Comodidad del servicio',
      'surveyComment': '¿Qué podemos mejorar? (opcional)',
      'surveyCommentHint': 'Comparte tus sugerencias',
      'surveySubmit': 'Enviar opinión',
      'surveySkip': 'Ahora no',
      'surveySubmitFailed':
          'No se pudo enviar la encuesta. Inténtalo de nuevo.',
      'profileSettingsSection': 'AJUSTES',
      'paymentCardSection': 'TARJETA',
      'paymentCardNone': 'No hay tarjeta vinculada',
      'paymentCardExpiry': 'Cad {date}',
      'paymentCardUnlink': 'Desvincular tarjeta',
      'paymentCardAdd': 'Añadir tarjeta',
      'paymentCardUnlinkTitle': 'DESVINCULAR TARJETA',
      'paymentCardUnlinkConfirm':
          'La tarjeta se eliminará de Stripe y ya no quedará guardada en tu cuenta.',
      'paymentCardUnlinked': 'Tarjeta desvinculada',
      'paymentCardUnlinkFailed':
          'No se pudo desvincular la tarjeta. Inténtalo de nuevo.',
      'paymentCardUnlinkRequested':
          'La solicitud para desvincular la tarjeta se ha enviado al operador',
      'ok': 'OK',
      'supportSecuritySection': 'SOPORTE Y SEGURIDAD',
      'savedProperties': 'Propiedades guardadas',
      'cleaningHistory': 'Historial de limpiezas',
      'cleaningHistoryEmpty': 'Aún no hay limpiezas completadas',
      'cleaningHistoryLoadFailed': 'No se pudo cargar el historial',
      'faq': 'FAQ',
      'requests': 'Solicitudes',
      'newRequest': 'Nueva solicitud',
      'requestDetails': 'Detalles de la solicitud',
      'requestActive': 'Activas',
      'requestCompleted': 'Completadas',
      'requestAll': 'Todas',
      'requestsEmpty': 'Aún no hay solicitudes',
      'requestsLoadFailed': 'No se pudieron cargar las solicitudes',
      'feedbackPrompt': 'Cuéntanos cómo podemos ayudarte o mejorar.',
      'disputePrompt': 'Describe el problema con esta limpieza.',
      'requestMessageHint': 'Describe la situación…',
      'addPhotos': 'Añadir fotos',
      'photos': 'Fotos',
      'requestPhotos': 'Fotos ({count}/5)',
      'sendRequest': 'ENVIAR SOLICITUD',
      'requestSubmitFailed': 'No se pudo enviar. Inténtalo de nuevo.',
      'reportProblem': 'Informar de un problema',
      'problemReported': 'Problema informado',
      'reportProblemUntil': 'Disponible hasta {date}',
      'operatorUpdates': 'Actualizaciones del operador',
      'noOperatorUpdates': 'Aún no hay actualizaciones.',
      'contactSupport': 'Abrir chat de soporte',
      'relatedCleaning': 'Limpieza relacionada',
      'remediationCleaning': 'Limpieza correctiva',
      'resolution': 'Resolución',
      'generalFeedback': 'Comentario general',
      'cleaningDispute': 'Problema de limpieza',
      'requestStatusNew': 'Nueva',
      'requestStatusOpen': 'Abierta',
      'requestStatusInProgress': 'En curso',
      'requestStatusWaitingClient': 'Esperando tu respuesta',
      'requestStatusResolved': 'Resuelta',
      'requestStatusCompleted': 'Completada',
      'requestStatusClosed': 'Cerrada',
      'addProperty': 'Añadir propiedad',
      'editProperty': 'Editar propiedad',
      'fixProperty': 'Corregir',
      'saveProperty': 'Guardar',
      'propertiesEmpty': 'Aún no hay propiedades guardadas',
      'propertiesLoadFailed': 'No se pudieron cargar las propiedades',
      'propertyLoadFailed': 'No se pudo cargar la propiedad',
      'propertySaveFailed': 'No se pudo guardar la propiedad',
      'propertyTitleRequired': 'El título es obligatorio',
      'propertyHousingRequired':
          'Se requieren pies cuadrados, habitaciones y baños',
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
      'propertyAddressLine1': 'Dirección',
      'propertyAddressLine1Hint': '123 Main St',
      'propertyAddressLine2': 'Apto, suite, unidad',
      'propertyAddressLine2Hint': 'Apt 4B (opcional)',
      'propertyCity': 'Ciudad',
      'propertyState': 'Estado',
      'propertyZip': 'Código ZIP',
      'propertySelectState': 'Selecciona el estado',
      'propertyAddressRequired': 'Introduce calle, ciudad, estado y ZIP',
      'propertyZipInvalid': 'Introduce un ZIP de 5 dígitos',
      'propertyStepAddress': 'DIRECCIÓN',
      'propertyStepDescription': 'DATOS DE LA CASA',
      'propertyStepInstructions': 'INSTRUCCIONES',
      'propertyStepPhotos': 'NOMBRE Y FOTOS',
      'propertyInstructionsPhotosHint':
          'Si necesitas fotos de la casa o del acceso, puedes añadirlas en el siguiente paso.',
      'propertyBedroomsShort': 'hab',
      'propertyBathroomsShort': 'baños',
      'propertyDelete': 'Eliminar propiedad',
      'propertyDeleteTitle': 'ELIMINAR PROPIEDAD',
      'propertyDeleteConfirm':
          'Esta propiedad se eliminará de tu lista guardada.',
      'propertyDeleteFailed': 'No se pudo eliminar la propiedad.',
      'propertyMyTitle': 'MIS PROPIEDADES',
      'next': 'Siguiente',
      'payNow': 'Pagar',
      'securePaymentMethod': 'Método de pago seguro',
      'cardSetupHint':
          'No se te cobrará ahora. Tu tarjeta se guarda de forma segura en Stripe.',
      'cardSetupBefore': 'Añade una tarjeta para confirmar tu reserva.',
      'cardAlreadyLinked': 'Ya hay una tarjeta de pago vinculada a tu cuenta.',
      'cardSetupCancelled':
          'La configuración de la tarjeta se canceló. Añade una tarjeta para confirmar tu reserva.',
      'cardSetupPending': 'Esperando la confirmación de la tarjeta...',
      'cardSetupContinue': 'Continuar',
      'bookingStepOf': 'PASO {current} DE {total}',
      'bookingStepProperty': 'Propiedad',
      'bookingStepService': 'Servicio',
      'bookingStepAddons': 'Extras',
      'bookingAddonsTitle': '¿Quieres extras?',
      'bookingAddonsSubtitle':
          'Puedes elegir varios extras o saltar este paso.',
      'bookingAddonsNone': 'Ninguno',
      'bookingWindowsLabel': '¿Cuántas ventanas?',
      'bookingWindowsHint': 'Número de ventanas',
      'bookingWindowsRequired': 'Indica el número de ventanas',
      'bookingWindowsInside': 'Por dentro',
      'bookingWindowsOutside': 'Por fuera',
      'bookingWindowsSidesRequired': 'Elige por dentro, por fuera o ambas',
      'bookingWindowsFormula':
          '\$5 por dentro, \$10 por fuera, \$15 ambas — por ventana',
      'bookingEstimateTitle': 'Estimación preliminar',
      'bookingEstimateNote':
          'Esta es una estimación preliminar. El precio final puede cambiar después de la revisión del gerente.',
      'bookingEstimatePrice': 'Precio estimado',
      'bookingEstimateTime': 'Tiempo estimado',
      'bookingEstimateFailed': 'No se pudo calcular la estimación',
      'bookingSummaryAddons': 'Extras',
      'bookingHoursValue': '{hours} h',
      'bookingStepSchedule': 'Horario',
      'bookingStepWishes': 'Deseos',
      'bookingStepPayment': 'Confirmar',
      'bookingPropertyTitle': '¿Dónde limpiamos?',
      'bookingPropertySubtitle':
          'Elige una propiedad guardada o añade una nueva.',
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
      'bookingPaymentTitle': 'Revisar y confirmar',
      'bookingPaymentSubtitle': 'Añade una tarjeta para confirmar tu reserva.',
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
      'chatNotLinked':
          'Привяжите клиентский аккаунт, чтобы пользоваться чатом.',
      'welcomeBack': 'С ВОЗВРАЩЕНИЕМ',
      'hiName': 'Привет, {name}!',
      'hiGuest': 'Привет!',
      'homeTagline': 'Пора для следующего блеска вашего дома.',
      'bookNewCleaning': '+ Заказать клининг',
      'upcomingService': 'БЛИЖАЙШИЙ СЕРВИС',
      'currentService': 'ТЕКУЩИЙ СЕРВИС',
      'serviceNotOrdered': 'Сервис ещё не заказан.',
      'specialistRushing': '{name} уже спешит к вам',
      'specialistOnTheWayHint': 'Ваш клинер в пути',
      'trackingButton': 'Трекинг',
      'callOperator': 'Позвонить оператору',
      'operatorButton': 'Оператор',
      'callOperatorConfirmTitle': 'Позвонить оператору?',
      'callOperatorConfirmBody': 'Открыть телефон и позвонить {phone}?',
      'callOperatorConfirmAction': 'Позвонить',
      'updateAppTitle': 'Обновите приложение',
      'updateAppBody':
          'Эта версия больше не поддерживается. Установите последнюю версию из магазина.',
      'updateAppButton': 'Обновить',
      'trackingTitle': 'ТРЕКИНГ',
      'trackingLive': 'Онлайн',
      'trackingIdle': 'Ожидание',
      'trackingNoPoint': 'Геопозиция клинера пока недоступна.',
      'trackingLoadFailed': 'Не удалось загрузить геопозицию.',
      'stageAccepted': 'Принят',
      'stageOnTheWay': 'В пути',
      'stageCleaning': 'Уборка',
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
      'orderFrozen': 'ЗАКАЗ ЗАМОРОЖЕН',
      'frozenPaymentFailed':
          'Платёж отклонён. Замените карту или повторите оплату.',
      'frozenNoCard': 'Чтобы восстановить визит, добавьте платёжную карту.',
      'frozenAuthTimeout': 'Срок подтверждения оплаты истёк. Повторите оплату.',
      'retryPayment': 'Восстановить оплату',
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
      'surveyTitle': 'ПОМОГИТЕ НАМ СТАТЬ ЛУЧШЕ',
      'surveyBody': 'Несколько коротких ответов помогут нам улучшить сервис.',
      'surveyCleaningQuality': 'Качество уборки',
      'surveyPunctuality': 'Пунктуальность команды',
      'surveyCommunication': 'Общение и вежливость',
      'surveyConvenience': 'Удобство сервиса',
      'surveyComment': 'Что нам улучшить? (необязательно)',
      'surveyCommentHint': 'Поделитесь пожеланиями',
      'surveySubmit': 'Отправить отзыв',
      'surveySkip': 'Не сейчас',
      'surveySubmitFailed': 'Не удалось отправить анкету. Попробуйте ещё раз.',
      'profileSettingsSection': 'НАСТРОЙКИ',
      'paymentCardSection': 'ПЛАТЁЖНАЯ КАРТА',
      'paymentCardNone': 'Карта не привязана',
      'paymentCardExpiry': 'До {date}',
      'paymentCardUnlink': 'Отвязать карту',
      'paymentCardAdd': 'Добавить карту',
      'paymentCardUnlinkTitle': 'ОТВЯЗАТЬ КАРТУ',
      'paymentCardUnlinkConfirm':
          'Карта будет удалена в Stripe и больше не сохранится в аккаунте.',
      'paymentCardUnlinked': 'Карта отвязана',
      'paymentCardUnlinkFailed':
          'Не удалось отвязать карту. Попробуйте ещё раз.',
      'paymentCardUnlinkRequested':
          'Запрос на отвязывание карты отправлен оператору',
      'ok': 'ОК',
      'supportSecuritySection': 'ПОДДЕРЖКА И БЕЗОПАСНОСТЬ',
      'savedProperties': 'Сохранённые объекты',
      'cleaningHistory': 'История уборок',
      'cleaningHistoryEmpty': 'Завершённых уборок пока нет',
      'cleaningHistoryLoadFailed': 'Не удалось загрузить историю',
      'faq': 'FAQ',
      'requests': 'Обращения',
      'newRequest': 'Новое обращение',
      'requestDetails': 'Детали обращения',
      'requestActive': 'Активные',
      'requestCompleted': 'Завершённые',
      'requestAll': 'Все',
      'requestsEmpty': 'Обращений пока нет',
      'requestsLoadFailed': 'Не удалось загрузить обращения',
      'feedbackPrompt': 'Расскажите, как мы можем помочь или улучшить сервис.',
      'disputePrompt': 'Опишите проблему с этой уборкой.',
      'requestMessageHint': 'Опишите ситуацию…',
      'addPhotos': 'Добавить фото',
      'photos': 'Фото',
      'requestPhotos': 'Фото ({count}/5)',
      'sendRequest': 'ОТПРАВИТЬ',
      'requestSubmitFailed':
          'Не удалось отправить обращение. Попробуйте снова.',
      'reportProblem': 'Сообщить о проблеме',
      'problemReported': 'О проблеме сообщено',
      'reportProblemUntil': 'Доступно до {date}',
      'operatorUpdates': 'Обновления оператора',
      'noOperatorUpdates': 'Обновлений пока нет.',
      'contactSupport': 'Открыть чат поддержки',
      'relatedCleaning': 'Связанная уборка',
      'remediationCleaning': 'Повторная уборка',
      'resolution': 'Решение',
      'generalFeedback': 'Общий отзыв',
      'cleaningDispute': 'Проблема с уборкой',
      'requestStatusNew': 'Новое',
      'requestStatusOpen': 'Открыто',
      'requestStatusInProgress': 'В работе',
      'requestStatusWaitingClient': 'Ожидает вас',
      'requestStatusResolved': 'Решено',
      'requestStatusCompleted': 'Завершено',
      'requestStatusClosed': 'Закрыто',
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
      'propertyAddressLine1': 'Улица',
      'propertyAddressLine1Hint': '123 Main St',
      'propertyAddressLine2': 'Квартира, suite, unit',
      'propertyAddressLine2Hint': 'Apt 4B (необязательно)',
      'propertyCity': 'Город',
      'propertyState': 'Штат',
      'propertyZip': 'ZIP-код',
      'propertySelectState': 'Выберите штат',
      'propertyAddressRequired': 'Укажите улицу, город, штат и ZIP',
      'propertyZipInvalid': 'Введите 5-значный ZIP',
      'propertyStepAddress': 'АДРЕС',
      'propertyStepDescription': 'О ДОМЕ',
      'propertyStepInstructions': 'ИНСТРУКЦИИ',
      'propertyStepPhotos': 'НАЗВАНИЕ И ФОТО',
      'propertyInstructionsPhotosHint':
          'Если нужны фото дома или доступа, их можно добавить на следующем шаге.',
      'propertyBedroomsShort': 'сп.',
      'propertyBathroomsShort': 'ван.',
      'propertyDelete': 'Удалить объект',
      'propertyDeleteTitle': 'УДАЛИТЬ ОБЪЕКТ',
      'propertyDeleteConfirm': 'Объект будет удалён из сохранённых.',
      'propertyDeleteFailed': 'Не удалось удалить объект.',
      'propertyMyTitle': 'МОИ ОБЪЕКТЫ',
      'next': 'Далее',
      'payNow': 'Оплатить',
      'securePaymentMethod': 'Secure payment method',
      'cardSetupHint':
          'You will not be charged now. Your card is saved securely by Stripe.',
      'cardSetupBefore': 'Добавьте карту, чтобы подтвердить бронь.',
      'cardAlreadyLinked': 'A payment card is already linked to your account.',
      'cardSetupCancelled':
          'Card setup was cancelled. Please add a card to confirm your booking.',
      'cardSetupPending': 'Waiting for card confirmation...',
      'cardSetupContinue': 'Продолжить',
      'bookingStepOf': 'ШАГ {current} ИЗ {total}',
      'bookingStepProperty': 'Объект уборки',
      'bookingStepService': 'Тип уборки',
      'bookingStepAddons': 'Доп. услуги',
      'bookingAddonsTitle': 'Нужны допы?',
      'bookingAddonsSubtitle':
          'Можно выбрать несколько услуг или пропустить шаг.',
      'bookingAddonsNone': 'Не выбрано',
      'bookingWindowsLabel': 'Сколько окон?',
      'bookingWindowsHint': 'Количество окон',
      'bookingWindowsRequired': 'Укажите количество окон',
      'bookingWindowsInside': 'Изнутри',
      'bookingWindowsOutside': 'Снаружи',
      'bookingWindowsSidesRequired':
          'Выберите изнутри, снаружи или оба варианта',
      'bookingWindowsFormula':
          '\$5 изнутри, \$10 снаружи, \$15 и так и так — за одно окно',
      'bookingEstimateTitle': 'Предварительный расчёт',
      'bookingEstimateNote':
          'Это предварительный расчёт. Итоговая цена может измениться после проверки менеджером.',
      'bookingEstimatePrice': 'Ориентировочная цена',
      'bookingEstimateTime': 'Ориентировочное время',
      'bookingEstimateFailed': 'Не удалось посчитать смету',
      'bookingSummaryAddons': 'Доп. услуги',
      'bookingHoursValue': '{hours} ч',
      'bookingStepSchedule': 'Расписание',
      'bookingStepWishes': 'Пожелания',
      'bookingStepPayment': 'Подтверждение',
      'bookingPropertyTitle': 'Где убирать?',
      'bookingPropertySubtitle':
          'Выберите сохранённый объект или добавьте новый.',
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
      'bookingHoldFailed':
          'Не удалось зарезервировать время. Выберите другой слот.',
      'bookingHeld':
          'Время зарезервировано. Завершите заявку, чтобы сохранить слот.',
      'bookingWishesTitle': 'Особые пожелания?',
      'bookingWishesSubtitle': 'Укажите инструкции к уборке.',
      'bookingWishesHint':
          'например, больше внимания кухне, ключи под ковриком…',
      'bookingPaymentTitle': 'Проверка и подтверждение',
      'bookingPaymentSubtitle': 'Добавьте карту, чтобы подтвердить бронь.',
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
