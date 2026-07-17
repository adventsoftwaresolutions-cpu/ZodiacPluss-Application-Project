import 'package:flutter/material.dart';

class CallParticipantAvatar extends StatelessWidget {
  const CallParticipantAvatar({
    required this.name,
    this.radius = 62,
    super.key,
  });

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius,
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: .22),
        child: Text(
          _initials(name),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: radius * .42,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  String _initials(String value) {
    final List<String> words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
