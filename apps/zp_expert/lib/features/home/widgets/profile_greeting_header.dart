// widgets/profile_greeting_header.dart
import 'package:flutter/material.dart';
import '../data/availability_status.dart';
import '../../../shared/widgets/shimmer_box.dart';

class ProfileGreetingHeader extends StatelessWidget {
  const ProfileGreetingHeader({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isVerified,
    required this.status,
    super.key,
  });

  final String name;
  final String role;
  final String avatarUrl;
  final bool isVerified;
  final AvailabilityStatus status;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Avatar(
              avatarUrl: avatarUrl,
              isOnline: status.isOnline,
              radius: compact ? 34 : 42,
            ),
            SizedBox(width: compact ? 10 : 16),
            Expanded(
              child: _ProfileSummary(
                name: name,
                role: role,
                isVerified: isVerified,
                status: status,
                nameFontSize: compact ? 22 : 26,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({
    required this.name,
    required this.role,
    required this.isVerified,
    required this.status,
    required this.nameFontSize,
  });

  final String name;
  final String role;
  final bool isVerified;
  final AvailabilityStatus status;
  final double nameFontSize;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Good Morning,',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              if (isVerified) ...<Widget>[
                const SizedBox(width: 6),
                const _VerifiedBadge(),
              ],
            ],
          ),
          const SizedBox(height: 2),
          _RolePill(role: role),
          const SizedBox(height: 6),
          _AvailabilityStatus(status: status),
        ],
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.avatarUrl,
    required this.isOnline,
    required this.radius,
  });

  final String avatarUrl;
  final bool isOnline;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(avatarUrl),
          ),
        ),
        Positioned(
          bottom: 7,
          right: 7,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> anim) {
              return ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child));
            },
            child: Container(
              // key ensures AnimatedSwitcher distinguishes between online/offline
              key: ValueKey<bool>(isOnline),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF3E9B5C),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 14),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFD6EDEF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        role,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _AvailabilityStatus extends StatelessWidget {
  const _AvailabilityStatus({required this.status});

  final AvailabilityStatus status;

  @override
  Widget build(BuildContext context) {
    final bool online = status.isOnline;
    final Color color = online ? const Color(0xFF2CA340) : Colors.red;
    final String text = online
        ? 'Available for sessions'
        : 'Back at ${_formatTime(status.offlineUntil)}';

    return Row(
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

String _formatTime(DateTime? time) {
  if (time == null) return '—';
  final int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final String period = time.hour >= 12 ? 'PM' : 'AM';
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}

class ProfileGreetingHeaderSkeleton extends StatelessWidget {
  const ProfileGreetingHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;
        final double avatarSize = compact ? 74 : 90;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(
              width: avatarSize,
              height: avatarSize,
              borderRadius: avatarSize / 2,
            ),
            SizedBox(width: compact ? 10 : 16),
            const Expanded(child: _ProfileSummarySkeleton()),
          ],
        );
      },
    );
  }
}

class _ProfileSummarySkeleton extends StatelessWidget {
  const _ProfileSummarySkeleton();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ShimmerBox(width: double.infinity, height: 14),
          SizedBox(height: 8),
          ShimmerBox(width: double.infinity, height: 22),
          SizedBox(height: 8),
          ShimmerBox(width: double.infinity, height: 18, borderRadius: 7),
          SizedBox(height: 10),
          ShimmerBox(width: double.infinity, height: 12),
        ],
      );
}
