import 'package:wow_cleaning/services/api_client.dart';

class BookingSubmitResult {
  BookingSubmitResult({required this.requestId, required this.status});

  final int requestId;
  final String status;
}

class BookingApi {
  BookingApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<BookingSubmitResult> createRequest({
    required int clientPropertyId,
    required int cleaningServiceId,
    required String scheduleType,
    String? recurrence,
    required String requestedDate,
    required String requestedTime,
    String? notes,
  }) async {
    final payload = await _client.postJson(
      'client/booking-requests',
      {
        'client_property_id': clientPropertyId,
        'cleaning_service_id': cleaningServiceId,
        'schedule_type': scheduleType,
        if (recurrence != null) 'recurrence': recurrence,
        'requested_date': requestedDate,
        'requested_time': requestedTime,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        'payment_mode': 'fake',
      },
    );

    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return BookingSubmitResult(
      requestId: (data['request_id'] as num).toInt(),
      status: data['status']?.toString() ?? 'new',
    );
  }
}
