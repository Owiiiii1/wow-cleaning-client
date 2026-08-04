import 'package:wow_cleaning/services/api_client.dart';

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

class NextCleaning {
  NextCleaning({
    required this.id,
    required this.serviceName,
    this.status,
    this.paymentStatus,
    this.date,
    this.startTime,
    this.endTime,
    this.address,
  });

  final int id;
  final String serviceName;
  final String? status;
  final String? paymentStatus;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? address;

  factory NextCleaning.fromJson(Map<String, dynamic> json) {
    return NextCleaning(
      id: (json['id'] as num).toInt(),
      serviceName: json['service_name']?.toString() ?? '',
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      date: json['date']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      address: json['address']?.toString(),
    );
  }
}

class SpecialistOnTheWay {
  SpecialistOnTheWay({
    required this.cleanerName,
    required this.orderId,
  });

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
    required this.news,
  });

  final String userName;
  final NextCleaning? nextCleaning;
  final SpecialistOnTheWay? specialistOnTheWay;
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
      nextCleaning: nextRaw is Map<String, dynamic>
          ? NextCleaning.fromJson(nextRaw)
          : null,
      specialistOnTheWay: specialistRaw is Map<String, dynamic>
          ? SpecialistOnTheWay.fromJson(specialistRaw)
          : null,
      news: news,
    );
  }

  Future<NewsDetail> fetchNewsDetail(int id) async {
    final payload = await _client.getJson('client/news/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return NewsDetail.fromJson(data);
  }
}
