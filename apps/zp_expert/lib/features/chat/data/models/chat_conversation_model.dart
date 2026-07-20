import '../../../../shared/data/expert_profile.dart';
import 'session_summary_model.dart';

enum ChatMessageSender { client, expert, system }

enum ChatMessageType { text, document, sessionSummary }

class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.type,
    required this.sentAt,
    this.text = '',
    this.documentName,
    this.summary,
  });

  final String id;
  final ChatMessageSender sender;
  final ChatMessageType type;
  final DateTime sentAt;
  final String text;
  final String? documentName;
  final SessionSummaryModel? summary;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json['id'] as String,
        sender: ChatMessageSender.values.byName(json['sender'] as String),
        type: ChatMessageType.values.byName(json['type'] as String),
        sentAt: DateTime.parse(json['sentAt'] as String),
        text: json['text'] as String? ?? '',
        documentName: json['documentName'] as String?,
        summary: json['summary'] == null
            ? null
            : SessionSummaryModel.fromJson(
                json['summary'] as Map<String, dynamic>,
              ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sender': sender.name,
        'type': type.name,
        'sentAt': sentAt.toIso8601String(),
        'text': text,
        'documentName': documentName,
        'summary': summary?.toJson(),
      };
}

class ChatConversationModel {
  const ChatConversationModel({
    required this.threadId,
    required this.sessionId,
    required this.clientId,
    required this.clientName,
    required this.consultationLabel,
    required this.expertRole,
    required this.isOnline,
    required this.userConcern,
    required this.messages,
  });

  final String threadId;
  final String sessionId;
  final String clientId;
  final String clientName;
  final String consultationLabel;
  final ExpertRole expertRole;
  final bool isOnline;
  final String userConcern;
  final List<ChatMessageModel> messages;

  bool get isPsychologist => expertRole == ExpertRole.psychologist;

  SessionSummaryModel? get sessionSummary {
    for (final ChatMessageModel message in messages.reversed) {
      if (message.type == ChatMessageType.sessionSummary &&
          message.summary?.sessionId == sessionId) {
        return message.summary;
      }
    }
    return null;
  }

  bool get needsSessionSummary => isPsychologist && sessionSummary == null;

  ChatConversationModel copyWith({List<ChatMessageModel>? messages}) =>
      ChatConversationModel(
        threadId: threadId,
        sessionId: sessionId,
        clientId: clientId,
        clientName: clientName,
        consultationLabel: consultationLabel,
        expertRole: expertRole,
        isOnline: isOnline,
        userConcern: userConcern,
        messages: messages ?? this.messages,
      );

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      ChatConversationModel(
        threadId: json['threadId'] as String,
        sessionId: json['sessionId'] as String,
        clientId: json['clientId'] as String,
        clientName: json['clientName'] as String,
        consultationLabel: json['consultationLabel'] as String,
        expertRole: ExpertRole.values.byName(json['expertRole'] as String),
        isOnline: json['isOnline'] as bool? ?? false,
        userConcern: json['userConcern'] as String? ?? '',
        messages: (json['messages'] as List<dynamic>)
            .map((dynamic item) =>
                ChatMessageModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'threadId': threadId,
        'sessionId': sessionId,
        'clientId': clientId,
        'clientName': clientName,
        'consultationLabel': consultationLabel,
        'expertRole': expertRole.name,
        'isOnline': isOnline,
        'userConcern': userConcern,
        'messages': messages
            .map((ChatMessageModel message) => message.toJson())
            .toList(),
      };
}
