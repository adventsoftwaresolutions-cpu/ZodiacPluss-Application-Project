import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session_history_model.dart';
import '../repository/session_history_repository.dart';

final sessionHistoryRepositoryProvider = Provider<SessionHistoryRepository>(
  (ref) => StubSessionHistoryRepository(),
);

final sessionHistoryProvider = FutureProvider<List<SessionHistoryModel>>(
  (ref) => ref.read(sessionHistoryRepositoryProvider).getSessionHistory(),
);

final sessionDetailProvider = FutureProvider.family<SessionDetailModel, String>(
  (ref, sessionId) =>
      ref.read(sessionHistoryRepositoryProvider).getSessionDetail(sessionId),
);

final blockedClientsProvider =
    AsyncNotifierProvider<BlockedClientsNotifier, Set<String>>(
  BlockedClientsNotifier.new,
);

class BlockedClientsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async => <String>{};

  Future<void> block(String clientId) async {
    await ref.read(sessionHistoryRepositoryProvider).blockClient(clientId);
    final Set<String> blocked = state.valueOrNull ?? <String>{};
    state = AsyncData(<String>{...blocked, clientId});
  }
}
