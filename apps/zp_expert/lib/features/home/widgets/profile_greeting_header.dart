// widgets/profile_greeting_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileGreetingHeader extends StatelessWidget {
  const ProfileGreetingHeader({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isVerified,
    required this.isAvailable,
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
  });

  final String name;
  final String role;
  final String avatarUrl;
  final bool isVerified;
  final bool isAvailable;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Avatar(avatarUrl: avatarUrl, isOnline: isAvailable),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Good Morning,',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
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
              if (isAvailable) ...<Widget>[
                const SizedBox(height: 6),
                const _AvailabilityStatus(),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        _IconButtonCircle(
          assetPath: 'assets/icons/notification.svg',
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 10),
        _IconButtonCircle(
          assetPath: 'assets/icons/chat.svg',
          onTap: onChatTap,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl, required this.isOnline});

  final String avatarUrl;
  final bool isOnline;

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
            radius: 42,
            backgroundImage: AssetImage(avatarUrl),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 7,
            right: 7,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E0F8),
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Color(0xFF3D2E6B),
        ),
      ),
    );
  }
}

class _AvailabilityStatus extends StatelessWidget {
  const _AvailabilityStatus();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: Color(0xFF2CA340)),
        SizedBox(width: 6),
        Text(
          'Available for sessions',
          style: TextStyle(color: Color(0xFF2CA340), fontSize: 12),
        ),
      ],
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  const _IconButtonCircle({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  static const double _diameter = 35;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: _diameter,
          height: _diameter,
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: 18,
              height: 18,
            ),
          ),
        ),
      ),
    );
  }
}
