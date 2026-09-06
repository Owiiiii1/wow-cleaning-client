import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wow_cleaning/services/payment_method_api.dart';

class StripePaymentCoordinator {
  StripePaymentCoordinator({PaymentMethodApi? paymentMethods})
    : _paymentMethods = paymentMethods ?? PaymentMethodApi();

  final PaymentMethodApi _paymentMethods;

  Future<PaymentMethodStatus> setupCard() async {
    final setup = await _paymentMethods.createSetupIntent();
    if (setup.hasCard) return setup;

    final secret = setup.setupIntentClientSecret;
    final intentId = setup.setupIntentId;
    final key = setup.publishableKey;
    if (secret == null || intentId == null || key == null) {
      throw StateError('Stripe setup data is incomplete');
    }

    await _configure(key);
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: secret,
        merchantDisplayName: 'WOW NOW',
        style: ThemeMode.system,
      ),
    );
    await Stripe.instance.presentPaymentSheet();

    return _paymentMethods.confirmSetupIntent(intentId);
  }

  Future<void> confirmPayment({
    required String clientSecret,
    required String publishableKey,
  }) async {
    await _configure(publishableKey);
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'WOW NOW',
        style: ThemeMode.system,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  Future<void> _configure(String publishableKey) async {
    if (Stripe.publishableKey == publishableKey) return;
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.wownowcleaning.client';
    await Stripe.instance.applySettings();
  }
}
