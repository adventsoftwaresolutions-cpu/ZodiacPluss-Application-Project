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
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 340;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ProfileIdentityRow(
                profile: profile,
                availability: availability,
                onPhotoTap: onPhotoTap,
                showPreviewInline: !compact,
              ),
              if (compact) ...<Widget>[
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: _PreviewButton(),
                ),
              ],
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
        },
      );
}

class _ProfileIdentityRow extends StatelessWidget {
  const _ProfileIdentityRow({
    required this.profile,
    required this.availability,
    required this.onPhotoTap,
    required this.showPreviewInline,
  });

  final ExpertProfile profile;
  final AvailabilityStatus availability;
  final VoidCallback onPhotoTap;
  final bool showPreviewInline;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ProfileAvatar(profile: profile, onPhotoTap: onPhotoTap),
          const SizedBox(width: 16),
          Expanded(
            child: _ProfileSummary(
              profile: profile,
              availability: availability,
            ),
          ),
          if (showPreviewInline) ...<Widget>[
            const SizedBox(width: 8),
            const _PreviewButton(),
          ],
        ],
      );
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profile, required this.onPhotoTap});

  final ExpertProfile profile;
  final VoidCallback onPhotoTap;

  @override
  Widget build(BuildContext context) => Stack(
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
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.photo_camera_outlined, size: 17),
            ),
          ),
        ],
      );
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.profile, required this.availability});

  final ExpertProfile profile;
  final AvailabilityStatus availability;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  profile.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              if (profile.isVerified) ...<Widget>[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF2DB861),
                  size: 22,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
              Icon(
                Icons.circle,
                size: 10,
                color: availability.isOnline
                    ? const Color(0xFF2DB861)
                    : Colors.grey,
              ),
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
      );
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton();

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: Colors.white70,
          side: const BorderSide(color: Colors.white54),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        icon: const Icon(Icons.visibility_outlined, size: 16),
        label: const Text('Preview'),
      );
}
