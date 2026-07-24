import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';
import 'package:zp_expert/shared/data/expert_session.dart';
import 'package:zp_expert/shared/data/expert_session_repository.dart';
import 'package:zp_expert/shared/network/expert_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  test('submitted shared profile refreshes the authenticated expert session',
      () async {
    final List<String> requestedNames = <String>[];
    int sessionSequence = 0;
    final MockClient client = MockClient((http.Request request) async {
      final Map<String, dynamic> body =
          Map<String, dynamic>.from(jsonDecode(request.body) as Map);
      final String displayName = body['displayName'] as String;
      requestedNames.add(displayName);
      sessionSequence++;
      return http.Response(
        jsonEncode(<String, dynamic>{
          'success': true,
          'data': <String, dynamic>{
            'principal': <String, dynamic>{
              'id': 'expert-$sessionSequence',
              'displayName': displayName,
            },
            'accessToken': 'token-$sessionSequence',
          },
        }),
        201,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        expertApiClientProvider.overrideWithValue(
          ExpertApiClient(baseUrl: 'https://example.test', client: client),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(client.close);

    final ExpertSession defaultSession =
        await container.read(expertSessionProvider.future);
    expect(defaultSession.displayName, 'Aditya');

    await container.read(expertProfileRepositoryProvider).saveDraftProfile(
          name: 'Arjun Mehta',
        );
    await container
        .read(expertProfileRepositoryProvider)
        .activateDraftProfile();
    container.invalidate(expertProfileProvider);
    container.invalidate(expertSessionProvider);

    final ExpertSession submittedSession =
        await container.read(expertSessionProvider.future);
    expect(submittedSession.displayName, 'Arjun Mehta');
    expect(submittedSession.accessToken, 'token-2');
    expect(requestedNames, <String>['Aditya', 'Arjun Mehta']);
  });
}
