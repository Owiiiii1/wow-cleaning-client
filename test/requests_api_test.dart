import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/requests_api.dart';
import 'package:wow_cleaning/services/schedule_api.dart';

void main() {
  group('RequestsApi', () {
    test('parses top-level items contract', () async {
      final client = MockClient((request) async {
        expect(request.url.path, endsWith('/client/requests'));
        expect(request.url.queryParameters['scope'], 'active');
        return http.Response(
          jsonEncode({
            'items': [
              {
                'id': 42,
                'request_type': 'cleaning_dispute',
                'message': 'Missed area',
                'status': 'in_progress',
                'published_updates': [
                  {
                    'message': 'We are reviewing it',
                    'created_at': '2026-09-06',
                  },
                ],
                'attachments': [
                  {'url': 'https://example.com/private/photo.jpg'},
                ],
                'order': {'id': 7, 'service_name': 'Deep cleaning'},
                'remediation_order': {'id': 8},
                'resolution_code': null,
                'created_at': '2026-09-06T10:00:00Z',
                'completed_at': null,
              },
            ],
          }),
          200,
        );
      });

      final items = await RequestsApi(
        client: ApiClient(client: client),
      ).fetchRequests();

      expect(items, hasLength(1));
      expect(items.single.id, 42);
      expect(items.single.requestType, 'cleaning_dispute');
      expect(
        items.single.publishedUpdates.single.message,
        'We are reviewing it',
      );
      expect(items.single.attachments.single.url, contains('photo.jpg'));
      expect(items.single.order?.id, 7);
      expect(items.single.remediationOrder?.id, 8);
    });

    test('creates multipart feedback with photos array field', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({
            'request': {
              'id': 11,
              'request_type': 'general_feedback',
              'message': 'Hello',
              'status': 'new',
              'published_updates': [],
              'attachments': [],
            },
          }),
          201,
        );
      });

      final created = await RequestsApi(
        client: ApiClient(client: client),
      ).createFeedback(message: ' Hello ');

      expect(captured.method, 'POST');
      expect(captured.url.path, endsWith('/client/requests'));
      expect(
        captured.headers['content-type'],
        startsWith('multipart/form-data'),
      );
      expect(captured.body, contains('name="message"'));
      expect(captured.body, contains('Hello'));
      expect(created.id, 11);
    });
  });

  test('ScheduleOrder parses dispute actions', () {
    final order = ScheduleOrder.fromJson({
      'id': 7,
      'service_name': 'Cleaning',
      'available_actions': {
        'can_open_dispute': true,
        'dispute_deadline_at': '2026-09-08T10:00:00Z',
        'active_dispute': {'id': 44, 'status': 'open'},
      },
    });

    expect(order.canOpenDispute, isTrue);
    expect(order.disputeDeadlineAt, contains('2026-09-08'));
    expect(order.activeDispute?['id'], 44);
  });
}
