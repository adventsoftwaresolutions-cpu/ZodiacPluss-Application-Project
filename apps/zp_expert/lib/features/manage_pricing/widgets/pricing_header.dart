import 'package:flutter/material.dart';

class PricingHeader extends StatelessWidget {
  const PricingHeader({required this.onBackTap, super.key});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const SizedBox(width: 8),
          const Text(
            'Manage Pricing/Offers',
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
          ),
        ],
      );
}
