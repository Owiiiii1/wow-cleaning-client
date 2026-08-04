import 'package:wow_cleaning/services/api_client.dart';

class ScheduleOrder {
  ScheduleOrder({
    required this.id,
    this.type,
    required this.serviceName,
    this.status,
    this.paymentStatus,
    this.date,
    this.startTime,
    this.endTime,
    this.address,
    this.assignedTeam,
    this.cleanerName,
    this.title,
    this.hoursDuration,
    this.cleanerInstructions,
    this.canPay = false,
    this.canCancel = false,
    this.canReschedule = false,
  });

  final int id;
  final String? type;
  final String serviceName;
  final String? status;
  final String? paymentStatus;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? address;
  final String? assignedTeam;
  final String? cleanerName;
  final String? title;
  final dynamic hoursDuration;
  final String? cleanerInstructions;
  final bool canPay;
  final bool canCancel;
  final bool canReschedule;

  factory ScheduleOrder.fromJson(Map<String, dynamic> json) {
    return ScheduleOrder(
      id: (json['id'] as num).toInt(),
      type: json['type']?.toString(),
      serviceName: json['service_name']?.toString() ??
          json['title']?.toString() ??
          '',
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      date: json['date']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      address: json['address']?.toString(),
      assignedTeam: json['assigned_team']?.toString(),
      cleanerName: json['cleaner_name']?.toString(),
      title: json['title']?.toString(),
      hoursDuration: json['hours_duration'],
      cleanerInstructions: json['cleaner_instructions']?.toString(),
      canPay: json['can_pay'] == true,
      canCancel: json['can_cancel'] == true,
      canReschedule: json['can_reschedule'] == true,
    );
  }
}

class ScheduleData {
  ScheduleData({
    required this.thisWeek,
    required this.future,
    required this.recurring,
  });

  final List<ScheduleOrder> thisWeek;
  final List<ScheduleOrder> future;
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
      thisWeek: _parseList(data['this_week']),
      future: _parseList(data['future']),
      recurring: _parseList(data['recurring']),
    );
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

    return OrderDetailData(
      order: ScheduleOrder.fromJson(orderRaw),
      statusTimeline: timeline,
      paymentSummary: payment,
    );
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
