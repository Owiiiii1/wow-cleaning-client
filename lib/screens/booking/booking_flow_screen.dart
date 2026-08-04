import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/booking/booking_confirmed_screen.dart';
import 'package:wow_cleaning/screens/booking/booking_state.dart';
import 'package:wow_cleaning/screens/property_form_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/booking_api.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/services/services_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({
    super.key,
    this.onFinished,
  });

  /// Called after confirmed screen action. `goToSchedule` true → open Schedule tab.
  final void Function(bool goToSchedule)? onFinished;

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final BookingState _state = BookingState();
  final PropertiesApi _propertiesApi = PropertiesApi();
  final ServicesApi _servicesApi = ServicesApi();
  final BookingApi _bookingApi = BookingApi();

  int _step = 0;
  bool _submitting = false;
  String? _error;

  List<ClientPropertyItem> _properties = [];
  List<CleaningServiceItem> _services = [];
  bool _loadingProperties = true;
  bool _loadingServices = true;
  final TextEditingController _notesController = TextEditingController();

  static const _stepKeys = [
    'bookingStepProperty',
    'bookingStepService',
    'bookingStepSchedule',
    'bookingStepWishes',
    'bookingStepPayment',
  ];

  @override
  void initState() {
    super.initState();
    _loadProperties();
    _loadServices();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() => _loadingProperties = true);
    try {
      final items = await _propertiesApi.list();
      if (!mounted) return;
      setState(() {
        _properties = items;
        _loadingProperties = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingProperties = false;
        _error = S.current.propertiesLoadFailed;
      });
    }
  }

  Future<void> _loadServices() async {
    setState(() => _loadingServices = true);
    try {
      final items = await _servicesApi.list();
      if (!mounted) return;
      setState(() {
        _services = items;
        _loadingServices = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingServices = false;
        _error = S.current.servicesLoadFailed;
      });
    }
  }

  bool get _canNext => switch (_step) {
        0 => _state.canGoStep1,
        1 => _state.canGoStep2,
        2 => _state.canGoStep3,
        3 => _state.canGoStep4,
        4 => !_submitting,
        _ => false,
      };

  Future<void> _openAddProperty() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PropertyFormScreen()),
    );
    if (created != true) return;
    await _loadProperties();
    if (!mounted || _properties.isEmpty) return;
    setState(() => _state.property = _properties.first);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _state.date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.pictonBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.darkGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _state.date = picked);
  }

  Future<void> _pickTime() async {
    final initial = TimeOfDay(
      hour: _state.time?.hour ?? 10,
      minute: _state.time?.minute ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.pictonBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.darkGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(
      () => _state.time = TimeOfDayValue(
        hour: picked.hour,
        minute: picked.minute,
      ),
    );
  }

  Future<void> _onPrimary() async {
    if (_step < 4) {
      if (!_canNext) return;
      setState(() {
        _step += 1;
        _error = null;
      });
      return;
    }
    await _submit();
  }

  Future<void> _submit() async {
    final property = _state.property;
    final service = _state.service;
    final date = _state.dateApi;
    final time = _state.timeApi;
    if (property == null || service == null || date == null || time == null) {
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _bookingApi.createRequest(
        clientPropertyId: property.id,
        cleaningServiceId: service.id,
        scheduleType: _state.scheduleTypeApi,
        recurrence: _state.recurrenceApi,
        requestedDate: date,
        requestedTime: time,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      final navigator = Navigator.of(context);
      final onFinished = widget.onFinished;
      await navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingConfirmedScreen(
            onBackHome: () {
              navigator.pop();
              onFinished?.call(false);
            },
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = S.current.bookingSubmitFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final stepLabel = s.bookingStepOf(_step + 1, 5);
    final stepName = s._tSafe(_stepKeys[_step]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.darkGray,
                  ),
                  Expanded(
                    child: Text(
                      'WOW NOW',
                      textAlign: TextAlign.center,
                      style: AppFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF004B6F),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'asset/benjamin.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        stepLabel,
                        style: AppFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.darkGray.withValues(alpha: 0.55),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        stepName,
                        style: AppFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / 5,
                      minHeight: 6,
                      backgroundColor:
                          AppColors.darkGray.withValues(alpha: 0.08),
                      color: AppColors.pictonBlue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: AppFonts.body(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ...switch (_step) {
                    0 => _buildPropertyStep(s),
                    1 => _buildServiceStep(s),
                    2 => _buildScheduleStep(s),
                    3 => _buildWishesStep(s),
                    _ => _buildPaymentStep(s),
                  },
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting
                            ? null
                            : () => setState(() {
                                  _step -= 1;
                                  _error = null;
                                }),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: AppColors.darkGray,
                          side: BorderSide(
                            color: AppColors.darkGray.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          s.back,
                          style: AppFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _canNext && !_submitting ? _onPrimary : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: AppColors.pictonBlue,
                        disabledBackgroundColor:
                            AppColors.pictonBlue.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _step == 4 ? s.payNow : s.next,
                              style: AppFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPropertyStep(S s) {
    return [
      Text(
        s.bookingPropertyTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingPropertySubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: _openAddProperty,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            s.addProperty,
            style: AppFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.pictonBlue,
            side: const BorderSide(color: AppColors.pictonBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      if (_loadingProperties)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.pictonBlue),
          ),
        )
      else if (_properties.isEmpty)
        Text(
          s.propertiesEmpty,
          style: AppFonts.body(
            color: AppColors.darkGray.withValues(alpha: 0.55),
          ),
        )
      else
        ..._properties.map((item) {
          final selected = _state.property?.id == item.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              selected: selected,
              onTap: () => setState(() => _state.property = item),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: (item.mainImageUrl ?? '').isNotEmpty
                          ? Image.network(
                              item.mainImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) => _iconBox(
                                Icons.home_work_outlined,
                              ),
                            )
                          : _iconBox(Icons.home_work_outlined),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGray,
                          ),
                        ),
                        if ((item.address ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.address!,
                            style: AppFonts.body(
                              fontSize: 13,
                              color: AppColors.darkGray.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected
                        ? AppColors.pictonBlue
                        : AppColors.darkGray.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          );
        }),
    ];
  }

  List<Widget> _buildServiceStep(S s) {
    return [
      Text(
        s.bookingServiceTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingServiceSubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 16),
      if (_loadingServices)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.pictonBlue),
          ),
        )
      else if (_services.isEmpty)
        Text(
          s.servicesEmpty,
          style: AppFonts.body(
            color: AppColors.darkGray.withValues(alpha: 0.55),
          ),
        )
      else
        ..._services.map((item) {
          final selected = _state.service?.id == item.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              selected: selected,
              onTap: () => setState(() => _state.service = item),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: (item.imageUrl ?? '').isNotEmpty
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  _iconBox(Icons.cleaning_services_outlined),
                            )
                          : _iconBox(Icons.cleaning_services_outlined),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGray,
                          ),
                        ),
                        if ((item.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.description!,
                            style: AppFonts.body(
                              fontSize: 13,
                              color: AppColors.darkGray.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected
                        ? AppColors.pictonBlue
                        : AppColors.darkGray.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          );
        }),
    ];
  }

  List<Widget> _buildScheduleStep(S s) {
    final dateText = _state.date == null
        ? s.bookingPickDate
        : '${_state.date!.day.toString().padLeft(2, '0')}.'
            '${_state.date!.month.toString().padLeft(2, '0')}.'
            '${_state.date!.year}';
    final timeText = _state.time == null
        ? s.bookingPickTime
        : '${_state.time!.hour.toString().padLeft(2, '0')}:'
            '${_state.time!.minute.toString().padLeft(2, '0')}';

    return [
      Text(
        s.bookingScheduleTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingScheduleSubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                label: s.bookingOneTime,
                selected: _state.scheduleType == BookingScheduleType.oneTime,
                onTap: () => setState(
                  () => _state.scheduleType = BookingScheduleType.oneTime,
                ),
              ),
            ),
            Expanded(
              child: _Segment(
                label: s.bookingRecurring,
                selected: _state.scheduleType == BookingScheduleType.recurring,
                onTap: () => setState(
                  () => _state.scheduleType = BookingScheduleType.recurring,
                ),
              ),
            ),
          ],
        ),
      ),
      if (_state.scheduleType == BookingScheduleType.recurring) ...[
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Chip(
              label: s.bookingWeekly,
              selected: _state.recurrence == BookingRecurrence.weekly,
              onTap: () => setState(
                () => _state.recurrence = BookingRecurrence.weekly,
              ),
            ),
            _Chip(
              label: s.bookingBiweekly,
              selected: _state.recurrence == BookingRecurrence.biweekly,
              onTap: () => setState(
                () => _state.recurrence = BookingRecurrence.biweekly,
              ),
            ),
            _Chip(
              label: s.bookingMonthly,
              selected: _state.recurrence == BookingRecurrence.monthly,
              onTap: () => setState(
                () => _state.recurrence = BookingRecurrence.monthly,
              ),
            ),
          ],
        ),
      ],
      const SizedBox(height: 16),
      _PickerTile(
        icon: Icons.calendar_today_outlined,
        label: s.bookingDate,
        value: dateText,
        onTap: _pickDate,
      ),
      const SizedBox(height: 10),
      _PickerTile(
        icon: Icons.schedule_outlined,
        label: s.bookingTime,
        value: timeText,
        onTap: _pickTime,
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.pictonBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF004B6F), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.bookingScheduleDisclaimer,
                style: AppFonts.body(
                  fontSize: 13,
                  color: const Color(0xFF004B6F),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildWishesStep(S s) {
    return [
      Text(
        s.bookingWishesTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingWishesSubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _notesController,
        minLines: 6,
        maxLines: 12,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (v) => _state.notes = v,
        decoration: InputDecoration(
          hintText: s.bookingWishesHint,
          filled: true,
          fillColor: Colors.white,
          hintStyle: AppFonts.body(
            color: AppColors.darkGray.withValues(alpha: 0.4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.darkGray.withValues(alpha: 0.12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.darkGray.withValues(alpha: 0.12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: AppColors.pictonBlue, width: 1.4),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPaymentStep(S s) {
    final property = _state.property;
    final service = _state.service;
    final date = _state.dateApi ?? '—';
    final time = _state.timeApi ?? '—';
    final scheduleLabel = _state.scheduleType == BookingScheduleType.oneTime
        ? s.bookingOneTime
        : '${s.bookingRecurring} · ${_recurrenceLabel(s)}';

    return [
      Text(
        s.bookingPaymentTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingPaymentSubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowShadow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow(label: s.bookingSummaryProperty, value: property?.title ?? '—'),
            _SummaryRow(
              label: s.propertyAddress,
              value: (property?.address ?? '').isEmpty
                  ? '—'
                  : property!.address!,
            ),
            _SummaryRow(
              label: s.bookingSummaryService,
              value: service?.title ?? '—',
            ),
            _SummaryRow(label: s.bookingSummarySchedule, value: scheduleLabel),
            _SummaryRow(label: s.bookingDate, value: date),
            _SummaryRow(label: s.bookingTime, value: time),
            _SummaryRow(
              label: s.bookingSummaryNotes,
              value: _notesController.text.trim().isEmpty
                  ? '—'
                  : _notesController.text.trim(),
            ),
          ],
        ),
      ),
    ];
  }

  String _recurrenceLabel(S s) => switch (_state.recurrence) {
        BookingRecurrence.weekly => s.bookingWeekly,
        BookingRecurrence.biweekly => s.bookingBiweekly,
        BookingRecurrence.monthly => s.bookingMonthly,
      };

  Widget _iconBox(IconData icon) {
    return Container(
      color: AppColors.pictonBlue.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.pictonBlue),
    );
  }
}

extension on S {
  String _tSafe(String key) {
    // Access private tables via public getters for known keys.
    return switch (key) {
      'bookingStepProperty' => bookingStepProperty,
      'bookingStepService' => bookingStepService,
      'bookingStepSchedule' => bookingStepSchedule,
      'bookingStepWishes' => bookingStepWishes,
      'bookingStepPayment' => bookingStepPayment,
      _ => key,
    };
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.pictonBlue
                  : AppColors.darkGray.withValues(alpha: 0.08),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glowShadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.darkGray,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.pictonBlue.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.pictonBlue
                : AppColors.darkGray.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          label,
          style: AppFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.pictonBlue : AppColors.darkGray,
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.pictonBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: AppFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.darkGray.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.darkGray.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppFonts.body(
              fontSize: 15,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
