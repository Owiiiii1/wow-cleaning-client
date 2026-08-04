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
  String get scheduleSectionEmpty => _t('scheduleSectionEmpty');
  String get scheduleLoadFailed => _t('scheduleLoadFailed');
  String get cleaningDetails => _t('cleaningDetails');
  String get orderLoadFailed => _t('orderLoadFailed');
  String get dateLabel => _t('dateLabel');
  String get timeLabel => _t('timeLabel');
  String get paymentStatusLabel => _t('paymentStatusLabel');
  String get typeLabel => _t('typeLabel');
  String get specialistLabel => _t('specialistLabel');
  String get durationLabel => _t('durationLabel');
  String get instructionsLabel => _t('instructionsLabel');
  String get statusTimelineLabel => _t('statusTimelineLabel');
  String get profileSettingsSection => _t('profileSettingsSection');
  String get supportSecuritySection => _t('supportSecuritySection');
  String get savedProperties => _t('savedProperties');
  String get cleaningHistory => _t('cleaningHistory');
  String get faq => _t('faq');
  String get addProperty => _t('addProperty');
  String get saveProperty => _t('saveProperty');
  String get propertiesEmpty => _t('propertiesEmpty');
  String get propertiesLoadFailed => _t('propertiesLoadFailed');
  String get propertyLoadFailed => _t('propertyLoadFailed');
  String get propertySaveFailed => _t('propertySaveFailed');
  String get propertyTitleRequired => _t('propertyTitleRequired');
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
      'scheduleSectionEmpty': 'Nothing here yet',
      'scheduleLoadFailed': 'Failed to load schedule',
      'cleaningDetails': 'Cleaning details',
      'orderLoadFailed': 'Failed to load cleaning',
      'dateLabel': 'Date',
      'timeLabel': 'Time',
      'paymentStatusLabel': 'Payment',
      'typeLabel': 'Type',
      'specialistLabel': 'Specialist',
      'durationLabel': 'Duration (h)',
      'instructionsLabel': 'Instructions',
      'statusTimelineLabel': 'Status timeline',
      'profileSettingsSection': 'SETTINGS',
      'supportSecuritySection': 'SUPPORT & SECURITY',
      'savedProperties': 'Saved properties',
      'cleaningHistory': 'Cleaning history',
      'faq': 'FAQ',
      'addProperty': 'Add property',
      'saveProperty': 'Save',
      'propertiesEmpty': 'No saved properties yet',
      'propertiesLoadFailed': 'Failed to load properties',
      'propertyLoadFailed': 'Failed to load property',
      'propertySaveFailed': 'Failed to save property',
      'propertyTitleRequired': 'Title is required',
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
      'bookingStepSchedule': 'Schedule',
      'bookingStepWishes': 'Special wishes',
      'bookingStepPayment': 'Payment',
      'bookingPropertyTitle': 'Where should we clean?',
      'bookingPropertySubtitle': 'Select a saved property or add a new one.',
      'bookingServiceTitle': 'What needs a glow-up?',
      'bookingServiceSubtitle': 'Select the cleaning service that best fits your needs.',
      'bookingScheduleTitle': 'When should we come?',
      'bookingScheduleSubtitle': 'Pick a preferred date and time.',
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
      'scheduleSectionEmpty': 'Поки порожньо',
      'scheduleLoadFailed': 'Не вдалося завантажити розклад',
      'cleaningDetails': 'Деталі прибирання',
      'orderLoadFailed': 'Не вдалося завантажити прибирання',
      'dateLabel': 'Дата',
      'timeLabel': 'Час',
      'paymentStatusLabel': 'Оплата',
      'typeLabel': 'Тип',
      'specialistLabel': 'Спеціаліст',
      'durationLabel': 'Тривалість (год)',
      'instructionsLabel': 'Інструкції',
      'statusTimelineLabel': 'Історія статусів',
      'profileSettingsSection': 'НАЛАШТУВАННЯ',
      'supportSecuritySection': 'ПІДТРИМКА ТА БЕЗПЕКА',
      'savedProperties': 'Збережені обʼєкти',
      'cleaningHistory': 'Історія прибирань',
      'faq': 'FAQ',
      'addProperty': 'Додати обʼєкт',
      'saveProperty': 'Зберегти',
      'propertiesEmpty': 'Поки немає збережених обʼєктів',
      'propertiesLoadFailed': 'Не вдалося завантажити обʼєкти',
      'propertyLoadFailed': 'Не вдалося завантажити обʼєкт',
      'propertySaveFailed': 'Не вдалося зберегти обʼєкт',
      'propertyTitleRequired': 'Вкажіть назву',
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
      'bookingStepSchedule': 'Розклад',
      'bookingStepWishes': 'Побажання',
      'bookingStepPayment': 'Оплата',
      'bookingPropertyTitle': 'Де прибирати?',
      'bookingPropertySubtitle': 'Оберіть збережений обʼєкт або додайте новий.',
      'bookingServiceTitle': 'Яка уборка потрібна?',
      'bookingServiceSubtitle': 'Оберіть тип послуги.',
      'bookingScheduleTitle': 'Коли приїхати?',
      'bookingScheduleSubtitle': 'Оберіть бажану дату та час.',
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
      'scheduleSectionEmpty': 'Aún vacío',
      'scheduleLoadFailed': 'No se pudo cargar el horario',
      'cleaningDetails': 'Detalles de la limpieza',
      'orderLoadFailed': 'No se pudo cargar la limpieza',
      'dateLabel': 'Fecha',
      'timeLabel': 'Hora',
      'paymentStatusLabel': 'Pago',
      'typeLabel': 'Tipo',
      'specialistLabel': 'Especialista',
      'durationLabel': 'Duración (h)',
      'instructionsLabel': 'Instrucciones',
      'statusTimelineLabel': 'Historial de estados',
      'profileSettingsSection': 'AJUSTES',
      'supportSecuritySection': 'SOPORTE Y SEGURIDAD',
      'savedProperties': 'Propiedades guardadas',
      'cleaningHistory': 'Historial de limpiezas',
      'faq': 'FAQ',
      'addProperty': 'Añadir propiedad',
      'saveProperty': 'Guardar',
      'propertiesEmpty': 'Aún no hay propiedades guardadas',
      'propertiesLoadFailed': 'No se pudieron cargar las propiedades',
      'propertyLoadFailed': 'No se pudo cargar la propiedad',
      'propertySaveFailed': 'No se pudo guardar la propiedad',
      'propertyTitleRequired': 'El título es obligatorio',
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
      'bookingStepSchedule': 'Horario',
      'bookingStepWishes': 'Deseos',
      'bookingStepPayment': 'Pago',
      'bookingPropertyTitle': '¿Dónde limpiamos?',
      'bookingPropertySubtitle': 'Elige una propiedad guardada o añade una nueva.',
      'bookingServiceTitle': '¿Qué servicio necesitas?',
      'bookingServiceSubtitle': 'Selecciona el tipo de limpieza.',
      'bookingScheduleTitle': '¿Cuándo vamos?',
      'bookingScheduleSubtitle': 'Elige fecha y hora preferidas.',
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
      'scheduleSectionEmpty': 'Пока пусто',
      'scheduleLoadFailed': 'Не удалось загрузить расписание',
      'cleaningDetails': 'Детали уборки',
      'orderLoadFailed': 'Не удалось загрузить уборку',
      'dateLabel': 'Дата',
      'timeLabel': 'Время',
      'paymentStatusLabel': 'Оплата',
      'typeLabel': 'Тип',
      'specialistLabel': 'Специалист',
      'durationLabel': 'Длительность (ч)',
      'instructionsLabel': 'Инструкции',
      'statusTimelineLabel': 'История статусов',
      'profileSettingsSection': 'НАСТРОЙКИ',
      'supportSecuritySection': 'ПОДДЕРЖКА И БЕЗОПАСНОСТЬ',
      'savedProperties': 'Сохранённые объекты',
      'cleaningHistory': 'История уборок',
      'faq': 'FAQ',
      'addProperty': 'Добавить объект',
      'saveProperty': 'Сохранить',
      'propertiesEmpty': 'Пока нет сохранённых объектов',
      'propertiesLoadFailed': 'Не удалось загрузить объекты',
      'propertyLoadFailed': 'Не удалось загрузить объект',
      'propertySaveFailed': 'Не удалось сохранить объект',
      'propertyTitleRequired': 'Укажите название',
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
      'bookingStepSchedule': 'Расписание',
      'bookingStepWishes': 'Пожелания',
      'bookingStepPayment': 'Оплата',
      'bookingPropertyTitle': 'Где убирать?',
      'bookingPropertySubtitle': 'Выберите сохранённый объект или добавьте новый.',
      'bookingServiceTitle': 'Какая уборка нужна?',
      'bookingServiceSubtitle': 'Выберите тип услуги.',
      'bookingScheduleTitle': 'Когда приехать?',
      'bookingScheduleSubtitle': 'Выберите желаемые дату и время.',
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
