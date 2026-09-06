import 'package:wow_cleaning/services/api_client.dart';

class LiveLocationPoint {
  LiveLocationPoint({required this.lat, required this.lng, this.recordedAt});

  final double lat;
  final double lng;
  final String? recordedAt;
}

class LiveLocationDestination {
  const LiveLocationDestination({
    required this.lat,
    required this.lng,
    this.address,
  });

  final double lat;
  final double lng;
  final String? address;
}

class LiveLocationRoute {
  const LiveLocationRoute({
    required this.mode,
    required this.points,
    this.distanceMeters,
    this.durationSeconds,
  });

  final String mode;
  final List<LiveLocationPoint> points;
  final int? distanceMeters;
  final int? durationSeconds;
}

class LiveLocationStatus {
  LiveLocationStatus({
    required this.tracking,
    this.location,
    this.destination,
    this.route,
  });

  final bool tracking;
  final LiveLocationPoint? location;
  final LiveLocationDestination? destination;
  final LiveLocationRoute? route;
}

class LiveLocationApi {
  LiveLocationApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<LiveLocationStatus> fetch(int orderId) async {
    final payload = await _client.getJson('client/orders/$orderId/location');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final raw = data['location'];
    final point = _point(raw);
    final rawDestination = data['destination'];
    LiveLocationDestination? destination;
    if (rawDestination is Map) {
      final lat = (rawDestination['lat'] as num?)?.toDouble();
      final lng = (rawDestination['lng'] as num?)?.toDouble();
      if (lat != null && lng != null) {
        destination = LiveLocationDestination(
          lat: lat,
          lng: lng,
          address: rawDestination['address']?.toString(),
        );
      }
    }

    final rawRoute = data['route'];
    LiveLocationRoute? route;
    if (rawRoute is Map) {
      final points = (rawRoute['points'] as List<dynamic>? ?? const [])
          .map(_point)
          .whereType<LiveLocationPoint>()
          .toList(growable: false);
      if (points.length >= 2) {
        route = LiveLocationRoute(
          mode: rawRoute['mode']?.toString() ?? 'direct',
          points: points,
          distanceMeters: (rawRoute['distance_meters'] as num?)?.round(),
          durationSeconds: (rawRoute['duration_seconds'] as num?)?.round(),
        );
      }
    }

    return LiveLocationStatus(
      tracking: data['tracking'] == true || data['tracking'] == 1,
      location: point,
      destination: destination,
      route: route,
    );
  }

  static LiveLocationPoint? _point(dynamic raw) {
    if (raw is! Map) return null;
    final lat = (raw['lat'] as num?)?.toDouble();
    final lng = (raw['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;

    return LiveLocationPoint(
      lat: lat,
      lng: lng,
      recordedAt: raw['recorded_at']?.toString(),
    );
  }
}
