import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.caption,
    super.key,
  });

  final String iconPath;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6FA6A0), width: 1.2),
            ),
            child: Center(
              child: SvgPicture.asset(iconPath, width: 26, height: 26),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2B5A55),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}