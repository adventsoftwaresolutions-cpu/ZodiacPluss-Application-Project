import 'package:flutter/material.dart';

class LoyalUserNote extends StatelessWidget {
  const LoyalUserNote({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFFFFF3DD),
            borderRadius: BorderRadius.circular(12)),
        child: const Row(children: <Widget>[
          CircleAvatar(
              backgroundColor: Color(0xFFFFE6AE),
              child: Icon(Icons.note_alt_outlined, color: Color(0xFFB87500))),
          SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text('Note',
                    style: TextStyle(
                        color: Color(0xFFB87500), fontWeight: FontWeight.w700)),
                Text(
                    'Users with more than 20+ completed sessions with you will be considered as loyal users.',
                    style: TextStyle(color: Color(0xFF6B6C70), height: 1.25))
              ]))
        ]),
      );
}
