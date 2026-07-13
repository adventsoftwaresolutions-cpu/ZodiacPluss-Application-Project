import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManagePricingCard extends StatelessWidget {
  const ManagePricingCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/icons/offer.svg',
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Manage Pricing/Offers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D3B3E),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}