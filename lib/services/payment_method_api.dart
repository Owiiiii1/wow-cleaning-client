import 'package:wow_cleaning/services/api_client.dart';

class SavedPaymentMethod {
  const SavedPaymentMethod({
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
  });

  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;

  String get displayLabel {
    final brandLabel = (brand ?? 'Card').trim();
    final pretty = brandLabel.isEmpty
        ? 'Card'
        : '${brandLabel[0].toUpperCase()}${brandLabel.substring(1)}';
    if (last4 == null || last4!.isEmpty) return pretty;
    return '$pretty •••• $last4';
  }

  String? get expiryLabel {
    if (expMonth == null || expYear == null) return null;
    final month = expMonth.toString().padLeft(2, '0');
    return '$month/$expYear';
  }

  factory SavedPaymentMethod.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SavedPaymentMethod();
    }
    return SavedPaymentMethod(
      brand: json['brand']?.toString(),
      last4: json['last4']?.toString(),
      expMonth: (json['exp_month'] as num?)?.toInt(),
      expYear: (json['exp_year'] as num?)?.toInt(),
    );
  }
}

class PaymentMethodStatus {
  const PaymentMethodStatus({
    required this.hasCard,
    this.paymentMethod,
    this.message,
    this.checkoutUrl,
    this.sessionId,
    this.setupIntentClientSecret,
    this.setupIntentId,
    this.publishableKey,
  });

  final bool hasCard;
  final SavedPaymentMethod? paymentMethod;
  final String? message;
  final String? checkoutUrl;
  final String? sessionId;
  final String? setupIntentClientSecret;
  final String? setupIntentId;
  final String? publishableKey;

  factory PaymentMethodStatus.fromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final rawMethod = map['payment_method'];
    return PaymentMethodStatus(
      hasCard: map['has_card'] == true || map['has_card'] == 1,
      paymentMethod: rawMethod is Map
          ? SavedPaymentMethod.fromJson(Map<String, dynamic>.from(rawMethod))
          : null,
      message: (map['message'] ?? response['message'])?.toString(),
      checkoutUrl: map['checkout_url']?.toString(),
      sessionId: map['session_id']?.toString(),
      setupIntentClientSecret: map['setup_intent_client_secret']?.toString(),
      setupIntentId: map['setup_intent_id']?.toString(),
      publishableKey: map['publishable_key']?.toString(),
    );
  }
}

class PaymentMethodApi {
  PaymentMethodApi({ApiClient? client}) : _api = client ?? ApiClient();

  final ApiClient _api;

  Future<PaymentMethodStatus> fetch() async {
    final response = await _api.getJson('client/payment-method');
    return PaymentMethodStatus.fromResponse(response);
  }

  Future<PaymentMethodStatus> confirmSession(String sessionId) async {
    final response = await _api.postJson(
      'client/payment-method/confirm-session',
      {'session_id': sessionId},
    );
    return PaymentMethodStatus.fromResponse(response);
  }

  Future<PaymentMethodStatus> createSetupSession() async {
    final response = await _api.postJson(
      'client/payment-method/setup-session',
      {},
    );
    return PaymentMethodStatus.fromResponse(response);
  }

  Future<PaymentMethodStatus> createSetupIntent() async {
    final response = await _api.postJson(
      'client/payment-method/setup-intent',
      {},
    );
    return PaymentMethodStatus.fromResponse(response);
  }

  Future<PaymentMethodStatus> confirmSetupIntent(String setupIntentId) async {
    final response = await _api.postJson(
      'client/payment-method/confirm-setup-intent',
      {'setup_intent_id': setupIntentId},
    );
    return PaymentMethodStatus.fromResponse(response);
  }

  Future<PaymentMethodStatus> unlink() async {
    final response = await _api.deleteJson('client/payment-method');
    return PaymentMethodStatus.fromResponse(response);
  }
}
