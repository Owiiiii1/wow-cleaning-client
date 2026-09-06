import 'package:wow_cleaning/services/booking_api.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/services/services_api.dart';

enum BookingScheduleType { oneTime, recurring }

enum BookingRecurrence { weekly, biweekly, monthly }

class BookingState {
  ClientPropertyItem? property;
  CleaningServiceItem? service;
  final List<CleaningServiceItem> addons = [];
  int windowCount = 0;
  bool windowsInside = false;
  bool windowsOutside = false;
  BookingQuote? quote;
  BookingScheduleType scheduleType = BookingScheduleType.oneTime;
  BookingRecurrence recurrence = BookingRecurrence.weekly;
  DateTime? date;
  TimeOfDayValue? time;
  int? holdId;
  AvailabilityWindow? selectedWindow;
  List<AvailabilityWindow> windows = [];
  bool availabilityChecked = false;
  String notes = '';

  bool get canGoProperty => property != null && property!.hasHousingParams;
  bool get canGoService => service != null;
  bool get canGoAddons =>
      !hasWindowCleaning || (windowCount > 0 && hasWindowSides);
  bool get canGoSchedule =>
      date != null && holdId != null && selectedWindow != null && time != null;

  void clearAvailability() {
    windows = [];
    selectedWindow = null;
    holdId = null;
    time = null;
    availabilityChecked = false;
  }

  bool get canGoWishes => true;

  bool get hasWindowCleaning => addons.any((item) => item.isWindowCleaning);

  bool get hasWindowSides => windowsInside || windowsOutside;

  List<int> get addonIds => addons.map((item) => item.id).toList();

  void toggleAddon(CleaningServiceItem item) {
    final index = addons.indexWhere((addon) => addon.id == item.id);
    if (index >= 0) {
      addons.removeAt(index);
      if (item.isWindowCleaning) {
        windowCount = 0;
        windowsInside = false;
        windowsOutside = false;
      }
      return;
    }
    addons.add(item);
  }

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

  int get totalMinutes => hour * 60 + minute;

  TimeOfDayValue addMinutes(int minutes) {
    final total = totalMinutes + minutes;
    return TimeOfDayValue(hour: total ~/ 60, minute: total % 60);
  }

  TimeOfDayValue ceilToTenMinutes() {
    if (minute % 10 == 0) {
      return this;
    }
    return addMinutes(10 - (minute % 10));
  }

  TimeOfDayValue ceilToThirtyMinutes() {
    final remainder = totalMinutes % 30;
    if (remainder == 0) {
      return this;
    }
    return addMinutes(30 - remainder);
  }

  String get hhmm {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static TimeOfDayValue? tryParse(String? raw) {
    if (raw == null || raw.length < 4) return null;
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw);
    if (match == null) return null;
    return TimeOfDayValue(
      hour: int.parse(match.group(1)!),
      minute: int.parse(match.group(2)!),
    );
  }
}
