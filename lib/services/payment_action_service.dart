import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/services/stripe_payment_coordinator.dart';

class PaymentActionService {
  PaymentActionService({ScheduleApi? orders, StripePaymentCoordinator? stripe})
    : _orders = orders ?? ScheduleApi(),
      _stripe = stripe ?? StripePaymentCoordinator();

  final ScheduleApi _orders;
  final StripePaymentCoordinator _stripe;

  Future<String> confirm(int orderId) async {
    final action = await _orders.paymentAction(orderId);
    final secret = action['payment_intent_client_secret']?.toString();
    final key = action['publishable_key']?.toString();
    if (secret == null || key == null) {
      throw StateError('Payment confirmation data is incomplete');
    }

    await _stripe.confirmPayment(clientSecret: secret, publishableKey: key);

    return _orders.confirmPaymentAction(orderId);
  }
}
