import 'package:wow_cleaning/services/api_client.dart';

class BookingSubmitResult {
  BookingSubmitResult({required this.requestId, required this.status});

  final int requestId;
  final String status;
}

class BookingQuote {
  BookingQuote({
    required this.price,
    required this.currency,
    required this.hours,
    required this.minutes,
    required this.isEstimate,
  });

  final double price;
  final String currency;
  final double hours;
  final int minutes;
  final bool isEstimate;

  factory BookingQuote.fromJson(Map<String, dynamic> json) {
    return BookingQuote(
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
      hours: (json['hours'] as num?)?.toDouble() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      isEstimate: json['is_estimate'] == true || json['is_estimate'] == 1,
    );
  }
}

class AvailabilityWindow {
  AvailabilityWindow({
    required this.startTime,
    required this.endTime,
    required this.slotHours,
    required this.availableStaff,
    required this.needsPreferredStart,
    required this.latestStartTime,
    this.preferredStarts = const [],
    this.pauseMinutes = 0,
  });

  final String startTime;
  final String endTime;
  final double slotHours;
  final int availableStaff;
  final bool needsPreferredStart;
  final String latestStartTime;
  final List<String> preferredStarts;
  final int pauseMinutes;

  bool sameAs(AvailabilityWindow other) =>
      startTime == other.startTime && endTime == other.endTime;

  factory AvailabilityWindow.fromJson(Map<String, dynamic> json) {
    final rawStarts = json['preferred_starts'];
    return AvailabilityWindow(
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      slotHours: (json['slot_hours'] as num?)?.toDouble() ?? 0,
      availableStaff: (json['available_staff'] as num?)?.toInt() ?? 1,
      needsPreferredStart: json['needs_preferred_start'] == true ||
          json['needs_preferred_start'] == 1,
      latestStartTime: json['latest_start_time']?.toString() ?? '',
      preferredStarts: rawStarts is List
          ? rawStarts.map((item) => item.toString()).toList()
          : const [],
      pauseMinutes: (json['pause_minutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class BookingHold {
  BookingHold({
    required this.holdId,
    required this.startTime,
    required this.endTime,
    this.expiresAt,
  });

  final int holdId;
  final String startTime;
  final String endTime;
  final DateTime? expiresAt;

  factory BookingHold.fromJson(Map<String, dynamic> json) {
    return BookingHold(
      holdId: (json['hold_id'] as num).toInt(),
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? ''),
    );
  }
}

class AvailabilityResult {
  AvailabilityResult({required this.available, required this.windows});

  final bool available;
  final List<AvailabilityWindow> windows;

  factory AvailabilityResult.fromJson(Map<String, dynamic> json) {
    final raw = json['windows'];
    return AvailabilityResult(
      available: json['available'] == true || json['available'] == 1,
      windows: raw is List
          ? raw
              .whereType<Map>()
              .map((item) => AvailabilityWindow.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList()
          : const [],
    );
  }
}

class BookingApi {
  BookingApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<BookingQuote> quote({
    required int clientPropertyId,
    required int cleaningServiceId,
    List<int> addonServiceIds = const [],
    int windowCount = 0,
  }) async {
    final payload = await _client.postJson(
      'client/quotes',
      {
        'client_property_id': clientPropertyId,
        'cleaning_service_id': cleaningServiceId,
        'addon_service_ids': addonServiceIds,
        'window_count': windowCount,
      },
    );
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return BookingQuote.fromJson(data);
  }

  Future<AvailabilityResult> checkAvailability({
    required String date,
    required double durationHours,
    int staffCount = 1,
    int? ignoreHoldId,
  }) async {
    final payload = await _client.postJson(
      'client/availability',
      {
        'date': date,
        'duration_hours': durationHours,
        'staff_count': staffCount,
        if (ignoreHoldId != null) 'ignore_hold_id': ignoreHoldId,
      },
    );
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return AvailabilityResult.fromJson(data);
  }

  Future<BookingHold> reserveHold({
    required String date,
    required String startTime,
    required double durationHours,
    int staffCount = 1,
    int? replaceHoldId,
  }) async {
    final payload = await _client.postJson(
      'client/availability/holds',
      {
        'date': date,
        'start_time': startTime,
        'duration_hours': durationHours,
        'staff_count': staffCount,
        if (replaceHoldId != null) 'replace_hold_id': replaceHoldId,
      },
    );
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return BookingHold.fromJson(data);
  }

  Future<void> cancelHold(int holdId) async {
    await _client.deleteJson('client/availability/holds/$holdId');
  }

  Future<BookingSubmitResult> createRequest({
    required int clientPropertyId,
    required int cleaningServiceId,
    List<int> addonServiceIds = const [],
    int windowCount = 0,
    required String scheduleType,
    String? recurrence,
    required String requestedDate,
    required String requestedTime,
    required int holdId,
    String? notes,
  }) async {
    final payload = await _client.postJson(
      'client/booking-requests',
      {
        'client_property_id': clientPropertyId,
        'cleaning_service_id': cleaningServiceId,
        'addon_service_ids': addonServiceIds,
        'window_count': windowCount,
        'schedule_type': scheduleType,
        'recurrence': ?recurrence,
        'requested_date': requestedDate,
        'requested_time': requestedTime,
        'hold_id': holdId,
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
