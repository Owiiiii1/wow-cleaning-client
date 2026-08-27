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
    this.startAsRecurring = false,
  });

  /// Called after confirmed screen action. `goToSchedule` true → open Schedule tab.
  final void Function(bool goToSchedule)? onFinished;
  final bool startAsRecurring;

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
  List<CleaningServiceItem> _addons = [];
  bool _loadingProperties = true;
  bool _loadingServices = true;
  bool _loadingAddons = true;
  bool _loadingQuote = false;
  bool _checkingAvailability = false;
  bool _reserving = false;
  bool _holdCommitted = false;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _windowsController = TextEditingController();

  static const _totalSteps = 6;
  static const _stepKeys = [
    'bookingStepProperty',
    'bookingStepService',
    'bookingStepAddons',
    'bookingStepSchedule',
    'bookingStepWishes',
    'bookingStepPayment',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.startAsRecurring) {
      _state.scheduleType = BookingScheduleType.recurring;
    }
    _loadProperties();
    _loadServices();
    _loadAddons();
  }

  @override
  void dispose() {
    final holdId = _state.holdId;
    if (!_holdCommitted && holdId != null) {
      _bookingApi.cancelHold(holdId);
    }
    _notesController.dispose();
    _windowsController.dispose();
    super.dispose();
  }

  Future<void> _releaseHold() async {
    final holdId = _state.holdId;
    if (holdId == null) return;
    _state.holdId = null;
    try {
      await _bookingApi.cancelHold(holdId);
    } catch (_) {}
  }

  Future<void> _reserveCurrentStart() async {
    final date = _state.dateApi;
    final time = _state.timeApi;
    if (date == null || time == null) return;
    setState(() {
      _reserving = true;
      _error = null;
    });
    try {
      final hours = (_state.quote?.hours ?? 0) > 0 ? _state.quote!.hours : 2.0;
      final hold = await _bookingApi.reserveHold(
        date: date,
        startTime: time,
        durationHours: hours,
        replaceHoldId: _state.holdId,
      );
      if (!mounted) return;
      setState(() {
        _state.holdId = hold.holdId;
        _reserving = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _state.holdId = null;
        _reserving = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state.holdId = null;
        _reserving = false;
        _error = S.current.bookingHoldFailed;
      });
    }
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

  Future<void> _loadAddons() async {
    setState(() => _loadingAddons = true);
    try {
      final items = await _servicesApi.list(kind: 'addon');
      if (!mounted) return;
      setState(() {
        _addons = items;
        _loadingAddons = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingAddons = false;
        _error = S.current.servicesLoadFailed;
      });
    }
  }

  bool get _canNext => switch (_step) {
        0 => _state.canGoProperty,
        1 => _state.canGoService,
        2 => _state.canGoAddons,
        3 => _state.canGoSchedule,
        4 => _state.canGoWishes,
        5 => !_submitting,
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

  Future<void> _openFixProperty(ClientPropertyItem item) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(propertyId: item.id),
      ),
    );
    if (updated != true) return;
    await _loadProperties();
    if (!mounted) return;
    final refreshed = _properties.where((row) => row.id == item.id);
    await _releaseHold();
    if (!mounted) return;
    setState(() {
      _state.property = refreshed.isEmpty ? null : refreshed.first;
      _state.quote = null;
      _state.clearAvailability();
      _error = null;
    });
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
    await _releaseHold();
    if (!mounted) return;
    setState(() {
      _state.date = picked;
      _state.clearAvailability();
    });
    await _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final date = _state.dateApi;
    if (date == null) return;
    setState(() {
      _checkingAvailability = true;
      _error = null;
    });
    try {
      await _releaseHold();
      if (_state.quote == null) {
        await _loadQuote();
      }
      final hours = (_state.quote?.hours ?? 0) > 0
          ? _state.quote!.hours
          : 2.0;
      final result = await _bookingApi.checkAvailability(
        date: date,
        durationHours: hours,
      );
      if (!mounted) return;
      setState(() {
        _state.windows = result.windows;
        _state.availabilityChecked = true;
        _state.selectedWindow = null;
        _state.time = null;
        _checkingAvailability = false;
        if (!result.available) {
          _error = S.current.bookingNoSlots;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _checkingAvailability = false;
        _state.availabilityChecked = true;
        _state.windows = [];
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _checkingAvailability = false;
        _state.availabilityChecked = true;
        _state.windows = [];
        _error = S.current.bookingAvailabilityFailed;
      });
    }
  }

  void _selectWindow(AvailabilityWindow window) {
    setState(() {
      _state.selectedWindow = window;
      if (window.needsPreferredStart) {
        _state.time = null;
        _state.holdId = null;
      } else {
        _state.time = TimeOfDayValue.tryParse(window.startTime);
      }
    });
    if (window.needsPreferredStart) {
      _releaseHold();
    } else {
      _reserveCurrentStart();
    }
  }

  List<TimeOfDayValue> _preferredStarts(AvailabilityWindow window) {
    if (window.preferredStarts.isNotEmpty) {
      return window.preferredStarts
          .map(TimeOfDayValue.tryParse)
          .whereType<TimeOfDayValue>()
          .toList();
    }
    final start = TimeOfDayValue.tryParse(window.startTime);
    final latest = TimeOfDayValue.tryParse(window.latestStartTime);
    if (start == null || latest == null) return const [];
    final out = <TimeOfDayValue>[start];
    var current = start.ceilToThirtyMinutes();
    if (current.totalMinutes == start.totalMinutes) {
      current = current.addMinutes(30);
    }
    while (current.totalMinutes <= latest.totalMinutes) {
      out.add(current);
      current = current.addMinutes(30);
      if (out.length > 48) break;
    }
    return out;
  }

  Future<void> _onPrimary() async {
    if (_step < 5) {
      if (!_canNext) return;
      if (_step == 0 && _state.property != null && !_state.property!.hasHousingParams) {
        setState(() => _error = S.current.propertyIncomplete);
        return;
      }
      if (_step == 2 && _state.hasWindowCleaning && _state.windowCount < 1) {
        setState(() => _error = S.current.bookingWindowsRequired);
        return;
      }
      final next = _step + 1;
      setState(() {
        _step = next;
        _error = null;
      });
      if (next == 3 || next == 5) {
        await _loadQuote();
      }
      return;
    }
    await _submit();
  }

  Future<void> _loadQuote() async {
    final property = _state.property;
    final service = _state.service;
    if (property == null || service == null) return;
    setState(() => _loadingQuote = true);
    try {
      final quote = await _bookingApi.quote(
        clientPropertyId: property.id,
        cleaningServiceId: service.id,
        addonServiceIds: _state.addonIds,
        windowCount: _state.windowCount,
      );
      if (!mounted) return;
      setState(() {
        _state.quote = quote;
        _loadingQuote = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _state.quote = null;
        _loadingQuote = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state.quote = null;
        _loadingQuote = false;
        _error = S.current.bookingEstimateFailed;
      });
    }
  }

  Future<void> _submit() async {
    final property = _state.property;
    final service = _state.service;
    final date = _state.dateApi;
    final time = _state.timeApi;
    final holdId = _state.holdId;
    if (property == null ||
        service == null ||
        date == null ||
        time == null ||
        holdId == null) {
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
        addonServiceIds: _state.addonIds,
        windowCount: _state.windowCount,
        scheduleType: _state.scheduleTypeApi,
        recurrence: _state.recurrenceApi,
        requestedDate: date,
        requestedTime: time,
        holdId: holdId,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      _holdCommitted = true;
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
    final stepLabel = s.bookingStepOf(_step + 1, _totalSteps);
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
                      value: (_step + 1) / _totalSteps,
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
                    2 => _buildAddonsStep(s),
                    3 => _buildScheduleStep(s),
                    4 => _buildWishesStep(s),
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
                            : () {
                                if (_step == 3) {
                                  _releaseHold();
                                  _state.clearAvailability();
                                }
                                setState(() {
                                  _step -= 1;
                                  _error = null;
                                });
                              },
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
                      onPressed: _canNext && !_submitting && !_reserving ? _onPrimary : null,
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
                              _step == 5 ? s.payNow : s.next,
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
              onTap: () {
                _releaseHold();
                setState(() {
                  _state.property = item;
                  _state.quote = null;
                  _state.clearAvailability();
                  _error = item.hasHousingParams ? null : s.propertyIncomplete;
                });
              },
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
                        const SizedBox(height: 4),
                        Text(
                          item.hasHousingParams
                              ? '${item.squareFootage} sqft · ${item.bedrooms} ${s.propertyBedrooms.toLowerCase()} · ${item.bathrooms} ${s.propertyBathrooms.toLowerCase()}'
                              : s.propertyIncomplete,
                          style: AppFonts.body(
                            fontSize: 12,
                            color: item.hasHousingParams
                                ? AppColors.darkGray.withValues(alpha: 0.55)
                                : Colors.red.shade700,
                          ),
                        ),
                        if (!item.hasHousingParams) ...[
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () => _openFixProperty(item),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 34),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              backgroundColor: AppColors.pictonBlue,
                              foregroundColor: Colors.white,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              s.fixProperty,
                              style: AppFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
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
              onTap: () {
                _releaseHold();
                setState(() {
                  _state.service = item;
                  _state.quote = null;
                  _state.clearAvailability();
                });
              },
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

  List<Widget> _buildAddonsStep(S s) {
    return [
      Text(
        s.bookingAddonsTitle,
        style: AppFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGray,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.bookingAddonsSubtitle,
        style: AppFonts.body(
          fontSize: 15,
          color: AppColors.darkGray.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 16),
      if (_loadingAddons)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.pictonBlue),
          ),
        )
      else if (_addons.isEmpty)
        Text(
          s.bookingAddonsNone,
          style: AppFonts.body(
            color: AppColors.darkGray.withValues(alpha: 0.55),
          ),
        )
      else
        ..._addons.map((item) {
          final selected = _state.addons.any((addon) => addon.id == item.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              selected: selected,
              onTap: () {
                _releaseHold();
                setState(() {
                  _state.toggleAddon(item);
                  _state.quote = null;
                  _state.clearAvailability();
                  if (item.isWindowCleaning && !_state.hasWindowCleaning) {
                    _windowsController.clear();
                  }
                });
              },
              child: Row(
                children: [
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
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: selected
                        ? AppColors.pictonBlue
                        : AppColors.darkGray.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          );
        }),
      if (_state.hasWindowCleaning) ...[
        const SizedBox(height: 8),
        Text(
          s.bookingWindowsLabel,
          style: AppFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _windowsController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _state.windowCount = int.tryParse(value.trim()) ?? 0;
              _state.quote = null;
              _state.clearAvailability();
            });
          },
          decoration: InputDecoration(
            hintText: s.bookingWindowsHint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: AppFonts.body(
              color: AppColors.darkGray.withValues(alpha: 0.4),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.darkGray.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.darkGray.withValues(alpha: 0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.pictonBlue, width: 1.4),
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildScheduleStep(S s) {
    final dateText = _state.date == null
        ? s.bookingPickDate
        : '${_state.date!.day.toString().padLeft(2, '0')}.'
            '${_state.date!.month.toString().padLeft(2, '0')}.'
            '${_state.date!.year}';
    final durationHours = (_state.quote?.hours ?? 0) > 0
        ? _state.quote!.hours
        : 0.0;
    final selected = _state.selectedWindow;
    final preferredStarts = selected != null && selected.needsPreferredStart
        ? _preferredStarts(selected)
        : const <TimeOfDayValue>[];
    final jobEnd = _state.time == null
        ? null
        : _state.time!
            .addMinutes(((_state.quote?.hours ?? 2) * 60).round())
            .ceilToTenMinutes();

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
      if (durationHours > 0) ...[
        const SizedBox(height: 10),
        Text(
          '${s.bookingEstimateTime}: ${s.bookingHoursValue(_formatHours(durationHours))}',
          style: AppFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.pictonBlue,
          ),
        ),
      ],
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
      const SizedBox(height: 12),
      if (_checkingAvailability) ...[
        const SizedBox(height: 18),
        const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.pictonBlue,
            ),
          ),
        ),
      ],
      if (_state.availabilityChecked && _state.windows.isNotEmpty) ...[
        const SizedBox(height: 18),
        Text(
          s.bookingSelectSlot,
          style: AppFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 10),
        ..._state.windows.map((window) {
          final isSelected = selected != null && selected.sameAs(window);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SelectableCard(
              selected: isSelected,
              onTap: () => _selectWindow(window),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${window.startTime} – ${window.endTime}',
                          style: AppFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.bookingHoursValue(_formatHours(window.slotHours)),
                          style: AppFonts.body(
                            fontSize: 13,
                            color: AppColors.darkGray.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: isSelected
                        ? AppColors.pictonBlue
                        : AppColors.darkGray.withValues(alpha: 0.25),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
      if (selected != null && selected.needsPreferredStart) ...[
        const SizedBox(height: 8),
        Text(
          s.bookingPreferredStart,
          style: AppFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          s.bookingPreferredStartHint,
          style: AppFonts.body(
            fontSize: 13,
            color: AppColors.darkGray.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: preferredStarts
              .map(
                (start) => _Chip(
                  label: start.hhmm,
                  selected: _state.time?.totalMinutes == start.totalMinutes,
                  onTap: () {
                    setState(() => _state.time = start);
                    _reserveCurrentStart();
                  },
                ),
              )
              .toList(),
        ),
        if (_state.holdId != null) ...[
          const SizedBox(height: 10),
          Text(
            s.bookingHeld,
            style: AppFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.pictonBlue,
            ),
          ),
        ],
        if (_state.time != null && jobEnd != null) ...[
          const SizedBox(height: 10),
          Text(
            '${s.bookingTime}: ${_state.time!.hhmm} – ${jobEnd.hhmm}',
            style: AppFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.pictonBlue,
            ),
          ),
        ],
      ],
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
    final notes = _notesController.text.trim();
    final scheduleLabel = _state.scheduleType == BookingScheduleType.oneTime
        ? s.bookingOneTime
        : '${s.bookingRecurring} · ${_recurrenceLabel(s)}';
    final housing = property != null && property.hasHousingParams
        ? '${property.squareFootage} sqft · ${property.bedrooms} ${s.propertyBedrooms.toLowerCase()} · ${property.bathrooms} ${s.propertyBathrooms.toLowerCase()}'
        : null;

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
      _ReviewCard(
        child: Column(
          children: [
            _ReviewPropertyBlock(
              title: property?.title ?? '—',
              address: (property?.address ?? '').isEmpty
                  ? null
                  : property!.address,
              details: housing,
              imageUrl: property?.mainImageUrl,
              label: s.bookingSummaryProperty,
            ),
            const _ReviewDivider(),
            _ReviewIconBlock(
              icon: Icons.cleaning_services_outlined,
              label: s.bookingSummaryService,
              title: service?.title ?? '—',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    s.bookingSummaryAddons.toUpperCase(),
                    style: AppFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.darkGray.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_state.addons.isEmpty)
                    Text(
                      s.bookingAddonsNone,
                      style: AppFonts.body(
                        fontSize: 14,
                        color: AppColors.darkGray.withValues(alpha: 0.5),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._state.addons.map(
                          (item) => _ReviewChip(label: item.title),
                        ),
                        if (_state.hasWindowCleaning)
                          _ReviewChip(
                            label: '${s.bookingWindowsLabel}: ${_state.windowCount}',
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const _ReviewDivider(),
            _ReviewIconBlock(
              icon: Icons.calendar_month_outlined,
              label: s.bookingSummarySchedule,
              title: scheduleLabel,
              subtitle: '${_formatReviewDate()} · ${_formatReviewTime()}',
            ),
            if (notes.isNotEmpty) ...[
              const _ReviewDivider(),
              _ReviewIconBlock(
                icon: Icons.chat_bubble_outline_rounded,
                label: s.bookingSummaryNotes,
                title: notes,
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: _loadingQuote
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(color: AppColors.darkGray),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.bookingEstimateTitle.toUpperCase(),
                    style: AppFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: AppColors.darkGray.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          _formatPrice(_state.quote),
                          style: AppFonts.montserrat(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ),
                      Text(
                        s.bookingHoursValue(_formatHours(_state.quote?.hours ?? 0)),
                        style: AppFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.bookingEstimateNote,
                    style: AppFonts.body(
                      fontSize: 13,
                      color: AppColors.darkGray.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
      ),
    ];
  }

  String _formatReviewDate() {
    final date = _state.date;
    if (date == null) return '—';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  String _formatReviewTime() {
    final start = _state.time;
    if (start == null) return '—';
    final end = start
        .addMinutes(((_state.quote?.hours ?? 2) * 60).round())
        .ceilToTenMinutes();
    return '${start.hhmm} – ${end.hhmm}';
  }

  String _formatPrice(BookingQuote? quote) {
    if (quote == null) return '—';
    final value = quote.price == quote.price.roundToDouble()
        ? quote.price.toInt().toString()
        : quote.price.toStringAsFixed(2);
    return '\$$value';
  }

  String _formatHours(double hours) {
    if (hours == hours.roundToDouble()) {
      return hours.toInt().toString();
    }
    return hours.toString();
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
      'bookingStepAddons' => bookingStepAddons,
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ReviewDivider extends StatelessWidget {
  const _ReviewDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        height: 1,
        color: AppColors.darkGray.withValues(alpha: 0.08),
      ),
    );
  }
}

class _ReviewChip extends StatelessWidget {
  const _ReviewChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pictonBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.pictonBlue,
        ),
      ),
    );
  }
}

class _ReviewPropertyBlock extends StatelessWidget {
  const _ReviewPropertyBlock({
    required this.label,
    required this.title,
    this.address,
    this.details,
    this.imageUrl,
  });

  final String label;
  final String title;
  final String? address;
  final String? details;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: (imageUrl ?? '').isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => const _ReviewIcon(
                        icon: Icons.home_work_outlined,
                      ),
                    )
                  : const _ReviewIcon(icon: Icons.home_work_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.darkGray.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGray,
                  ),
                ),
                if ((address ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    address!,
                    style: AppFonts.body(
                      fontSize: 13,
                      color: AppColors.darkGray.withValues(alpha: 0.55),
                    ),
                  ),
                ],
                if ((details ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    details!,
                    style: AppFonts.body(
                      fontSize: 12,
                      color: AppColors.darkGray.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewIconBlock extends StatelessWidget {
  const _ReviewIconBlock({
    required this.icon,
    required this.label,
    required this.title,
    this.subtitle,
    this.child,
  });

  final IconData icon;
  final String label;
  final String title;
  final String? subtitle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.darkGray.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGray,
                  ),
                ),
                if ((subtitle ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppFonts.body(
                      fontSize: 13,
                      color: AppColors.darkGray.withValues(alpha: 0.55),
                    ),
                  ),
                ],
                if (child != null) child!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewIcon extends StatelessWidget {
  const _ReviewIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.pictonBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.pictonBlue, size: 22),
    );
  }
}
