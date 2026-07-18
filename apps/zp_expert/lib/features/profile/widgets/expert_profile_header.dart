import 'package:flutter/material.dart';

import '../../../shared/data/expert_profile.dart';
import '../../home/data/availability_status.dart';

class ExpertProfileHeader extends StatelessWidget {
  const ExpertProfileHeader({
    required this.profile,
    required this.availability,
    required this.onEditBasicInfo,
    required this.onPhotoTap,
    super.key,
  });

  final ExpertProfile profile;
  final AvailabilityStatus availability;
  final VoidCallback onEditBasicInfo;
  final VoidCallback onPhotoTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Expert Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  disabledForegroundColor: Colors.white54,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 17),
                label: const Text('Preview'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 43,
                      backgroundImage: AssetImage(profile.avatarUrl),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 3,
                    child: IconButton.filled(
                      onPressed: onPhotoTap,
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.photo_camera_outlined, size: 17),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            profile.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        if (profile.isVerified) ...<Widget>[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded,
                              color: Color(0xFF2DB861), size: 22),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6EDEF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        profile.role.label,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        Icon(Icons.circle,
                            size: 10,
                            color: availability.isOnline
                                ? const Color(0xFF2DB861)
                                : Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            availability.isOnline
                                ? 'Online · Available for sessions'
                                : 'Offline',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: availability.isOnline
                                  ? const Color(0xFF318D56)
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onEditBasicInfo,
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              side: BorderSide.none,
            ),
            icon: const Icon(Icons.edit_outlined, size: 17),
            label: const Text('Edit Basic Info'),
          ),
        ],
      );
}
