import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';
import '../models/chat_conversation_model.dart';
import '../models/session_summary_model.dart';
import '../repository/chat_conversation_repository.dart';

final Provider<ChatConversationRepository> chatConversationRepositoryProvider =
    Provider<ChatConversationRepository>(
  (Ref ref) => StubChatConversationRepository(),
);

final AsyncNotifierProviderFamily<ChatConversationController,
        ChatConversationModel, String> chatConversationProvider =
    AsyncNotifierProvider.family<ChatConversationController,
        ChatConversationModel, String>(ChatConversationController.new);

class ChatConversationController
    extends FamilyAsyncNotifier<ChatConversationModel, String> {
  @override
  Future<ChatConversationModel> build(String threadId) async {
    final ExpertProfile profile = await ref.watch(expertProfileProvider.future);
    return ref.watch(chatConversationRepositoryProvider).fetchConversation(
          threadId: threadId,
          expertRole: profile.role,
        );
  }

  Future<void> sendText(String text) async {
    final ChatConversationModel? current = state.valueOrNull;
    final String value = text.trim();
    if (current == null || current.isPsychologist || value.isEmpty) return;
    final ChatMessageModel message = await ref
        .read(chatConversationRepositoryProvider)
        .sendText(threadId: current.threadId, text: value);
    state = AsyncData<ChatConversationModel>(
      current.copyWith(messages: <ChatMessageModel>[
        ...current.messages,
        message,
      ]),
    );
  }

  Future<void> sendDocument(String documentName) async {
    final ChatConversationModel? current = state.valueOrNull;
    if (current == null || current.isPsychologist) return;
    final ChatMessageModel message =
        await ref.read(chatConversationRepositoryProvider).sendDocument(
              threadId: current.threadId,
              documentName: documentName,
            );
    state = AsyncData<ChatConversationModel>(
      current.copyWith(messages: <ChatMessageModel>[
        ...current.messages,
        message,
      ]),
    );
  }

  Future<void> saveSessionSummary({
    required String presentingConcern,
    required String summaryNote,
    required String homework,
    required List<RecommendedExercise> exercises,
    SessionSummaryModel? summaryToEdit,
  }) async {
    final ChatConversationModel? current = state.valueOrNull;
    if (current == null || !current.isPsychologist) {
      return;
    }
    final List<ChatMessageModel> summaries = current.messages
        .where((ChatMessageModel message) =>
            message.type == ChatMessageType.sessionSummary)
        .toList();
    if (summaryToEdit != null &&
        (summaries.isEmpty || summaries.last.summary?.id != summaryToEdit.id)) {
      return;
    }
    if (summaryToEdit == null && current.sessionSummary != null) {
      return;
    }
    final ChatMessageModel saved =
        await ref.read(chatConversationRepositoryProvider).saveSessionSummary(
              threadId: current.threadId,
              sessionId: summaryToEdit?.sessionId ?? current.sessionId,
              userConcern: summaryToEdit?.userConcern ?? current.userConcern,
              presentingConcern: presentingConcern,
              summaryNote: summaryNote,
              homework: homework,
              exercises: exercises,
              summaryId: summaryToEdit?.id,
            );
    final List<ChatMessageModel> messages = summaryToEdit == null
        ? <ChatMessageModel>[...current.messages, saved]
        : current.messages
            .map((ChatMessageModel message) =>
                message.id == summaryToEdit.id ? saved : message)
            .toList();
    state = AsyncData<ChatConversationModel>(
      current.copyWith(messages: messages),
    );
  }
}
