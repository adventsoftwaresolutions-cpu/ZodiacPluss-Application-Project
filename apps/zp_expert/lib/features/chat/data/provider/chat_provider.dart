import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';
import '../models/chat_thread_model.dart';
import '../repository/chat_repository.dart';

final Provider<ChatRepository> chatRepositoryProvider =
    Provider<ChatRepository>((Ref ref) => StubChatRepository());

final FutureProvider<ChatInboxModel> chatInboxProvider =
    FutureProvider<ChatInboxModel>((Ref ref) async {
  final ExpertProfile profile = await ref.watch(expertProfileProvider.future);
  final ChatInboxModel inbox =
      await ref.watch(chatRepositoryProvider).fetchClientChats(profile.role);
  return inbox.latestFirst();
});
