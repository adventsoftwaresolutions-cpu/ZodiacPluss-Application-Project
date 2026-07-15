import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/client_lists.dart';
import '../models/client_history_model.dart';
import '../repository/client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>(
  (ref) => LocalClientRepository(),
);

final clientsProvider = FutureProvider<ClientLists>((ref) async {
  return ref.watch(clientRepositoryProvider).fetchClients();
});

final clientHistoryProvider = FutureProvider.family<ClientHistoryModel, String>(
  (ref, clientId) =>
      ref.read(clientRepositoryProvider).fetchClientHistory(clientId),
);

final clientNotesProvider =
    AsyncNotifierProvider<ClientNotesNotifier, Map<String, String>>(
  ClientNotesNotifier.new,
);

class ClientNotesNotifier extends AsyncNotifier<Map<String, String>> {
  @override
  Future<Map<String, String>> build() async => <String, String>{};

  Future<void> save(String clientId, String note) async {
    await ref.read(clientRepositoryProvider).saveClientNote(clientId, note);
    final Map<String, String> notes = state.valueOrNull ?? <String, String>{};
    state = AsyncData(<String, String>{...notes, clientId: note});
  }
}

final cancelledClientSessionsProvider =
    AsyncNotifierProvider<CancelledClientSessionsNotifier, Set<String>>(
  CancelledClientSessionsNotifier.new,
);

class CancelledClientSessionsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async => <String>{};

  Future<void> cancel(String sessionId) async {
    await ref.read(clientRepositoryProvider).cancelFutureSession(sessionId);
    final Set<String> cancelled = state.valueOrNull ?? <String>{};
    state = AsyncData(<String>{...cancelled, sessionId});
  }
}
