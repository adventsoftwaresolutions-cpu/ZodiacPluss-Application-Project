import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/expert_api_client.dart';
import 'expert_profile_repository.dart';
import 'expert_session.dart';

abstract class ExpertSessionRepository {
  Future<ExpertSession> getOrCreateSession();
  Future<T> authenticated<T>(Future<T> Function(String accessToken) request);
  Future<void> clearSession();
}

class SecureExpertSessionRepository implements ExpertSessionRepository {
  SecureExpertSessionRepository({
    required ExpertApiClient api,
    required FlutterSecureStorage storage,
    required Future<String> Function() displayName,
  })  : _api = api,
        _storage = storage,
        _displayName = displayName;

  static const String _storageKey = 'zp_demo_expert_session';

  final ExpertApiClient _api;
  final FlutterSecureStorage _storage;
  final Future<String> Function() _displayName;
  ExpertSession? _cached;
  Future<ExpertSession>? _pending;

  @override
  Future<ExpertSession> getOrCreateSession() {
    if (_cached != null) return Future<ExpertSession>.value(_cached);
    return _pending ??= _restoreOrCreate().whenComplete(() => _pending = null);
  }

  Future<ExpertSession> _restoreOrCreate() async {
    final String? stored = await _storage.read(key: _storageKey);
    if (stored != null) {
      try {
        _cached = ExpertSession.fromJson(
          Map<String, dynamic>.from(jsonDecode(stored) as Map),
        );
        return _cached!;
      } catch (_) {
        await clearSession();
      }
    }
    final dynamic data = await _api.post(
      '/api/v1/demo/expert-sessions',
      body: <String, dynamic>{'displayName': await _displayName()},
    );
    final ExpertSession session =
        ExpertSession.fromJson(Map<String, dynamic>.from(data as Map));
    _cached = session;
    await _storage.write(key: _storageKey, value: jsonEncode(session.toJson()));
    return session;
  }

  @override
  Future<T> authenticated<T>(
    Future<T> Function(String accessToken) request,
  ) async {
    ExpertSession session = await getOrCreateSession();
    try {
      return await request(session.accessToken);
    } on ExpertApiException catch (error) {
      if (error.statusCode != 401) rethrow;
      await clearSession();
      session = await getOrCreateSession();
      return request(session.accessToken);
    }
  }

  @override
  Future<void> clearSession() async {
    _cached = null;
    _pending = null;
    await _storage.delete(key: _storageKey);
  }
}

final Provider<FlutterSecureStorage> secureStorageProvider =
    Provider<FlutterSecureStorage>(
  (Ref ref) => const FlutterSecureStorage(),
);

final Provider<ExpertSessionRepository> expertSessionRepositoryProvider =
    Provider<ExpertSessionRepository>((Ref ref) {
  return SecureExpertSessionRepository(
    api: ref.watch(expertApiClientProvider),
    storage: ref.watch(secureStorageProvider),
    displayName: () async =>
        (await ref.read(expertProfileProvider.future)).name,
  );
});

final FutureProvider<ExpertSession> expertSessionProvider =
    FutureProvider<ExpertSession>((Ref ref) {
  return ref.watch(expertSessionRepositoryProvider).getOrCreateSession();
});
