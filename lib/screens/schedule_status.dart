import 'package:wow_cleaning/l10n/app_strings.dart';

String scheduleStatusLabel(S s, String? status, bool confirmed) {
  if (!confirmed) return s.scheduleStatusPending;
  return switch (status) {
    'scheduled' => s.scheduleStatusScheduled,
    'accepted' => s.scheduleStatusAccepted,
    'on_the_way' => s.scheduleStatusOnTheWay,
    'started' => s.scheduleStatusStarted,
    'finished' => s.scheduleStatusFinished,
    'cancelled' => s.scheduleStatusCancelled,
    'frozen' => s.orderFrozen,
    'new' => s.scheduleStatusPending,
    _ => (status ?? '').replaceAll('_', ' '),
  };
}
