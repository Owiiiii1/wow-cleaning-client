import 'package:wow_cleaning/services/api_client.dart';

class OrderServiceItem {
  OrderServiceItem({
    this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.kind,
  });

  final int? id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? kind;

  factory OrderServiceItem.fromJson(Map<String, dynamic> json) {
    return OrderServiceItem(
      id: (json['id'] as num?)?.toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      kind: json['kind']?.toString(),
    );
  }
}

class ScheduleOrder {
  ScheduleOrder({
    required this.id,
    this.type,
    required this.serviceName,
    this.propertyTitle,
    this.clientPropertyId,
    this.propertyImageUrl,
    this.propertyDescription,
    this.squareFootage,
    this.bedrooms,
    this.bathrooms,
    this.windowCount,
    this.windowsInside = false,
    this.windowsOutside = false,
    this.recurrence,
    this.service,
    this.addons = const [],
    this.addonCount = 0,
    this.addonTitles = const [],
    this.status,
    this.paymentStatus,
    this.date,
    this.startTime,
    this.endTime,
    this.address,
    this.notes,
    this.hoursDuration,
    this.amount,
    this.operatorConfirmed = false,
    this.canPay = false,
    this.canCancel = false,
    this.canReschedule = false,
    this.canOpenDispute = false,
    this.disputeDeadlineAt,
    this.activeDispute,
    this.rating,
    this.locationTrackingActive = false,
    this.isFrozen = false,
    this.freezeReasonCode,
    this.freezeReasonText,
    this.paymentActionRequiredBy,
  });

  final int id;
  final String? type;
  final String serviceName;
  final String? propertyTitle;
  final int? clientPropertyId;
  final String? propertyImageUrl;
  final String? propertyDescription;
  final int? squareFootage;
  final int? bedrooms;
  final int? bathrooms;
  final int? windowCount;
  final bool windowsInside;
  final bool windowsOutside;
  final String? recurrence;
  final OrderServiceItem? service;
  final List<OrderServiceItem> addons;
  final int addonCount;
  final List<String> addonTitles;
  final String? status;
  final String? paymentStatus;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? address;
  final String? notes;
  final dynamic hoursDuration;
  final dynamic amount;
  final bool operatorConfirmed;
  final bool canPay;
  final bool canCancel;
  final bool canReschedule;
  final bool canOpenDispute;
  final String? disputeDeadlineAt;
  final Map<String, dynamic>? activeDispute;
  final int? rating;
  final bool locationTrackingActive;
  final bool isFrozen;
  final String? freezeReasonCode;
  final String? freezeReasonText;
  final String? paymentActionRequiredBy;

  factory ScheduleOrder.fromJson(Map<String, dynamic> json) {
    final actions = json['available_actions'] is Map
        ? Map<String, dynamic>.from(json['available_actions'] as Map)
        : <String, dynamic>{};
    final addonTitles = <String>[];
    final rawAddonTitles = json['addon_titles'];
    if (rawAddonTitles is List) {
      for (final item in rawAddonTitles) {
        final title = item?.toString().trim() ?? '';
        if (title.isNotEmpty) addonTitles.add(title);
      }
    }
    final addons = <OrderServiceItem>[];
    final rawAddons = json['addons'];
    if (rawAddons is List) {
      for (final item in rawAddons) {
        if (item is Map) {
          addons.add(
            OrderServiceItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    final serviceRaw = json['service'];
    final service = serviceRaw is Map
        ? OrderServiceItem.fromJson(Map<String, dynamic>.from(serviceRaw))
        : null;

    return ScheduleOrder(
      id: (json['id'] as num).toInt(),
      type: json['type']?.toString(),
      serviceName:
          json['service_name']?.toString() ??
          json['title']?.toString() ??
          service?.title ??
          '',
      propertyTitle: json['property_title']?.toString(),
      clientPropertyId: (json['client_property_id'] as num?)?.toInt(),
      propertyImageUrl: json['property_image_url']?.toString(),
      propertyDescription: json['property_description']?.toString(),
      squareFootage: (json['square_footage'] as num?)?.toInt(),
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      windowCount: (json['window_count'] as num?)?.toInt(),
      windowsInside:
          json['windows_inside'] == true || json['windows_inside'] == 1,
      windowsOutside:
          json['windows_outside'] == true || json['windows_outside'] == 1,
      recurrence: json['recurrence']?.toString(),
      service: service,
      addons: addons,
      addonCount:
          (json['addon_count'] as num?)?.toInt() ??
          (addons.isNotEmpty ? addons.length : addonTitles.length),
      addonTitles: addonTitles,
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      date: json['date']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      address: json['address']?.toString(),
      notes: json['notes']?.toString(),
      hoursDuration: json['hours_duration'],
      amount: json['amount'],
      operatorConfirmed: json['operator_confirmed'] == true,
      canPay: json['can_pay'] == true,
      canCancel: json['can_cancel'] == true,
      canReschedule: json['can_reschedule'] == true,
      canOpenDispute:
          json['can_open_dispute'] == true ||
          actions['can_open_dispute'] == true,
      disputeDeadlineAt:
          (json['dispute_deadline_at'] ?? actions['dispute_deadline_at'])
              ?.toString(),
      activeDispute:
          (json['active_dispute'] ?? actions['active_dispute']) is Map
          ? Map<String, dynamic>.from(
              (json['active_dispute'] ?? actions['active_dispute']) as Map,
            )
          : null,
      rating: (json['rating'] as num?)?.toInt(),
      locationTrackingActive:
          json['location_tracking_active'] == true ||
          json['location_tracking_active'] == 1,
      isFrozen: json['is_frozen'] == true || json['is_frozen'] == 1,
      freezeReasonCode: json['freeze_reason_code']?.toString(),
      freezeReasonText: json['freeze_reason_text']?.toString(),
      paymentActionRequiredBy: json['payment_action_required_by']?.toString(),
    );
  }
}

class ScheduleData {
  ScheduleData({
    required this.requests,
    required this.orders,
    required this.recurring,
  });

  final List<ScheduleOrder> requests;
  final List<ScheduleOrder> orders;
  final List<ScheduleOrder> recurring;
}

class OrderDetailData {
  OrderDetailData({
    required this.order,
    required this.statusTimeline,
    required this.paymentSummary,
  });

  final ScheduleOrder order;
  final List<Map<String, dynamic>> statusTimeline;
  final Map<String, dynamic> paymentSummary;
}

class ScheduleApi {
  ScheduleApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<ScheduleData> fetchSchedule() async {
    final payload = await _client.getJson('client/schedule');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return ScheduleData(
      requests: _parseList(data['requests']),
      orders: _parseList(data['orders']),
      recurring: _parseList(data['recurring']),
    );
  }

  Future<List<ScheduleOrder>> fetchHistory() async {
    final payload = await _client.getJson('client/orders/history');
    return _parseList(payload['data']);
  }

  Future<OrderDetailData> fetchOrderDetail(int id) async {
    final payload = await _client.getJson('client/orders/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final orderRaw = data['order'] as Map<String, dynamic>? ?? {};
    final timeline = <Map<String, dynamic>>[];
    final rawTimeline = data['status_timeline'];
    if (rawTimeline is List) {
      for (final item in rawTimeline) {
        if (item is Map<String, dynamic>) timeline.add(item);
      }
    }
    final payment = data['payment_summary'] is Map<String, dynamic>
        ? data['payment_summary'] as Map<String, dynamic>
        : <String, dynamic>{};

    final actions = data['available_actions'];
    if (actions is Map) {
      orderRaw['can_cancel'] ??= actions['can_cancel'];
      orderRaw['can_pay'] ??= actions['can_pay'];
      orderRaw['can_reschedule'] ??= actions['can_reschedule'];
      orderRaw['can_open_dispute'] ??= actions['can_open_dispute'];
      orderRaw['dispute_deadline_at'] ??= actions['dispute_deadline_at'];
      orderRaw['active_dispute'] ??= actions['active_dispute'];
    }

    return OrderDetailData(
      order: ScheduleOrder.fromJson(orderRaw),
      statusTimeline: timeline,
      paymentSummary: payment,
    );
  }

  Future<void> deleteRequest(int id) async {
    await _client.deleteJson('client/orders/$id');
  }

  Future<Map<String, dynamic>> paymentAction(int id) async {
    final payload = await _client.postJson(
      'client/orders/$id/payment-action',
      {},
    );
    return (payload['data'] as Map?)?.cast<String, dynamic>() ?? {};
  }

  Future<String> retryPayment(int id) async {
    final payload = await _client.postJson(
      'client/orders/$id/payment-retry',
      {},
    );
    final data = (payload['data'] as Map?)?.cast<String, dynamic>() ?? {};
    return data['status']?.toString() ?? 'scheduled';
  }

  Future<String> confirmPaymentAction(int id) async {
    final payload = await _client.postJson(
      'client/orders/$id/payment-action/confirm',
      {},
    );
    final data = (payload['data'] as Map?)?.cast<String, dynamic>() ?? {};
    return data['status']?.toString() ?? 'pending';
  }

  List<ScheduleOrder> _parseList(dynamic raw) {
    final list = <ScheduleOrder>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          list.add(ScheduleOrder.fromJson(item));
        }
      }
    }
    return list;
  }
}
