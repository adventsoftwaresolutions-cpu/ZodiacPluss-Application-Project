import 'package:flutter/material.dart';

class ProgressStatRow extends StatelessWidget {
  const ProgressStatRow({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isLast = false,
    super.key,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    accentColor.withValues(alpha: 0.14),
                    Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D3B3E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class StatValue extends StatelessWidget {
  const StatValue({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
