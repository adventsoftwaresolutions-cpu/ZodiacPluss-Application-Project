import 'package:flutter/foundation.dart';

@immutable
class ExpertSession {
  const ExpertSession({
    required this.accessToken,
    required this.principalId,
    required this.displayName,
  });

  factory ExpertSession.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> principal =
        Map<String, dynamic>.from(json['principal'] as Map);
    return ExpertSession(
      accessToken: json['accessToken'] as String,
      principalId: principal['id'] as String,
      displayName: principal['displayName'] as String,
    );
  }

  final String accessToken;
  final String principalId;
  final String displayName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'accessToken': accessToken,
        'principal': <String, dynamic>{
          'id': principalId,
          'displayName': displayName,
        },
      };
}
