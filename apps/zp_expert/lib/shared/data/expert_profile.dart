import 'package:flutter/foundation.dart';

enum ExpertRole { psychologist, astrologer }

extension ExpertRoleLabel on ExpertRole {
  String get label {
    switch (this) {
      case ExpertRole.psychologist:
        return 'Psychologist';
      case ExpertRole.astrologer:
        return 'Astrologer';
    }
  }
}

@immutable
class ExpertProfile {
  const ExpertProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isVerified,
  });

  final String id;
  final String name;
  final ExpertRole role;
  final String avatarUrl;
  final bool isVerified;
}