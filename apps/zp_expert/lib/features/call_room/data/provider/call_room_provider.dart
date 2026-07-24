import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_core/zp_core.dart';

import '../../../../shared/network/expert_api_client.dart';
import '../../../../shared/data/expert_session_repository.dart';
import '../repository/call_room_repository.dart' as expert_repo;

/// Override the shared [callRoomRepositoryProvider] with the expert-specific
/// concrete implementation.
///
/// This provider is what wires [ApiCallRoomRepository] (which depends on
/// [ExpertApiClient] and [ExpertSessionRepository]) into the shared
/// [CallSessionController] from zp_core.
final Provider<CallRoomRepository> expertCallRoomRepositoryProvider =
    Provider<CallRoomRepository>((Ref ref) {
  return expert_repo.ApiCallRoomRepository(
    api: ref.watch(expertApiClientProvider),
    sessions: ref.watch(expertSessionRepositoryProvider),
  );
});
