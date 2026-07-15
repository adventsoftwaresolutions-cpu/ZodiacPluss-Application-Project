import 'package:flutter/material.dart';

class PricingIntroCard extends StatelessWidget {
  const PricingIntroCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFD2F0F2),
              child: Icon(Icons.confirmation_number_outlined,
                  color: Color(0xFF007D88), size: 28),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('You’re in Control',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 2),
                  Text(
                      'Set your prices for normal and loyal user. You can change them anytime.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6F7477),
                          height: 1.35)),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.account_balance_wallet_rounded,
                color: Color(0xFF007D88), size: 30),
          ],
        ),
      );
}
