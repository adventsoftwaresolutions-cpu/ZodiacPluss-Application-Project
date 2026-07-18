import '../../../../shared/data/expert_profile.dart';

class ChatThreadModel {
  const ChatThreadModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.consultationLabel,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.lastMessageSentByExpert,
    required this.isOnline,
  });

  final String id;
  final String clientId;
  final String clientName;
  final String consultationLabel;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool lastMessageSentByExpert;
  final bool isOnline;

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) =>
      ChatThreadModel(
        id: json['id'] as String,
        clientId: json['clientId'] as String,
        clientName: json['clientName'] as String,
        consultationLabel: json['consultationLabel'] as String,
        lastMessage: json['lastMessage'] as String,
        lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
        unreadCount: json['unreadCount'] as int? ?? 0,
        lastMessageSentByExpert:
            json['lastMessageSentByExpert'] as bool? ?? false,
        isOnline: json['isOnline'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'clientId': clientId,
        'clientName': clientName,
        'consultationLabel': consultationLabel,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt.toIso8601String(),
        'unreadCount': unreadCount,
        'lastMessageSentByExpert': lastMessageSentByExpert,
        'isOnline': isOnline,
      };
}

class ChatInboxModel {
  const ChatInboxModel({required this.expertRole, required this.threads});

  final ExpertRole expertRole;
  final List<ChatThreadModel> threads;

  int get unreadThreads =>
      threads.where((ChatThreadModel thread) => thread.unreadCount > 0).length;

  ChatInboxModel latestFirst() {
    final List<ChatThreadModel> sorted = List<ChatThreadModel>.of(threads)
      ..sort((ChatThreadModel a, ChatThreadModel b) =>
          b.lastMessageAt.compareTo(a.lastMessageAt));
    return ChatInboxModel(expertRole: expertRole, threads: sorted);
  }

  factory ChatInboxModel.fromJson(Map<String, dynamic> json) => ChatInboxModel(
        expertRole: ExpertRole.values.byName(json['expertRole'] as String),
        threads: (json['threads'] as List<dynamic>)
            .map((dynamic item) =>
                ChatThreadModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'expertRole': expertRole.name,
        'threads':
            threads.map((ChatThreadModel item) => item.toJson()).toList(),
      };
}
