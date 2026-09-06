import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/live_location_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

Future<void> showLiveTrackingMap(BuildContext context, {required int orderId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => LiveTrackingMapSheet(orderId: orderId),
  );
}

class LiveTrackingMapSheet extends StatefulWidget {
  const LiveTrackingMapSheet({super.key, required this.orderId});

  final int orderId;

  @override
  State<LiveTrackingMapSheet> createState() => _LiveTrackingMapSheetState();
}

class _LiveTrackingMapSheetState extends State<LiveTrackingMapSheet> {
  final LiveLocationApi _api = LiveLocationApi();
  final MapController _map = MapController();
  Timer? _timer;
  LiveLocationStatus? _status;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _map.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final status = await _api.fetch(widget.orderId);
      if (!mounted) return;
      setState(() {
        _status = status;
        _loading = false;
        _error = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap(status));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.trackingLoadFailed;
      });
    }
  }

  void _fitMap(LiveLocationStatus status) {
    if (!mounted) return;
    final points =
        status.route?.points
            .map((point) => LatLng(point.lat, point.lng))
            .toList(growable: false) ??
        [
          if (status.location case final point?) LatLng(point.lat, point.lng),
          if (status.destination case final destination?)
            LatLng(destination.lat, destination.lng),
        ];
    if (points.isEmpty) return;

    try {
      if (points.length == 1) {
        _map.move(points.first, 15);
      } else {
        _map.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.all(48),
            maxZoom: 16,
          ),
        );
      }
    } catch (_) {
      // The map may not be attached during the first frame. The next poll
      // retries, while the initial camera still shows the cleaner.
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final point = _status?.location;
    final destination = _status?.destination;
    final routePoints =
        _status?.route?.points
            .map((item) => LatLng(item.lat, item.lng))
            .toList(growable: false) ??
        const <LatLng>[];
    final tracking = _status?.tracking == true;
    final height = MediaQuery.sizeOf(context).height * 0.72;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkGray.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.trackingTitle,
                    style: AppFonts.headline(
                      fontSize: 18,
                      color: AppColors.darkLiver,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tracking
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                        : AppColors.yellow.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tracking ? s.trackingLive : s.trackingIdle,
                    style: AppFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: point == null
                    ? ColoredBox(
                        color: AppColors.pictonBlue.withValues(alpha: 0.08),
                        child: Center(
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: AppColors.pictonBlue,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    _error ?? s.trackingNoPoint,
                                    textAlign: TextAlign.center,
                                    style: AppFonts.body(
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                ),
                        ),
                      )
                    : FlutterMap(
                        mapController: _map,
                        options: MapOptions(
                          initialCenter: LatLng(point.lat, point.lng),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.wownowcleaning.client',
                          ),
                          if (routePoints.length >= 2)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routePoints,
                                  strokeWidth: 5,
                                  color: AppColors.pictonBlue,
                                  borderStrokeWidth: 2,
                                  borderColor: Colors.white,
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              if (destination != null)
                                Marker(
                                  point: LatLng(
                                    destination.lat,
                                    destination.lng,
                                  ),
                                  width: 46,
                                  height: 46,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.yellow,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.darkGray.withValues(
                                            alpha: 0.16,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.home_rounded,
                                      color: AppColors.darkLiver,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              Marker(
                                point: LatLng(point.lat, point.lng),
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: tracking
                                      ? AppColors.pictonBlue
                                      : AppColors.darkGray,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
