import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/services/services_api.dart';

enum BookingScheduleType { oneTime, recurring }

enum BookingRecurrence { weekly, biweekly, monthly }

class BookingState {
  ClientPropertyItem? property;
  CleaningServiceItem? service;
  BookingScheduleType scheduleType = BookingScheduleType.oneTime;
  BookingRecurrence recurrence = BookingRecurrence.weekly;
  DateTime? date;
  TimeOfDayValue? time;
  String notes = '';

  bool get canGoStep1 => property != null;
  bool get canGoStep2 => service != null;
  bool get canGoStep3 => date != null && time != null;
  bool get canGoStep4 => true;

  String get scheduleTypeApi =>
      scheduleType == BookingScheduleType.oneTime ? 'one_time' : 'recurring';

  String? get recurrenceApi {
    if (scheduleType != BookingScheduleType.recurring) return null;
    return switch (recurrence) {
      BookingRecurrence.weekly => 'weekly',
      BookingRecurrence.biweekly => 'biweekly',
      BookingRecurrence.monthly => 'monthly',
    };
  }

  String? get dateApi {
    final d = date;
    if (d == null) return null;
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String? get timeApi {
    final t = time;
    if (t == null) return null;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class TimeOfDayValue {
  const TimeOfDayValue({required this.hour, required this.minute});

  final int hour;
  final int minute;
}
