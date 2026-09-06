import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/schedule_api.dart';

class HomeNewsItem {
  HomeNewsItem({
    required this.id,
    required this.shortDescription,
    this.imageUrl,
  });

  final int id;
  final String shortDescription;
  final String? imageUrl;

  factory HomeNewsItem.fromJson(Map<String, dynamic> json) {
    return HomeNewsItem(
      id: (json['id'] as num).toInt(),
      shortDescription: json['short_description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class SpecialistOnTheWay {
  SpecialistOnTheWay({required this.cleanerName, required this.orderId});

  final String cleanerName;
  final int orderId;

  factory SpecialistOnTheWay.fromJson(Map<String, dynamic> json) {
    return SpecialistOnTheWay(
      cleanerName: json['cleaner_name']?.toString() ?? '',
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
    );
  }
}

class HomeData {
  HomeData({
    required this.userName,
    this.nextCleaning,
    this.specialistOnTheWay,
    this.operatorPhone,
    required this.news,
  });

  final String userName;
  final ScheduleOrder? nextCleaning;
  final SpecialistOnTheWay? specialistOnTheWay;
  final String? operatorPhone;
  final List<HomeNewsItem> news;
}

class NewsDetail {
  NewsDetail({
    required this.id,
    this.title,
    required this.shortDescription,
    this.imageUrl,
    this.bodyHtml,
  });

  final int id;
  final String? title;
  final String shortDescription;
  final String? imageUrl;
  final String? bodyHtml;

  factory NewsDetail.fromJson(Map<String, dynamic> json) {
    return NewsDetail(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString(),
      shortDescription: json['short_description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      bodyHtml: json['body_html']?.toString(),
    );
  }
}

class HomeApi {
  HomeApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<HomeData> fetchHome() async {
    final payload = await _client.getJson('client/home');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};
    final nextRaw = data['next_cleaning'];
    final specialistRaw = data['specialist_on_the_way'];
    final newsRaw = data['news'];

    final news = <HomeNewsItem>[];
    if (newsRaw is List) {
      for (final item in newsRaw) {
        if (item is Map<String, dynamic>) {
          news.add(HomeNewsItem.fromJson(item));
        }
      }
    }

    return HomeData(
      userName: user['name']?.toString() ?? '',
      nextCleaning: nextRaw is Map
          ? ScheduleOrder.fromJson(Map<String, dynamic>.from(nextRaw))
          : null,
      specialistOnTheWay: specialistRaw is Map<String, dynamic>
          ? SpecialistOnTheWay.fromJson(specialistRaw)
          : null,
      operatorPhone: _nullablePhone(data['operator_phone']),
      news: news,
    );
  }

  Future<NewsDetail> fetchNewsDetail(int id) async {
    final payload = await _client.getJson('client/news/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return NewsDetail.fromJson(data);
  }
}

String? _nullablePhone(dynamic value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}
