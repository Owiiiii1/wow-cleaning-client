import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/widgets/service_survey_modal.dart';

void main() {
  test('survey API sends all scores and trimmed comment', () async {
    late http.Request captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({
          'success': true,
          'data': {'submitted': true, 'survey_id': 1},
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = InboxApi(client: ApiClient(client: client));

    await api.submitSurvey(
      42,
      cleaningQuality: 5,
      punctuality: 4,
      communication: 3,
      serviceConvenience: 5,
      improvementComment: '  More precise arrival time  ',
    );

    expect(captured.url.path, endsWith('/client/inbox/42/survey'));
    expect(jsonDecode(captured.body), {
      'cleaning_quality': 5,
      'punctuality': 4,
      'communication': 3,
      'service_convenience': 5,
      'improvement_comment': 'More precise arrival time',
    });
  });

  testWidgets('survey requires all four scores and submits answers', (
    tester,
  ) async {
    final api = _FakeInboxApi();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (_) => ServiceSurveyModal(messageId: 42, api: api),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    var submit = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(submit.onPressed, isNull);

    final fives = find.byTooltip('5');
    expect(fives, findsNWidgets(4));
    for (var index = 0; index < 4; index++) {
      await tester.tap(fives.at(index));
      await tester.pump();
    }

    submit = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(submit.onPressed, isNotNull);
    await tester.tap(find.text('Send feedback'));
    await tester.pumpAndSettle();

    expect(api.submittedMessageId, 42);
    expect(api.submittedScores, [5, 5, 5, 5]);
  });
}

class _FakeInboxApi extends InboxApi {
  int? submittedMessageId;
  List<int>? submittedScores;

  @override
  Future<void> submitSurvey(
    int id, {
    required int cleaningQuality,
    required int punctuality,
    required int communication,
    required int serviceConvenience,
    String? improvementComment,
  }) async {
    submittedMessageId = id;
    submittedScores = [
      cleaningQuality,
      punctuality,
      communication,
      serviceConvenience,
    ];
  }
}
