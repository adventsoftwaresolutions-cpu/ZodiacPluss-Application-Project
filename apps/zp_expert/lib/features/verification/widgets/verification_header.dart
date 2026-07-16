import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerificationHeader extends StatelessWidget {
  const VerificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xffE5E7EB),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: Color(0xff111827),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Complete Verification",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Almost there! Please complete your professional information to verify your profile.",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: const Color(0xff6B7280),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            "assets/icons/shield.svg",
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
